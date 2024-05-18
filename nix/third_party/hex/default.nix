{ pkgs, ... }:
pkgs.callPackage ./mix.lock.nix {
  overrides = pkgs.callPackage ./overlay.nix { };
}
