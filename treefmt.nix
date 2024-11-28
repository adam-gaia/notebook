{
  projectRootFile = "flake.nix"; # Consider using "github:srid/flake-root" as described in https://nixos.asia/en/treefmt
  programs = {
    alejandra.enable = true; # nix formatter
    deadnix.enable = true; # nix linter
    mdformat.enable = true; # markdown
    taplo.enable = true; # toml
    typos.enable = true; # spellcheck
  };
}
