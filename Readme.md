# minijson

Minify JSON files **blazing fast**! Written in D.

55 times faster than jsonminify!

[![CI](https://github.com/aminya/minijson/actions/workflows/CI.yml/badge.svg)](https://github.com/aminya/minijson/actions/workflows/CI.yml)

### Installation

- Nodejs

```
npm install @aminya/minijson
```

- CLI Binaries

You can also download the binaries for the CLI from the release page:

https://github.com/aminya/minijson/releases/tag/v0.4.0

- Dub

```
dub build --config=library --build=release-nobounds --compiler=ldc2
# or
dub build --config=executable --build=release-nobounds --compiler=ldc2
```

### CLI Usage

```
Usage: minify json
    minijson --file file1.json --file file2.json
    minijson --string '{"some_json": "string_here"}'

     --file an array of files to minify
   --string a json string to minify
-h   --help This help information.
```

### Node API

```js
import { minifyFiles, minifyString } from "minijson"

// minify the files in-place and in parallel
await minifyFiles(["file1.json", "file2.json"])

// minify the given string
const minifiedString = minifyString(`{"some_json": "here"}`)
```

**Note**: in the Nodejs API, prefer `minifyFiles` over other functions, as it minifies the files in parallel with the least amount of resources.

### D API

```js
import minijson: minifyString, minifyFiles;

// minify the given string
const minifiedString = minifyString(`{"some_json": "here"}`);

// minify the files in-place and in parallel
minifyFiles(["file1.json", "file2.json"]);
```

### Benchmarks

```
❯ node .\benchmark\native-benchmark.mjs
1.066 seconds

❯ node .\benchmark\js-benchmark.mjs
58.686 seconds
```

### Contributing

```
pnpm install
pnpm run build.node
```

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
