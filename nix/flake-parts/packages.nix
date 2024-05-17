{
  perSystem = { pkgs, ... } @localFlake:
    {
      legacyPackages = pkgs.callPackage ../default.nix { };
    };
}
