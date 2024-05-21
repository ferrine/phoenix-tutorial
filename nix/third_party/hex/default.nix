{ pkgs, priv, ... }:
let
  mixLock = priv.lib.mixLockFrom ./mix.lock;
  mixDepsInstall = priv.lib.mixDepsInstallFrom ./mix.lock;
in
pkgs.callPackage ./mix.lock.nix
  {
    overrides = pkgs.callPackage ./overlay.nix { };
  } // {
  inherit (priv.lib) mixDepsGet;
  inherit mixLock mixDepsInstall;
}
