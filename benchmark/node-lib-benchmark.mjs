import { performance } from "perf_hooks"
import { minijson } from "../dist/lib.js"

import { jsonFiles } from "./fixtures.mjs"

const t1 = performance.now()

await minijson(jsonFiles)

const t2 = performance.now()
console.log(t2 - t1)
