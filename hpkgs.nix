{ fetchFromGitHub
, fetchFromGitLab
, haskell
, hlib ? haskell.lib
, ghc-nix-name ? "ghc924"
, inputs
}:

let

  haskellPackages = haskell.packages.${ghc-nix-name};

  hpkgs = haskellPackages.extend (hlib.packageSourceOverrides{

   hyperion = ./.;

   inherit (inputs)
      binaryhash
      rank1dynamic
      distributed-process
      distributed-process-async
      hyperion-static;

  });

  override = hself: hsuper: {

   distributed-static = hlib.doJailbreak hsuper.distributed-static;
   network-transport = hlib.doJailbreak hsuper.network-transport;
   distributed-process = hlib.doJailbreak hsuper.distributed-process;
   distributed-process-systest = hlib.doJailbreak hsuper.distributed-process-systest;

   distributed-process-async = hlib.doJailbreak (hlib.appendPatch hsuper.distributed-process-async ./patches/distributed-process-async.defaultTCPAddr.patch);
   hyperion-static = hlib.appendPatch hsuper.hyperion-static ./patches/hyperion-static.dictPat.patch;

  };

in hpkgs.extend override
