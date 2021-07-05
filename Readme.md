# minijson

Minify JSON files **fast**! Written in D.


### Installation

Nodejs
```
npm install minijson
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

### Contributing

```
pnpm install
pnpm run build.node
```

### License

The project is licensed under MIT. It was inspired by [fkei/JSON.minify](https://github.com/fkei/JSON.minify).
