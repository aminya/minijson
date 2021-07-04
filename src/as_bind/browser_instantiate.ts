import * as AsBind from "as-bind"

export async function instantiate() {
  // The path of the file is relative to ./dist/
  const data = await fetch("./index.wasm")
  const wasmModule = await AsBind.instantiate<typeof import("../wasm/index.as")>(data)
  return wasmModule.exports
}
