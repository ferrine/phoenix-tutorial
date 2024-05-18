const esbuild = require('esbuild');

// args
var args = process.argv.slice(2);

esbuild.build({
  entryPoints: ['js/app.js'],
  bundle: true,
  target: 'es2017',
  outdir: args[0],
  external: ['/fonts/*', '/images/*']
}).catch(() => process.exit(1));
