# Python workspace packages
{
  pkgs,
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (pkgs) lib;

  # Create package for the main project - wrap the binary without including Python interpreter
  pythonPackages = 
    if uvBoilerplate.pythonSet ? ${pythonProject.projectName}
    then {
      ${pythonProject.projectName} = pkgs.stdenv.mkDerivation {
        name = "${pythonProject.projectName}-${uvBoilerplate.pythonSet.${pythonProject.projectName}.version}";
        
        # Create a minimal package with just the executable
        buildInputs = [ uvBoilerplate.pythonSet.${pythonProject.projectName} ];
        
        unpackPhase = "true"; # No source to unpack
        
        installPhase = ''
          mkdir -p $out/bin
          
          # Create a wrapper script for the template binary that sets up PYTHONPATH
          cat > $out/bin/${pythonProject.projectName} << EOF
          #!/usr/bin/env bash
          export PYTHONPATH="${uvBoilerplate.pythonSet.${pythonProject.projectName}}/lib/python3.13/site-packages:\$PYTHONPATH"
          exec ${uvBoilerplate.python}/bin/python -m ${pythonProject.projectName}.main "\$@"
          EOF
          
          chmod +x $out/bin/${pythonProject.projectName}
        '';
        
        meta = {
          description = "Template Python project";
          mainProgram = pythonProject.projectName;
        };
      };
    }
    else {};

in pythonPackages
