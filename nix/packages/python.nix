# Python workspace packages
{
  pkgs,
  uvBoilerplate,
  ...
}: let
  inherit (pkgs) lib;

  # Create packages for all workspaces that have executable outputs
  pythonPackages = lib.listToAttrs (
    map (ws: {
      name = ws.name;
      value =
        uvBoilerplate.pythonSet.mkVirtualEnv
        "${ws.name}-env"
        uvBoilerplate.workspaces.${ws.name}.deps.default;
    }) (lib.filter (ws: uvBoilerplate.pythonSet ? ${ws.name}) uvBoilerplate.allWorkspaces)
  );

in pythonPackages
