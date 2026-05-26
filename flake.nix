{
  description = "System packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.claude-code-nix.url = "github:sadjow/claude-code-nix";

  outputs =
    { nixpkgs, claude-code-nix, ... }:
    let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "acli"
        ];
      };
      # https://github.com/NixOS/nixpkgs/issues/513019
      direnv = pkgs.direnv.overrideAttrs { doCheck = false; };
      cb = pkgs.stdenvNoCC.mkDerivation {
        pname = "cb";
        version = "3.6.7";
        src = pkgs.fetchurl {
          url = "https://github.com/CrunchyData/bridge-cli/releases/download/v3.6.7/cb-v3.6.7_macos_arm64.zip";
          hash = "sha256:1dspnx9sicwg01sa58abhhfy1646cpsqyw6jhirqg7k7kwzfbs4v";
        };
        nativeBuildInputs = [ pkgs.unzip ];
        sourceRoot = ".";
        installPhase = ''
          mkdir -p $out/bin
          cp cb $out/bin/
        '';
      };
    in
    {
      packages.aarch64-darwin.zippy = pkgs.buildEnv {
        name = "zippy-packages";
        paths = with pkgs; [
          # ==============================================================================
          # GNU SYSTEM REPLACEMENTS
          # ==============================================================================
          coreutils
          diffutils
          findutils
          gawk
          getopt
          gnugrep
          gnused
          gnutar
          gnumake
          time
          which
          less

          # ==============================================================================
          # MODERN CLI REWRITES
          # ==============================================================================
          bat
          eza
          fd
          ripgrep

          # ==============================================================================
          # GENERAL CLI UTILITIES
          # ==============================================================================
          curl
          fzf
          jq
          unixtools.watch
          wget

          # ==============================================================================
          # SHELL & INTERACTIVE ENVIRONMENT
          # ==============================================================================
          bash
          direnv # overridden above with doCheck = false
          fish
          neovim
          starship
          tmux

          # ==============================================================================
          # DEVELOPER TOOLCHAIN
          # ==============================================================================
          chezmoi
          claude-code-nix.packages.aarch64-darwin.default
          devenv
          gh
          git
          lazygit
          mise

          # ==============================================================================
          # CLOUD, CONTAINERS & KUBERNETES
          # ==============================================================================
          awscli2
          acli
          cb
          colima
          heroku
          docker-client
          k9s
          kubectl
          kubectx

          # ==============================================================================
          # SECURITY & CRYPTOGRAPHY
          # ==============================================================================
          gnupg
          openssl
          pinentry_mac

          # ==============================================================================
          # LANGUAGE SERVERS & FORMATTERS
          # ==============================================================================
          # Nix
          nil
          nixfmt-rfc-style

          # Lua
          lua-language-server
          stylua

          # Tree-sitter
          tree-sitter
        ];
      };
    };
}
