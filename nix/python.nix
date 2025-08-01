let
  repoRoot = ../.;
  
  # Helper function to sanitize project names (replace - with _)
  sanitizeName = name: builtins.replaceStrings ["-"] ["_"] name;
  
  # Python project spec
  spec = {
    # Parent-only fields
    emptyRoot = false;        # Root workspace contains a Python package
    workspaces = [];          # No additional workspaces (single package)
    
    # Project spec fields  
    projectName = "template";
    projectRoot = repoRoot;
    projectDir = repoRoot + "/src/" + sanitizeName "template";  # Default: projectRoot/src/<sanitized projectName>
  };
  
in spec
