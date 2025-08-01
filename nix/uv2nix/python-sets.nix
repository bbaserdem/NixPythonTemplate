# Python package set construction
{
  inputs,
  pkgs,
  lib,
  stdenv,
  pythonProject,
  python,
  overlayData,
  workspaceData,
  ...
}: let
  inherit (inputs) pyproject-nix pyproject-build-systems;
  inherit (overlayData) overlay pyprojectOverrides editableOverlay;
  inherit (workspaceData) projectDirs allWorkspaces;

  # Base python package set
  baseSet = pkgs.callPackage pyproject-nix.build.packages {inherit python;};

  # Construct package set with all overlays
  pythonSet = baseSet.overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default
      overlay
      pyprojectOverrides
    ]
  );

  # Import workspace overrides for editable packages
  workspaceOverrides = import ./workspace-overrides.nix {inherit lib stdenv pythonProject;};

  # Editable python set with fixups for all packages
  editablePythonSet = pythonSet.overrideScope (
    lib.composeManyExtensions [
      editableOverlay

      # Apply fixups for building editable packages
      (final: prev: workspaceOverrides.mkEditableOverrides final prev allWorkspaces projectDirs)
    ]
  );

in {
  inherit
    baseSet
    pythonSet
    editablePythonSet;
}
