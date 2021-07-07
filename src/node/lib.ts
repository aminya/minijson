import { execFile } from "child_process"
import { join } from "path"

/**
 * Minify all the given JSON files in place. It minifies the files in parallel.
 *
 * @param files The paths to the files
 * @returns {Promise<void>} Returns a void promise that resolves when all the files are minified
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyFiles(files: string[]): Promise<void> {
  const filesNum = files.length
  if (filesNum === 0) {
    return Promise.resolve()
  }

  const args = [...files]
  const spliceUpper = 2 * filesNum - 2

  for (let iSplice = 0; iSplice <= spliceUpper; iSplice += 2) {
    args.splice(iSplice, 0, "--file")
  }

  await spawnMinijson(args)
}

/**
 * Minify the given JSON string
 *
 * @param jsonString The json string you want to minify
 * @returns {Promise<string>} The minified json string
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyString(jsonString: string): Promise<string> {
  // trim is needed due to using stdout for interop
  return (await spawnMinijson(["--string", jsonString])).trim()
}

/**
 * Spawn minijson with the given arguments
 *
 * @returns {Promise<string>} Returns a promise that resolves to stdout output string when the operation finishes
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export function spawnMinijson(args: string[]): Promise<string> {
  const exeExtention = process.platform === "win32" ? ".exe" : ""
  const binName = `minijson${exeExtention}`

  const minijsonBin = join(__dirname, `${process.platform}-${process.arch}`, binName)

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
