# minijson

Minify JSON files **blazing fast**! Supports Comments. Uses D, C, and AVX2 and SSE4_1 SIMD.

4180 times faster than jsonminify!

[![CI](https://github.com/aminya/minijson/actions/workflows/CI.yml/badge.svg)](https://github.com/aminya/minijson/actions/workflows/CI.yml)

### Installation

- Nodejs

```
npm install @aminya/minijson
```

- Native CLI Binaries (Windows, MacOS, Linux)

You can download the native binaries for the CLI from the release page:

https://github.com/aminya/minijson/releases/tag/v0.6.0

- Dub

```
git submodule update --init --recursive
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

- minifyString: minijson is 4178 times faster than jsonMinify
- minifyFiles: minijson is 1894 times faster than jsonMinify.

```
❯ .\dist\minijson-benchmark.exe --benchmark-minifyString --benchmark-minifyFiles
Benchmark minifyString
14 ms
Benchmark minifyFiles
31 ms

❯ node .\benchmark\js-benchmark.mjs
Benchmark minifyString
58.502 seconds
Benchmark minifyFiles
58.703 seconds
```

### Contributing

You would need to install the ldc compiler for the D programming language
```
curl -fsS https://dlang.org/install.sh | bash -s ldc
```
After installation, it will print a message about activating it. Something like `source activate_ldc.sh`. 

After running the activation command, clone the repository:
```
git clone --recurse-submodules https://github.com/aminya/minijson
cd minijson
```

Then build with:
```
pnpm install
pnpm build.node
```

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
