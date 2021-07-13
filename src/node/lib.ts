import { join } from "path"
const minijsonLib = join(__dirname, `${process.platform}-${process.arch}`, "minijson.node")

const nativeLib = require(minijsonLib) // eslint-disable-line @typescript-eslint/no-var-requires

/**
 * Minify all the given JSON files in place. It minifies the files in parallel.
 *
 * @param files An array of paths to the files
 * @param hasComment A boolean to support comments in json. Default `false`.
 * @returns {Promise<void>} Returns a void promise that resolves when all the files are minified
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyFiles(files: string[], hasComment = false): Promise<void> {
  const filesNum = files.length
  if (filesNum === 0) {
    return Promise.resolve()
  }
  nativeLib.minifyFiles(files, hasComment)
}

/**
 * Minify the given JSON string
 *
 * @param jsonString The json string you want to minify
 * @param hasComment A boolean to support comments in json. Default `false`.
 * @returns {Promise<string>} The minified json string
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyString(jsonString: string, hasComment = false): Promise<string> {
  // trim is needed due to using stdout for interop
  return nativeLib.minifyFiles(jsonString, hasComment)
}
