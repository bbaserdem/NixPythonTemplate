# Workspace package overrides for editable installs and testing
{
  lib,
  stdenv,
  pythonProject,
  ...
}: {
  # Create workspace package overrides
  mkWorkspaceOverrides = final: prev: buildableWorkspaces: let
    # Apply overrides to each workspace package
    overridePackage = name:
      prev.${name}.overrideAttrs (old: {
        passthru =
          old.passthru
          // {
            tests = let 
              # Include the package with core testing tools
              testEnv = {
                ${name} = [];
              } 
              // (lib.optionalAttrs (final ? pytest) { pytest = []; })
              // (lib.optionalAttrs (final ? pytest-cov) { pytest-cov = []; });
              
              virtualenv = final.mkVirtualEnv "${name}-pytest-env" testEnv;
            in
              (old.tests or {})
              // {
                pytest = stdenv.mkDerivation {
                  name = "${final.${name}.name}-pytest";
                  inherit (final.${name}) src;
                  nativeBuildInputs = [
                    virtualenv
                  ];
                  dontConfigure = true;
                  buildPhase = ''
                    runHook preBuild
                    pytest --cov tests --cov-report html
                    runHook postBuild
                  '';
                  installPhase = ''
                    runHook preInstall
                    mv htmlcov $out
                    runHook postInstall
                  '';
                };
              };
          };
      });

    # Apply overrides only to buildable workspace packages
    workspaceOverrides = lib.listToAttrs (map (ws: {
      name = ws.name;
      value =
        if prev ? ${ws.name}
        then overridePackage ws.name
        else null;
    }) (lib.filter (ws: prev ? ${ws.name}) buildableWorkspaces));
  in
    workspaceOverrides;

  # Create editable package overrides
  mkEditableOverrides = final: prev: allWorkspaces: projectDirs: let
    # Helper function to sanitize project names for directory names
    sanitizeName = name: builtins.replaceStrings ["-"] ["_"] name;

    # Check if a package has a src directory (legacy format)
    hasSrcDir = ws: builtins.pathExists (ws.directory + "/src");
    
    # Check if a project spec has a src directory (new format)
    hasProjectSrcDir = spec: builtins.pathExists (spec.projectDir or (spec.projectRoot + "/src/" + sanitizeName spec.projectName));

    # Apply editable fixups to each workspace package that has src
    makeEditable = ws:
      if hasSrcDir ws
      then {
        name = ws.name;
        value = prev.${ws.name}.overrideAttrs (old: {
          src = lib.fileset.toSource {
            root = ws.directory;
            fileset = lib.fileset.unions [
              (ws.directory + "/pyproject.toml")
              (ws.directory + "/README.md")
              (ws.directory + "/src/${projectDirs.${ws.name}}")
            ];
          };

          # Hatchling (build system) has a dependency on the editables package when building editables
          # In normal python flows this dependency is dynamically handled, in PEP660
          # With Nix, the dependency needs to be explicitly declared
          nativeBuildInputs =
            old.nativeBuildInputs
            ++ final.resolveBuildSystem {
              editables = [];
            };
        });
      }
      else {
        # For packages without src, don't make them editable
        name = ws.name;
        value = prev.${ws.name};
      };

    # Handle the root package - check if it has src directory
    rootPackageOverride =
      if prev ? ${pythonProject.projectName}
      then
        if (!pythonProject.emptyRoot) && hasProjectSrcDir pythonProject
        then {
          # Root has src, make it editable
          ${pythonProject.projectName} = prev.${pythonProject.projectName}.overrideAttrs (old: {
            src = lib.fileset.toSource {
              root = pythonProject.projectRoot;
              fileset = lib.fileset.unions [
                (pythonProject.projectRoot + "/pyproject.toml")
                (pythonProject.projectRoot + "/README.md")
                (pythonProject.projectDir or (pythonProject.projectRoot + "/src/" + sanitizeName pythonProject.projectName))
              ];
            };

            nativeBuildInputs =
              old.nativeBuildInputs
              ++ final.resolveBuildSystem {
                editables = [];
              };
          });
        }
        else {
          # Root has no src or is empty, don't make it editable
          ${pythonProject.projectName} = prev.${pythonProject.projectName};
        }
      else {};
  in
    # Combine workspace and root package overrides
    lib.listToAttrs (map makeEditable (lib.filter (ws: prev ? ${ws.name}) allWorkspaces))
    // rootPackageOverride;
}
