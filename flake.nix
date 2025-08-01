{
  description = "Python project template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Python project setup
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    outputs = self;
    pythonProject = import ./nix/python.nix;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      # Grab UV stuff
      pkgs = import nixpkgs {inherit system;};
      uvBoilerplate = import nix/uv2nix {
        inherit inputs system pythonProject pkgs;
      };
    in {
      checks = import ./nix/checks.nix {
        inherit uvBoilerplate pythonProject;
      };
      apps = import ./nix/apps {
        inherit outputs pkgs inputs system uvBoilerplate pythonProject;
      };
      packages = import ./nix/packages {
        inherit pkgs inputs system uvBoilerplate;
      };
      devShells = import ./nix/shells {
        inherit pkgs inputs system uvBoilerplate;
      };
    });
}
