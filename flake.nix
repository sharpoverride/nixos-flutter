  {
    description = "Flutter example flake for Zero to Nix";

    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
      android-nixpkgs.url = "https://github.com/tadfisher/android-nixpkgs.git";
      gitignore = {
        url = "github:hercules-ci/gitignore.nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = { self, nixpkgs, android-nixpkgs, gitignore }:
      let 
        # Systems supported
        allSystems = [
          "x86_64-linux" # 64-bit Intel/AMD Linux
          "aarch64-linux" # 64-bit ARM Linux
          "x86_64-darwin" # 64-bit Intel macOS
          "aarch64-darwin" # 64-bit ARM macOS
         #basics
          "flutter" "git"
          #linux build
          "at-spi2-core.dev" "clang" "cmake" "dbus.dev" "flutter gtk3" "libdatrie" "libepoxy.dev" "util-linux.dev" "libselinux" "libsepol" "libthai" "libxkbcommon" "ninja" "pcre" "pcre2.dev" "lpkg-config" "xorg.libXdmcp" "xorg.libXtst"
          #android build
          # (android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; ["cmdline-tools-latest" "build-tools-32-0-0" "tools" "patcher-v4" "platform-tools platforms-android-31" "system-images-android-31-default-x86-64" "emulator"])) "jdk8" "unzip"
          #web build
          "chromium"
        ];

        # Helper to provide system-specific attributes
        forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
          pkgs = import nixpkgs { inherit system; };
        });
      in
      {
        packages = forAllSystems ({ pkgs }: {
          default = pkgs.buildGoModule {
            name = "zero-to-nix-flutter";
            src = gitignore.lib.gitignoreSource ./.;
            vendorSha256 = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
          };
        });
      };
  }
