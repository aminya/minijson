import { instantiate } from "../as_bind/browser_instantiate"

export async function fetchJsonFile(filePath: string) {
  const responce = await window.fetch(filePath)
  return responce.text()
}

let minifyExport: typeof import("../wasm/index.as").minify | undefined

export async function minify(jsonString: string) {
  if (minifyExport === undefined) {
    minifyExport = (await instantiate()).minify
  }

  return minifyExport!(jsonString)
}
