import { execFile } from "child_process"
import { join } from "path"


function main() {
  const args = process.argv

  const exeExtention = process.platform === "win32" ? ".exe" : ""
  const binName = `minijson${exeExtention}`

  const minijson = join(__dirname, `${process.platform}-${process.arch}`, binName)

  execFile(minijson, args, (err, stdout, stderr) => {
    if (err) {
      throw err
    }
    if (stderr !== "") {
      console.error(stderr)
    }
    if (stdout !== "") {
      console.log(stdout)
    }
  })
}

main()
