# Python project spec
{
  # Parent-only fields
  emptyRoot = true;         # Root workspace contains a Python package
  workspaces = [            # Workspace package definitions
    {
      projectName = "math-utils";
      projectRoot = "./packages/math-utils";
      # projectDir is optional - defaults to "src/math_utils"
    }
    {
      projectName = "text-utils";
      projectRoot = "./packages/text-utils";
      # projectDir is optional - defaults to "src/text_utils"
    }
  ];
  
  # Project spec fields  
  projectName = "template";
  projectRoot = ".";
  # projectDir is optional - if not defined, defaults to "src/<sanitizedName>"
}
