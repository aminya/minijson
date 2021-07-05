const { join, dirname } = require("path")
const { renameSync, mkdirSync } = require("fs")
const { execFileSync } = require("child_process")

const exeExtention = process.platform === "win32" ? ".exe" : ""
const binName = `minijson${exeExtention}`

const distFolder = join(dirname(dirname(__dirname)), "dist")
const minijsonSource = join(distFolder, binName)

const distPlatformFolder = join(distFolder, `${process.platform}-${process.arch}`)
mkdirSync(distPlatformFolder, { recursive: true })

function stripBin(file) {
  if (process.platform === "win32") {
    return
  }
  return execFileSync(process.env.STRIP || "strip", [file, process.platform === "darwin" ? "-Sx" : "--strip-all"])
}
stripBin(minijsonSource)

const minijsonDist = join(distPlatformFolder, binName)

renameSync(minijsonSource, minijsonDist)
