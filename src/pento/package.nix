{ callPackage, lib, priv, third-party, beamPackages }:
let
  inherit (beamPackages) mixRelease;
  mixNixDeps = with third-party.beamPackages; {
    inherit
      phoenix
      phoenix_ecto
      ecto_sql
      postgrex
      phoenix_html
      phoenix_live_reload
      phoenix_live_view
      floki
      phoenix_live_dashboard
      esbuild
      tailwind
      swoosh
      finch
      telemetry_metrics
      telemetry_poller
      gettext
      jason
      dns_cluster
      bandit;
  };
  assets = callPackage ./assets/package.nix {};
in
mixRelease {
  pname = "pento";
  version = "0.0.1";
  src = lib.cleanSource ./.;
  preConfigure = ''
    cp -r ${assets} priv/static/assets
    chmod +w -R priv/static/assets
  '';
  postConfigure = ''
    mix phx.digest --no-deps-check
  '';
  inherit mixNixDeps;
  passthru = {inherit assets;};
}
