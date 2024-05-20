{lib}:
{
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
      expandAttrs = itemList:
        lib.listToAttrs (map
          (dep: {name = nameFn dep; value = dep;})
          itemList);
      expandIteration = point:
        point // (lib.mergeAttrsList
          (map
            (item: expandAttrs (expandFn item))
            (builtins.attrValues point)));
      in
    lib.converge expandIteration seed;
}
