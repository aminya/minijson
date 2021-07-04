import { readFile, writeFile } from "fs/promises"
import { minify as jsonMinify } from "../dist/node/lib.js"

const jsonFiles = ["./benchmark/fixture.json"]

await Promise.all(
  jsonFiles.map(async (jsonFile) => {
    const jsonString = await readFile(jsonFile, "utf8")
    const data = await jsonMinify(jsonString)
    return await writeFile(jsonFile, data)
  })
)
