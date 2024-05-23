# One Version Yarn

I want to implement a node modules builder with an idea of one version rule

* it should be possible to well with monorepos like https://github.com/carbon-design-system/carbon-for-ibm-dotcom/tree/main/packages/web-components
* not indended for just one project, but many smaller projects, each having its own package.json
* overrides should be possible on monorepo level and project level as well

```bash
# add package to the monorepo
one-yarn add [package, ...]
# use a package from monorepo, raise an error if not exists
one-yarn use [package, ...]
# to be continued
```
