import { readFile, writeFile } from "fs/promises"
import { performance } from "perf_hooks"
import jsonMinify from "jsonminify"

const jsonFiles = ["./benchmark/fixture2.json"]

// warmup
const tmp = await jsonMinify("{}")

const t1 = performance.now()

await Promise.all(
  jsonFiles.map(async (jsonFile) => {
    const jsonString = await readFile(jsonFile, "utf8")
    const data = await jsonMinify(jsonString)
    return await writeFile(jsonFile, data)
  })
)

const t2 = performance.now()
console.log(t2 - t1)
