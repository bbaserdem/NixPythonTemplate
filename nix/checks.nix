{
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (uvBoilerplate) lib;
  
  # Create a check for a package if it has tests
  createPackageCheck = packageName:
    if (uvBoilerplate.pythonSet ? ${packageName}) && 
       (uvBoilerplate.pythonSet.${packageName}.passthru ? tests) &&
       (uvBoilerplate.pythonSet.${packageName}.passthru.tests ? pytest) 
    then {
      "${packageName}-pytest" = uvBoilerplate.pythonSet.${packageName}.passthru.tests.pytest;
    }
    else {};

  # Get all workspace package names
  allPackageNames = 
    (if pythonProject.emptyRoot then [] else [pythonProject.projectName])
    ++ (map (ws: ws.projectName) pythonProject.workspaces);

  # Create checks for all workspace packages
  pythonChecks = lib.foldl' (acc: packageName: acc // (createPackageCheck packageName)) {} allPackageNames;
in pythonChecks