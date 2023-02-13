{

  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.stackage2nix-simple.url = github:asgard-labs/stackage2nix-simple;

  outputs = inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
    in
      {

        hpkgs = pkgs.callPackage ./hpkgs.nix {
          inherit inputs; };

        devShells.${system} =
          self.hpkgs
          // {
            default = self.hpkgs.shellFor
              {
                packages = hp: [ hp.hyperion ];
              };
          };

      };
}
