{
  description = "TODO";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO: Switch back to upstream blueprint once these are fixed
    #  - https://github.com/numtide/blueprint/issues/33
    #  - https://github.com/numtide/blueprint/issues/35
    blueprint.url = "github:adam-gaia/blueprint/all-changes"; #"github:numtide/blueprint";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.blueprint {inherit inputs;};
}
