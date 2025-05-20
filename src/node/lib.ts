import { execFile } from "child_process"
import { chmodSync } from "fs"
import { readFile, writeFile } from "fs/promises"
import { join } from "path"

/**
 * Minify all the given JSON files in place. It minifies the files in parallel.
 *
 * @param files An array of paths to the files
 * @param hasComment A boolean to support comments in json. Default `true`.
 * @returns {Promise<void>} Returns a void promise that resolves when all the files are minified
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyFiles(files: readonly string[], hasComment = true): Promise<void> {
  try {
    const filesNum = files.length
    if (filesNum === 0) {
      return Promise.resolve()
    }

    await spawnMinijson([...files, hasComment ? "--comment=true" : "--comment=false"])
  } catch (e) {
    console.error(e, "Falling back to jsonminify")
    await minifyFilesFallback(files)
  }
}

/**
 * Spawn minijson with the given arguments
 *
 * @param args An array of arguments
 * @returns {Promise<string>} Returns a promise that resolves to stdout output string when the operation finishes
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export function spawnMinijson(args: string[]): Promise<string> {
  return new Promise<string>((resolve, reject) => {
    try {
      execFile(minijsonBin, args, (err, stdout, stderr) => {
        console.error(stderr)
        console.log(stdout)

        if (err) {
          reject(err)
        }
        if (stderr !== "") {
          reject(stderr)
        }
        resolve(stdout)
      })
    } catch (execErr) {
      reject(execErr)
    }
  })
}

async function minifyFilesFallback(files: readonly string[]) {
  const jsonminify = require("jsonminify")
  await Promise.all(
    files.map(async (file) => {
      const jsonString = await readFile(file, "utf8")
      const minifiedJsonString = jsonminify(jsonString) as string
      await writeFile(file, minifiedJsonString)
    }),
  )
  return
}

/**
 * Minify the given JSON string
 *
 * @param jsonString The json string you want to minify
 * @param hasComment A boolean to support comments in json. Default `true`.
 * @returns {Promise<string>} The minified json string
 * @throws {Promise<string | Error>} The promise is rejected with the reason for failure
 */
export async function minifyString(jsonString: string, hasComment = true): Promise<string> {
  const args = ["--str", jsonString]
  if (hasComment) {
    args.push("--comment")
  }
  // trim is needed due to using stdout for interop
  return (await spawnMinijson(args)).trim()
}

const exeExtention = process.platform === "win32" ? ".exe" : ""
const binName = `minijson${exeExtention}`

const minijsonBin = join(__dirname, `${process.platform}-${process.arch}`, binName)

// chmod as executable on non-windows
if (process.platform !== "win32") {
  chmodSync(minijsonBin, 0o755)
}
