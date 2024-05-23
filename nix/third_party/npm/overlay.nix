{ pkgs, third-party, fetchFromGitHub, buildGoModule, esbuild}:
let
  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.21.3";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-tGKwjk6yNY+cni5dGKSLc+d0Tz0JtqvuVNqX4YYPTYY=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };

  # replaces esbuild's download script with a binary from nixpkgs
  patchEsbuild = es: ''
    mkdir -p node_modules/esbuild/bin
    ${pkgs.jq}/bin/jq "del(.scripts.postinstall)" package.json | ${pkgs.moreutils}/bin/sponge package.json
    ln -s -f ${es}/bin/esbuild node_modules/esbuild/bin/esbuild
  '';

  inherit (third-party.beamPackages) phoenix phoenix_live_view phoenix_html;
in
self: super: {
  "esbuild@${esbuild'.version}" = super."esbuild@${esbuild'.version}".overrideAttrs (attrs: {
    # this will force nix to complain if versions for binary and npm package are mismatched
    version = esbuild'.version;
    patchPhase = patchEsbuild esbuild';
  });
  "phoenix" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix"; };
    inherit (phoenix) src version;
  };
  "phoenix@${phoenix.version}" = self."phoenix";
  "phoenix@*" = self."phoenix";
  "phoenix_live_view" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix_live_view"; };
    inherit (phoenix_live_view) src version;
  };
  "phoenix_live_view@${phoenix_live_view.version}" = self."phoenix_live_view";
  "phoenix_live_view@*" = self."phoenix_live_view";
  "phoenix_html" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix_html"; };
    inherit (phoenix_html) src version;
  };
  "phoenix_html@${phoenix_html.version}" = self."phoenix_html";
  "phoenix_html@*" = self."phoenix_html";
}
