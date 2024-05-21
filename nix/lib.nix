{ lib, pkgs, runCommand, writeText, concatText }:
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

  mixDepsGet = name: mix-nix:
    let
      mix-deps = mixDeps mix-nix;
      deps-paths = lib.mapAttrsToList (name: drv: { inherit name; path = drv.src; }) mix-deps;
    in
    pkgs.linkFarm name deps-paths;

  mixLockEntry = lock: name:
    runCommand "mix-lock-${name}" { } ''
      ${pkgs.gnugrep}/bin/grep '"${name}":' ${lock} > $out
    '';

  mixLockFrom = lock: name: mix-nix:
    let
      mix-deps = mixDeps mix-nix;
      start = writeText "mix-lock-begin" "%{";
      end = writeText "mix-lock-end" "}\n";
    in
      concatText name (lib.flatten [
        start
        (map (mixLockEntry lock) (builtins.attrNames mix-deps))
        end
      ]);
}
