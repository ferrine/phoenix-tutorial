{ callPackage, lib, third-party, ... }:
let
  inherit (third-party.lib.js2nix) buildEnv makeNodeModules;
  env = buildEnv {
    package-json = ./package.json;
    yarn-lock-nix = ./yarn.lock.nix;
    overlays = [
      (self: super: {
        # TODO: remove once this https://github.com/canva-public/js2nix/issues/20 is resolved
        buildNodeModule = lib.makeOverridable
          (args: (super.buildNodeModule args).override { doCheck = false; });
      })
      (callPackage ./overlay.nix { })
    ];
  };
in
{
  # provide tree for comprehensive setups
  tree = env.pkgs;
  # and closure helpers for subpackages
  makeNodeModules =
    package-json: args:
    makeNodeModules package-json ({ tree = env.pkgs; } // args);
}
