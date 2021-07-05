import { promises } from "fs"
const { readFile } = promises

import { instantiate } from "../as_bind/node_instantiate"

let minifyExport: typeof import("../wasm/index.as").minify | undefined

export async function getExports() {
  if (minifyExport === undefined) {
    minifyExport = (await instantiate()).minify
  }
  return minifyExport!
}

export function readJsonFile(filePath: string) {
  return readFile(filePath, "utf8")
}

export async function minify(jsonString: string) {
  const minifyFunc = await getExports()
  return minifyFunc(jsonString)
}
