import { performance } from "perf_hooks"
import { minifyFiles } from "../dist/lib.js"

import { standardFiles } from "../test/fixtures.mjs"

const t1 = performance.now()

await minifyFiles(standardFiles)

const t2 = performance.now()
console.log(((t2 - t1) / 1000).toFixed(3), "seconds")
