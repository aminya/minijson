# minijson

Minify JSON files **fast**! Written in D.

1.5 times faster than jsonminify.

[![CI](https://github.com/aminya/minijson/actions/workflows/CI.yml/badge.svg)](https://github.com/aminya/minijson/actions/workflows/CI.yml)

### Installation

Nodejs

```
npm install @aminya/minijson
```

Dub

```
dub fetch minijson --config=library
# or
dub fetch minijson --config=executable
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
import { minifyFiles } from "minijson"

await minifyFiles(["file1.json", "file2.json"])
```

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
38,823 ms

❯ node .\benchmark\js-benchmark.mjs
58,686 ms
```

### Contributing

```
pnpm install
pnpm run build.node
```

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
