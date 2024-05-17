{
  perSystem = { pkgs, ... } @localFlake:
    rec {
      legacyPackages = pkgs.callPackage ./default.nix { };
      devShells.default = legacyPackages.shells.default;
    };
}
