# As-JsonMinify

Minify JSON files in WebAssembly. Written in AssemblyScript.

### Node CLI

Build:

```ps1
npm install
npm run build.node
```

Run:

```ps1
node ./dist/node/cli.js json_file_path
```

### Node API

```ts
import { minify } from "./dist/node/lib.js"

await minify(`
  {"some_json":   "here"}
`)
```

### Browser App

```
npm install
npm run build.browser
npm run start.browser
```

### Browser API

```
npm install
npm run build.browser
```

```ts
import { minify } from "./dist/browser/lib.js"

await minify(`
  {"some_json":   "here"}
`)
```

### Wasm API

Build:

```ps1
npm install
npm run build.wasm
```

`./dist/index.wasm`

```ts
export function minify(jsonString: string): string
```

### Wasi example

Build:

```ps1
npm install
npm run build.wasi
```

Run:

```bash
wasmtime ./dist/wasi.wasm '  {"some_json":   "here"}  '
```

Note: In PowerShell, you need to escape `"` using `\`.

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
