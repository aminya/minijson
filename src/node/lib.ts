import { execFile } from "child_process"
import { join } from "path"

/**
 * Minify the given JSON string
 *
 * @param jsonString The json string you want to minify
 * @returns The minified json string
 */
export function minijson(files: string[], __splice = true) {
  const filesNum = files.length
  if (filesNum === 0) {
    return
  }

  const exeExtention = process.platform === "win32" ? ".exe" : ""
  const binName = `minijson${exeExtention}`

  const minijsonBin = join(__dirname, `${process.platform}-${process.arch}`, binName)

  const args = [...files]
  // not needed for cli
  if (__splice) {
    const spliceUpper = 2 * filesNum - 2

    for (let iSplice = 0; iSplice <= spliceUpper; iSplice += 2) {
      args.splice(iSplice, 0, "--file")
    }
  }
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
