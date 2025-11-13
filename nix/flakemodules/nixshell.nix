_args: {inputs, ...}: {
  imports = [inputs.devenv.flakeModule];
  perSystem = {
    config,
    pkgs,
    lib,
    self',
    ...
  }: let
    helixShell = {
      # https://devenv.sh/reference/options/
      packages = with pkgs; [
        pkgsStatic.gcc
        pkgsStatic.wayland
        clang
        pkg-config
      ];

      enterShell = ''
        ${config.packages.helix-config}/bin/helix-config
      '';
      languages = {
        javascript = {
          enable = true;
          bun = {
            enable = true;
            install.enable = true;
          };
        };
        rust = {
          enable = true;
          toolchainFile = ../../rust-toolchain.toml;
        };
      };
    };
  in {
    devenv = {
      shells = {
        inherit helixShell;
        default = helixShell;
      };
    };
  };
}
