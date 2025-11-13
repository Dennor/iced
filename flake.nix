{
  description = "Description for the project";

  inputs = {
    # Change to 25.11 when released
    nixpkgs.url = "github:NixOS/nixpkgs/staging-nixos";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {nixpkgs.follows = "nixpkgs";};
    };
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mk-shell-bin = {
      url = "github:rrbutani/nix-mk-shell-bin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      withSystem,
      flake-parts-lib,
      ...
    }: let
      inherit
        (import ./nix/lib/import.nix {
          inherit (flake-parts-lib) importApply;
          inherit withSystem inputs;
          localFlake = self;
        })
        importFromPathList
        ;
    in {
      imports = importFromPathList ./nix/flakemodules;
      systems = ["x86_64-linux"];
    });
}
