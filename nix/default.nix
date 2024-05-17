{ pkgs, lib, ... }: lib.makeScope pkgs.newScope (
  self:
  {
    third-party = {
      lib = lib.packagesFromDirectoryRecursive {
        callPackage = self.callPackage;
        directory = ./third_party/lib;
      };
      beamPackages = self.callPackage ./third_party/hex { };
      npmPackages = self.callPackage ./third_party/npm { };
    };
    priv = lib.packagesFromDirectoryRecursive {
      callPackage = self.callPackage;
      directory = ../src;
    };
    shells = lib.packagesFromDirectoryRecursive {
      callPackage = self.callPackage;
      directory = ./shells;
    };
  }
)
