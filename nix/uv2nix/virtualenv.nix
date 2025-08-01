# Virtual environment creation and shell configuration
{
  lib,
  pkgs,
  python,
  pythonProject,
  pythonSets,
  workspaceData,
  ...
}: let
  inherit (pythonSets) editablePythonSet;
  inherit (workspaceData) workspace buildableWorkspaces;

  # Filter dependencies to only include buildable packages
  buildableDeps =
    lib.filterAttrs (
      name: deps:
        lib.any (ws: ws.name == name) buildableWorkspaces
    )
    workspace.deps.all;

  # Single virtualenv with only buildable packages
  virtualenv =
    editablePythonSet.mkVirtualEnv
    "${pythonProject.projectName}-dev-env"
    buildableDeps;

  # Shell configuration
  uvShellSet = {
    packages = [virtualenv pkgs.uv];
    env = {
      UV_NO_SYNC = "1";
      UV_PYTHON = python;
      UV_PYTHON_DOWNLOADS = "never";
    };
    shellHook = ''
      # Undo dependency propagation by nixpkgs.
      unset PYTHONPATH

      # Get repository root using git. This is expanded at runtime by the editable `.pth` machinery.
      export REPO_ROOT=$(git rev-parse --show-toplevel)
    '';
  };

in {
  inherit
    buildableDeps
    virtualenv
    uvShellSet;
}
