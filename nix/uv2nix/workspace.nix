# Workspace loading and management
{
  inputs,
  pythonProject,
  lib,
  ...
}: let
  inherit (inputs) uv2nix;

  # Helper function to sanitize project names for directory names
  sanitizeName = name: builtins.replaceStrings ["-"] ["_"] name;

  # Convert new spec to legacy format for compatibility
  toLegacyProject = spec: {
    name = spec.projectName;
    directory = spec.projectRoot;
    workspaces = map toLegacyProject (spec.workspaces or []);
  };

  # Helper function to recursively collect all workspaces
  collectWorkspaces = project: let
    subWorkspaces = lib.flatten (map collectWorkspaces (project.workspaces or []));
  in
    [project] ++ subWorkspaces;

  # Convert pythonProject to legacy format and collect all workspaces
  legacyProject = toLegacyProject pythonProject;
  allWorkspaces = collectWorkspaces legacyProject;

  # Create a map of project names to their directories
  projectDirs = lib.listToAttrs (map (ws: {
      name = ws.name;
      value = sanitizeName ws.name;
    })
    allWorkspaces);

  # Load the root workspace (which includes all nested packages)
  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = pythonProject.projectRoot;
  };

  # Load individual workspaces for granular access
  workspaces = lib.listToAttrs (map (ws: {
      name = ws.name;
      value = uv2nix.lib.workspace.loadWorkspace {
        workspaceRoot = ws.directory;
      };
    })
    allWorkspaces);

  # Filter workspaces to only include those with src directories for building
  buildableWorkspaces = lib.filter (ws: builtins.pathExists (ws.directory + "/src")) allWorkspaces;

  # Create a filtered workspace that only includes packages with src directories
  filteredWorkspaceMembers = map (ws: ws.name) buildableWorkspaces;

in {
  inherit 
    sanitizeName
    collectWorkspaces
    allWorkspaces
    projectDirs
    workspace
    workspaces
    buildableWorkspaces
    filteredWorkspaceMembers;
}
