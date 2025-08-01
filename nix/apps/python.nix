# Python workspace applications
{
  pkgs,
  uvBoilerplate,
  pythonProject,
  outputs,
  ...
}: let
  inherit (pkgs) lib;

  # Create app for the main project if it has executable outputs
  pythonApps = 
    if uvBoilerplate.pythonSet ? ${pythonProject.projectName}
    then {
      ${pythonProject.projectName} = {
        type = "app";
        program = "${outputs.packages.${pkgs.system}.${pythonProject.projectName}}/bin/${pythonProject.projectName}";
      };
    }
    else {};

in pythonApps
