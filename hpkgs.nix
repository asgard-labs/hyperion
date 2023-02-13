{ fetchFromGitHub
, fetchFromGitLab
, haskell
, hlib ? haskell.lib
, inputs
, resolver ? "lts-18.10" }:

let

  ghc-nix-name = inputs.stackage2nix-simple.stackage.get-ghc-nix-name resolver;

  haskellPackages = haskell.packages.${ghc-nix-name};

  pkg-identifiers =
    __fromJSON (
      __readFile "${inputs.stackage2nix-simple}/pkg-identifiers/${resolver}.json");

  pkg-versions = __mapAttrs (_: { name, version }: version ) pkg-identifiers;

  hpkgs = haskellPackages.extend (hlib.packageSourceOverrides{

    hyperion = ./.;

    hyperion-static = fetchFromGitLab {
      owner = "davidsd";
      repo = "hyperion-static";
      rev = "83e504f6e37d3cd4eb254477b9f1684e6686b8c0";
      sha256 = "sha256-TohzhdI4MJPfHrTiMc7DBkMTqYf38wSce1/Kw0UPvqQ=";
    };

    binaryhash =  fetchFromGitLab {
      owner = "pkravchuk";
      repo = "binaryhash";
      rev = "f5760f1912b97bdb9fe5ed5ce635010065c0c612";
      sha256 = "sha256-DHdW1fQ7hr5BSnK57tGF7TOJ6+zqZGv08ftrf84xVDE=";
    };

    rank1dynamic = fetchFromGitHub {
      owner = "haskell-distributed";
      repo = "rank1dynamic";
      rev = "53c5453121592453177370daa06f098cb014c0d3";
      sha256 = "sha256-SmDhpAA97NPTF7WiYKUQNNeCpR4yO9iQrtflJXiTu8c=";
    };

    network-transport-tcp = fetchFromGitHub {
      owner = "davidsd";
      repo = "network-transport-tcp";
      rev = "feea8507d25390c57d531c4ab8894f58e716c721";
      sha256 = "sha256-v5y1YmEoKVHDCOG9MLjI7h/UtBV457tJKZ1ZWXaO92k=";
    };

    distributed-process = fetchFromGitHub {
      owner = "davidsd";
      repo = "distributed-process";
      rev = "144818f5174522ee4a027a4681ec047e0567c11b";
      sha256 = "sha256-TaDJks5uMWDDYIc5Q65s+cYSO74RKgV1hJoRBJAahGA=";
    };

    distributed-process-async = fetchFromGitHub {
      owner = "davidsd";
      repo = "distributed-process-async";
      rev = "bfb2a156965fe62ed30c7eacfc09a410bb7c3705";
      sha256 = "sha256-9Azb5wBwtdqm1thUWXMZfFgfT0U7H4kE7zgBsQDO9sc=";
    };

    inherit (pkg-versions) network network-transport-tests;

    #inherit (pkg-versions) random;
    #inherit (pkg-versions) hashable stm mim-types; #random containers;

    random = "1.1";

  });

  override = hself: hsuper: {
    random = hlib.dontCheck hsuper.random;
  };

in hpkgs.extend override
