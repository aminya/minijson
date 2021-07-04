import { join, dirname } from "path"
import { promises } from "fs"
const { readFile } = promises
import * as AsBind from "as-bind/dist/as-bind.cjs.js"

export async function instantiate() {
  const data = await readFile(join(dirname(dirname(__dirname)), "dist/index.wasm"))
  const wasmModule = await AsBind.instantiate<typeof import("../wasm/index.as")>(data)
  return wasmModule.exports
}
