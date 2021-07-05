import { performance } from "perf_hooks"
import { minijson } from "../dist/lib.js"

const jsonFiles = ["./benchmark/fixture2.json"]

const t1 = performance.now()

await minijson(jsonFiles)

const t2 = performance.now()
console.log(t2 - t1)
