{ pkgs, lib, ... }: lib.makeScope pkgs.newScope (
  self:
  {
    third-party.beamPackages = self.callPackage ./third_party/hex { };
    priv = lib.packagesFromDirectoryRecursive {
      callPackage = self.callPackage;
      directory = ../src;
    };
  }
)
