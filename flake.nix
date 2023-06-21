{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    nixpkgs.inputs.flake-utils.follows = "flake-utils";
    nixpkgs.inputs.nix-filter.follows = "nix-filter";
    ligo-nix.url = "github:ulrikstrid/ligo-nix";
    ligo-nixpkgs.follows = "ligo-nix/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix-filter,
    ligo-nix,
    ligo-nixpkgs, 
  }: let
    out = system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          # overlays go here
        ];
      };
      # Did this hack because Ligo wasn't building otherwise
      pkgs' = import ligo-nixpkgs { 
        inherit system;
        overlays = [ ligo-nix.overlays.default];
      };
      inherit (pkgs) lib;
      myPkgs =
        pkgs.recurseIntoAttrs
        (import ./nix {
          inherit pkgs;
          nix-filter = nix-filter.lib;
          doCheck = true;
        })
        .native;
      myDrvs = lib.filterAttrs (_: value: lib.isDerivation value) myPkgs;
    in {
      devShell = pkgs.mkShell {
        inputsFrom = lib.attrValues myDrvs;
        buildInputs = with pkgs;
        with ocamlPackages; [
          ocaml-lsp
          ocamlformat
          odoc
          ocaml
          dune_3
          nixfmt
          pkgs'.ligo 
        ];
      };

      defaultPackage = myPkgs.service;

      defaultApp = {
        type = "app";
        program = "${self.defaultPackage.${system}}/bin/service";
      };
    };
  in
    with flake-utils.lib; eachSystem defaultSystems out;
}
