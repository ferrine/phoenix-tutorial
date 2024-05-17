{ callPackage, third-party, fetchFromGitHub, ... }:
let
  env = third-party.lib.js2nix.buildEnv {
    package-json = ./package.json;
    yarn-lock-nix = ./yarn.lock.nix;
  };
in env
