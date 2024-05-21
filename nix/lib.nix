{ lib, pkgs, runCommand, writeShellApplication, writeText, concatText }:
rec {
  /**
    Expand attribute set recursively.

    This appeared to be needed for creating development environment
    where all sources of transitive deps need to be stored in one place

    # Type
    ```
    expandFn :: AttrSet -> List<AttrSet>
    nameFn :: AttrSet -> String
    Seed :: AttrSet
    expandAttrs :: expandFn -> nameFn -> Seed -> AttrSet
    ```

    # Example
    ```
    expandAttrs (d: d.beamDeps) pkgs.lib.getName mixNixDeps
    ```
  **/
  expandAttrs = expandFn: nameFn: seed:
    let
      inherit (lib) nameValuePair;
      expandAttrs = itemList:
        lib.listToAttrs (map
          (dep: nameValuePair (nameFn dep) dep)
          itemList);
      expandIteration = point:
        point // (lib.mergeAttrsList
          (map
            (item: expandAttrs (expandFn item))
            (builtins.attrValues point)));
    in
    lib.converge expandIteration seed;

  mixDeps = mix-nix: expandAttrs (d: d.beamDeps) lib.getName mix-nix;

  mixDepsGet = mix-nix:
    let
      mix-deps = mixDeps mix-nix;
      deps-paths = lib.mapAttrsToList (name: drv: { inherit name; path = drv.src; }) mix-deps;
    in
    pkgs.linkFarm "mix-deps-get" deps-paths;

  mixLockEntry = lock: name:
    runCommand "mix-lock-${name}" { } ''
      ${pkgs.gnugrep}/bin/grep '"${name}":' ${lock} > $out
    '';

  mixLockFrom = lock: mix-nix:
    let
      mix-deps = mixDeps mix-nix;
      start = writeText "mix-lock-begin" "%{";
      end = writeText "mix-lock-end" "}\n";
    in
      concatText "mix-lock" (lib.flatten [
        start
        (map (mixLockEntry lock) (builtins.sort (a: b: a < b) (builtins.attrNames mix-deps)))
        end
      ]);

  mixDepsInstallFrom = lock: mix-nix:
    let
      mix-deps = mixDeps mix-nix;
      lock-file = mixLockFrom lock mix-deps;
      mix-deps-get = mixDepsGet mix-deps;
    in
      writeShellApplication {
        name = "mix-deps-install";
        text = ''
          ln -fs ${lock-file} mix.lock
          rm -rf deps
          cp --dereference --no-preserve mode -r ${mix-deps-get} deps
          # make sure it does not error
          mix deps.get
        '';
      };
}
