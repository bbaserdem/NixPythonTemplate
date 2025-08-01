# Application definitions - modular app management
{
  pkgs,
  inputs,
  system,
  uvBoilerplate,
  pythonProject,
  outputs,
  ...
}: let
  inherit (pkgs) lib;

  # Import app modules
  pythonApps = import ./python.nix {
    inherit pkgs uvBoilerplate pythonProject outputs;
  };

  scriptApps = import ./scripts.nix {
    inherit pkgs outputs;
  };

in {}
// pythonApps  # Python workspace applications
// scriptApps  # Custom runnable scripts
