{ pkgs, ... }:
pkgs.callPackage ./mix.lock.nix {
    # overrides = pkgs.callPackage ./overrides.nix {};
}
