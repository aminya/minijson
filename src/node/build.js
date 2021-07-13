const { join, dirname } = require("path")
const { renameSync, mkdirSync, existsSync } = require("fs")
const { execFileSync } = require("child_process")

const distFolder = join(dirname(dirname(__dirname)), "dist")
const distPlatformFolder = join(distFolder, `${process.platform}-${process.arch}`)

function stripBin(file) {
  if (process.platform === "win32") {
    return
  }
  return execFileSync(process.env.STRIP || "strip", [file, process.platform === "darwin" ? "-Sx" : "--strip-all"])
}

mkdirSync(distPlatformFolder, { recursive: true })

// exe

const exeExtention = process.platform === "win32" ? ".exe" : ""
const binName = `minijson${exeExtention}`
const minijsonSource = join(distFolder, binName)
const minijsonDist = join(distPlatformFolder, binName)

if (existsSync(minijsonSource)) {
  stripBin(minijsonSource)
  renameSync(minijsonSource, minijsonDist)
}

// lib

const libExtension = process.platform === "win32" ? ".dll" : ".so"
const minijsonLibSource = join(distFolder, `${process.platform === "linux" ? "lib" : ""}minijson.node${libExtension}`)
const minijsonLibDist = join(distPlatformFolder, `minijson.node`)

if (existsSync(minijsonLibSource)) {
  renameSync(minijsonLibSource, minijsonLibDist)
}
