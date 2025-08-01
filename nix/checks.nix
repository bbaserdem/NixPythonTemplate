{
  uvBoilerplate,
  pythonProject,
  ...
}: let
  inherit (uvBoilerplate) lib;
  
  # Create checks for the main project if it has tests
  pythonChecks = 
    if (uvBoilerplate.pythonSet ? ${pythonProject.projectName}) && 
       (uvBoilerplate.pythonSet.${pythonProject.projectName}.passthru ? tests) &&
       (uvBoilerplate.pythonSet.${pythonProject.projectName}.passthru.tests ? pytest) 
    then {
      "${pythonProject.projectName}-pytest" = uvBoilerplate.pythonSet.${pythonProject.projectName}.passthru.tests.pytest;
    }
    else {};
in pythonChecks