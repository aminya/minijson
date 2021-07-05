# minijson

Minify JSON files **fast**! Written in D.

4 times faster than jsonminify.

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
minijson --file file1.json --file file2.json
```

### Node API

```js
import { minify } from "minijson"

await minify(["file1.json", "file2.json"])
```

### D API

```js
import minijson: minify;

minify(["file1.json", "file2.json"]);
```

### Benchmarks

```
❯ node .\benchmark\native-benchmark.mjs
14,259 ms

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
