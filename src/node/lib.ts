import { promises } from "fs"
const { readFile } = promises

import { instantiate } from "../as_bind/node_instantiate"

export function readJsonFile(filePath: string) {
  return readFile(filePath, "utf8")
}

let minifyExport: typeof import("../wasm/index.as").minify | undefined

export async function minify(jsonString: string) {
  if (minifyExport === undefined) {
    minifyExport = (await instantiate()).minify
  }

  return minifyExport!(jsonString)
}
