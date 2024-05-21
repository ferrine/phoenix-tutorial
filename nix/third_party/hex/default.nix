{ pkgs, priv, ... }:
let
  mixLock = priv.lib.mixLockFrom ./mix.lock;
in
pkgs.callPackage ./mix.lock.nix {
  overrides = pkgs.callPackage ./overlay.nix { };
} // {inherit mixLock;}
