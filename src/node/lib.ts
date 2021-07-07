import { execFile } from "child_process"
import { join } from "path"

/**
 * Minify all the given JSON files in place. It minifies the files in parallel.
 *
 * @param files The paths to the files
 * @returns {Promise<void>} Returns a void promise that resolves when all the files are minified
 */
export function minifyFiles(files: string[]): Promise<void> {
  const filesNum = files.length
  if (filesNum === 0) {
    return Promise.resolve()
  }

  const args = [...files]
  const spliceUpper = 2 * filesNum - 2

  for (let iSplice = 0; iSplice <= spliceUpper; iSplice += 2) {
    args.splice(iSplice, 0, "--file")
  }

  return spawnMinijson(args)
}

/**
 * Spawn minijson with the given arguments
 *
 * @returns {Promise<void>} Returns a void promise that resolves when the operation finishes
 */
export function spawnMinijson(args: string[]): Promise<void> {
  const exeExtention = process.platform === "win32" ? ".exe" : ""
  const binName = `minijson${exeExtention}`

  const minijsonBin = join(__dirname, `${process.platform}-${process.arch}`, binName)

  return new Promise<void>((resolve, reject) => {
    execFile(minijsonBin, args, (err, stdout, stderr) => {
      if (err) {
        reject(err)
      }
      if (stderr !== "") {
        console.error(stderr)
        reject()
      }
      if (stdout !== "") {
        console.log(stdout)
      }
      resolve()
    })
  })
}
