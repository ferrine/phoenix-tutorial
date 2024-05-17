{ callPackage, lib, fetchFromGitHub, ... }:
let
  env = lib.js2nix.buildEnv {
    package-json = ./package.json;
    yarn-lock-nix = ./yarn.lock.nix;
  };
in env
