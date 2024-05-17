{ pkgs, ... }:
let
  mixlock =
    let
      mix_lock = ./mix.lock;
    in
    pkgs.runCommand "mix.nix"
      {
        nativeBuildInputs = [ pkgs.mix2nix ];
      } ''
      mix2nix ${mix_lock} > $out
    '';
in
pkgs.callPackage mixlock {}
