import { execFile } from "child_process"
import { readFile, writeFile } from "fs/promises"
import { join } from "path"

/**
 * Minify all the given JSON files in place. It minifies the files in parallel.
 *
 * @param files An array of paths to the files
 * @param hasComment A boolean to support comments in json. Default `false`.
 * @returns {Promise<void>} Returns a void promise that resolves when all the files are minified
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyFiles(files: string[], hasComment = false): Promise<void> {
  if (process.platform === "darwin" && process.arch === "arm64") {
    // fallback to jasonminify due to missing ARM64 binaries
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const jsonminify = require("jsonminify")
    await Promise.all(files.map(async (file) => {
      const jsonString = await readFile(file, "utf8")
      const minifiedJsonString = jsonminify(jsonString) as string
      await writeFile(file, minifiedJsonString)
    }))
    return
  }

  const filesNum = files.length
  if (filesNum === 0) {
    return Promise.resolve()
  }

  const args = [...files]
  const spliceUpper = 2 * filesNum - 2

  for (let iSplice = 0; iSplice <= spliceUpper; iSplice += 2) {
    args.splice(iSplice, 0, "--file")
  }

  if (hasComment) {
    args.push("--comment")
  }

  await spawnMinijson(args)
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
  const args = ["--string", jsonString]
  if (hasComment) {
    args.push("--comment")
  }
  // trim is needed due to using stdout for interop
  return (await spawnMinijson(args)).trim()
}

const exeExtention = process.platform === "win32" ? ".exe" : ""
const binName = `minijson${exeExtention}`

const minijsonBin = join(__dirname, `${process.platform}-${process.arch}`, binName)

/**
 * Spawn minijson with the given arguments
 *
 * @param args An array of arguments
 * @returns {Promise<string>} Returns a promise that resolves to stdout output string when the operation finishes
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export function spawnMinijson(args: string[]): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    execFile(minijsonBin, args, (err, stdout, stderr) => {
      if (err) {
        reject(err)
      }
      if (stderr !== "") {
        reject(stderr)
      }
      resolve(stdout)
    })
  })
}
