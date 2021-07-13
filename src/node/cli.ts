import { execFile } from "child_process"
import { join } from "path"

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

async function main() {
  await spawnMinijson(process.argv)
}

main().catch((e) => {
  throw e
})
