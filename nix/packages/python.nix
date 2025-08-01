# Python workspace packages
{
  pkgs,
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (pkgs) lib;

  # Create a pure Python package (library package) for workspace packages
  createLibraryPackage = packageName:
    if uvBoilerplate.pythonSet ? ${packageName}
    then {
      ${packageName} = uvBoilerplate.pythonSet.${packageName};
    }
    else {};

  # Create a wrapper package with executable for packages that have scripts
  createExecutablePackage = packageName:
    if uvBoilerplate.pythonSet ? ${packageName}
    then {
      ${packageName} = pkgs.stdenv.mkDerivation {
        name = "${packageName}-${uvBoilerplate.pythonSet.${packageName}.version}";
        
        # Create a minimal package with just the executable
        buildInputs = [ uvBoilerplate.pythonSet.${packageName} ];
        
        unpackPhase = "true"; # No source to unpack
        
        installPhase = ''
          mkdir -p $out/bin
          
          # Create a wrapper script for the binary that sets up PYTHONPATH
          cat > $out/bin/${packageName} << EOF
          #!/usr/bin/env bash
          export PYTHONPATH="${uvBoilerplate.pythonSet.${packageName}}/lib/python3.13/site-packages:\$PYTHONPATH"
          exec ${uvBoilerplate.python}/bin/python -m ${packageName}.main "\$@"
          EOF
          
          chmod +x $out/bin/${packageName}
        '';
        
        meta = {
          description = "${packageName} Python project";
          mainProgram = packageName;
        };
      };
    }
    else {};

  # Get all workspace package names
  allWorkspacePackages = 
    (if pythonProject.emptyRoot then [] else [pythonProject.projectName])
    ++ (map (ws: ws.projectName) pythonProject.workspaces);

  # Create packages for all workspace packages
  # Main project gets executable wrapper, workspace packages get library packages
  mainProjectPackages = 
    if pythonProject.emptyRoot then {} 
    else createExecutablePackage pythonProject.projectName;

  workspaceLibraryPackages = lib.foldl' (acc: packageName: 
    acc // (createLibraryPackage packageName)
  ) {} (map (ws: ws.projectName) pythonProject.workspaces);

in mainProjectPackages // workspaceLibraryPackages
