const { join, dirname } = require("path")
const { renameSync, mkdirSync } = require("fs")

const exeExtention = process.platform === "win32" ? ".exe" : ""
const binName = `minijson${exeExtention}`

const distFolder = join(dirname(dirname(__dirname)), "dist")
const minijsonSource = join(distFolder, binName)

const distPlatformFolder = join(distFolder, `${process.platform}-${process.arch}`)
mkdirSync(distPlatformFolder, { recursive: true })

const minijsonDist = join(distPlatformFolder, binName)

renameSync(minijsonSource, minijsonDist)
