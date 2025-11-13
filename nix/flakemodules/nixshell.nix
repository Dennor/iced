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
        config.treefmt.build.wrapper
        pkgsStatic.gcc
        clang
      ];
      # # Deps for wayland on linux, need an alternative path on darwin.
      # env.RUSTFLAGS = lib.mkForce "-C link-args=-rpath,${with pkgs;
      #   lib.makeLibraryPath [
      #     libGL
      #     libxkbcommon
      #     wayland
      #     xorg.libX11
      #     xorg.libXcursor
      #     xorg.libXi
      #     xorg.libXrandr
      #     dbus
      #   ]}";
      git-hooks.hooks.treefmt = {
        enable = true;
        packageOverrides.treefmt = config.treefmt.build.wrapper;
      };

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
