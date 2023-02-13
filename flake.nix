{

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-22.11;

   rank1dynamic.url = github:haskell-distributed/rank1dynamic;
   rank1dynamic.flake = false;

   binaryhash.url = gitlab:pkravchuk/binaryhash;
   binaryhash.flake = false;

   distributed-process.url = github:haskell-distributed/distributed-process;
   distributed-process.flake = false;

   distributed-process-async.url = github:haskell-distributed/distributed-process-async;
   distributed-process-async.flake = false;

   hyperion-static.url = gitlab:davidsd/hyperion-static;
   hyperion-static.flake = false;

  };

  outputs = inputs@{ self, ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
    in
      {

        hpkgs = pkgs.callPackage ./hpkgs.nix { inherit inputs; };

        hlib = pkgs.haskell.lib;

        packages.${system}.default = self.hpkgs.hyperion;

        devShells.${system} =
          self.hpkgs
          // {
            default = self.hpkgs.shellFor
              {
                packages = hp: [
                  #hp.binaryhash
                  #hp.rank1dynamic
                  #hp.network-transport
                  #hp.network-transport-tcp
                  #hp.distributed-static
                  # hp.distributed-process
                  #hp.distributed-process-async
                  #hp.hyperion-static
                  hp.hyperion
                ];
              };
          };

      };
}
