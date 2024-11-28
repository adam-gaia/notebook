{
  projectRootFile = "flake.nix"; # Consider using "github:srid/flake-root" as described in https://nixos.asia/en/treefmt
  programs = {
    alejandra.enable = true; # nix formatter
    deadnix.enable = true; # nix linter
    stylua.enable = true; # format lua
    just.enable = true; # format justfiles
    mdformat.enable = true; # markdown
    jsonfmt.enable = true; # json
    yamlfmt.enable = true; # yaml
    taplo.enable = true; # toml
    typos.enable = true; # spellcheck
    shellcheck.enable = true; # lint shell scripts
    shfmt.enable = true; # format shell scripts
  };
}
