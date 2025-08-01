# Overlay creation and management
{
  inputs,
  pkgs,
  lib,
  stdenv,
  pythonProject,
  workspaceData,
  ...
}: let
  inherit (inputs) pyproject-build-systems;
  inherit (workspaceData) workspace allWorkspaces;

  # Create package overlay from root workspace (includes all packages)
  baseOverlay = workspace.mkPyprojectOverlay {
    # Prefer prebuilt binary wheels as a package source
    sourcePreference = "wheel";
  };

  # Create a filtered overlay that excludes workspace packages without src directories
  overlay = final: prev: let
    # Get all packages from the base overlay
    basePackages = baseOverlay final prev;

    # Get names of all workspace packages (including root)
    allWorkspaceNames = map (ws: ws.name) allWorkspaces;

    # Filter out only the workspace packages that don't have src directories
    filteredPackages =
      lib.filterAttrs (
        name: value:
        # Keep the package if:
        # 1. It's not a workspace package (external dependency like matplotlib)
        # 2. OR it's a workspace package that has a src directory
          !(lib.elem name allWorkspaceNames) || (lib.any (ws: ws.name == name && builtins.pathExists (ws.directory + "/src")) allWorkspaces)
      )
      basePackages;
  in
    filteredPackages;

  # Import override modules
  buildSystemOverrides = import ./build-systems.nix {inherit pkgs lib;};
  workspaceOverrides = import ./workspace-overrides.nix {inherit lib stdenv pythonProject;};

  # Extend generated overlay with build fixups for all packages
  pyprojectOverrides = final: prev:
    # Combine build system overrides and workspace overrides
    (buildSystemOverrides.mkBuildSystemOverrides final prev)
    // (workspaceOverrides.mkWorkspaceOverrides final prev workspaceData.buildableWorkspaces);

  # Create editable overlay only for packages with src directories
  # Filter out packages without src directories (like the root workspace)
  packagesWithSrc = lib.filter (ws: builtins.pathExists (ws.directory + "/src")) allWorkspaces;

  # Create a single editable overlay for all workspace members
  editableOverlay = workspace.mkEditablePyprojectOverlay {
    root = "$REPO_ROOT";
    # Include all workspace members that have src directories
    members = map (ws: ws.name) packagesWithSrc;
  };

in {
  inherit 
    baseOverlay
    overlay
    pyprojectOverrides
    editableOverlay
    packagesWithSrc;
}
