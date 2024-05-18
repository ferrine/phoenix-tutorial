{ third-party, stdenv, nodejs, lib } :
let
  inherit (third-party.npmPackages) makeNodeModules;
  node-modules = makeNodeModules ./package.json {};
  in
  stdenv.mkDerivation {
    src = lib.cleanSource ./.;
    name = "pento-assets";
    preConfigure = ''
      ln -s ${node-modules} node_modules
    '';
    nativeBuildInputs = [
      nodejs
    ];
    passthru = {
      inherit node-modules;
    };
    buildPhase = ''
      mkdir $out
      node build.js $out
    '';
}
