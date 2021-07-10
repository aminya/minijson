# minijson

Minify JSON files **blazing fast**! Supports Comments. Written in D.

360 times faster than jsonminify!

[![CI](https://github.com/aminya/minijson/actions/workflows/CI.yml/badge.svg)](https://github.com/aminya/minijson/actions/workflows/CI.yml)

### Installation

- Nodejs

```
npm install @aminya/minijson
```

- CLI Binaries

You can also download the binaries for the CLI from the release page:

https://github.com/aminya/minijson/releases/tag/v0.5.1

- Dub

```
dub build --config=library --build=release-nobounds --compiler=ldc2
# or
dub build --config=executable --build=release-nobounds --compiler=ldc2
```

### CLI Usage

```shell
❯ minijson --help

minijson: minify json files with support for comments
    minijson --file file1.json --file file2.json
    minijson --file file1_with_comment.json --file file2_with_comment.json --comment

    minijson --string '{"some_json": "string_here"}'
    minijson --string '{"some_json": "string_here"} //comment' --comment

    More information at https://github.com/aminya/minijson

      --file an array of files to minify
    --string a json string to minify
   --comment a flag to support comments in json
-h    --help This help information.
```

### Node API

```js
import { minifyFiles, minifyString } from "minijson"

// minify the files in-place and in parallel
await minifyFiles(["file1.json", "file2.json"])

// supports comments by passing true as the second argument
await minifyFiles(["file1_with_comment.json", "file2_with_comment.json"], true)

// minify the given string
const minifiedString = minifyString(`{"some_json": "here"}`)

// supports comments by passing true as the second argument
const minifiedString2 = minifyString(`{"some_json": "here"}//comment`, true)
```

**Note**: in the Nodejs API, prefer `minifyFiles` over other functions, as it minifies the files in parallel with the least amount of resources.

### D API

```js
import minijson: minifyString, minifyFiles;

// minify the given string
const minifiedString = minifyString(`{"some_json": "here"}`);

// supports comments by passing true as the second argument
const minifiedString2 = minifyString(`{"some_json": "here"}//comment`, true);

// minify the files in-place and in parallel
minifyFiles(["file1.json", "file2.json"]);

// supports comments by passing true as the second argument
minifyFiles(["file1.json", "file2.json"], true);
```

### Benchmarks

On AMD Ryzen 7 4800H:

```
❯ node .\benchmark\native-benchmark.mjs
0.163 seconds

❯ node .\benchmark\js-benchmark.mjs
58.818 seconds
```

### Contributing

```
pnpm install
pnpm run build.node
```

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
