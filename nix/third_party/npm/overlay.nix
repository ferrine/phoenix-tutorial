{ third-party }:
let
  inherit (third-party.beamPackages) phoenix phoenix_live_view phoenix_html;
in
self: super: {
  "phoenix" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix"; };
    inherit (phoenix) src version;
  };
  "phoenix@${phoenix.version}" = self.phoenix;
  "phoenix_live_view" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix_live_view"; };
    inherit (phoenix_live_view) src version;
  };
  "phoenix_live_view@${phoenix_live_view.version}" = self."phoenix_live_view";
  "phoenix_html" = self.buildNodeModule {
    id = { scope = ""; name = "phoenix_html"; };
    inherit (phoenix_live_view) src version;
  };
  "phoenix_html@${phoenix_html.version}" = self."phoenix_html";
}
