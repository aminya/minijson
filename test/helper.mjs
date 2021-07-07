import { readFile, copyFile } from "fs/promises"
import { minifyFiles } from "../dist/lib.js"
import { performance } from "perf_hooks"

export async function minifyFixtures(jsonFiles) {
  const pathInfo = jsonFiles.map((jsonFile) => {
    const fixtureName = jsonFile.slice(0, jsonFile.length - 5)
    const originalFile = `${fixtureName}.json`
    const minifiedFile = `${fixtureName}-minified.json`
    return { originalFile, minifiedFile }
  })
  const originalInfo = await Promise.all(
    pathInfo.map(async ({ originalFile, minifiedFile }) => {
      await copyFile(originalFile, minifiedFile)
      const originalString = await readFile(originalFile, "utf8")
      const originalObject = JSON.parse(originalString)
      return { originalString, originalObject }
    })
  )

  const minifiedFiles = pathInfo.map((pathInfo) => pathInfo.minifiedFile)

  const t1 = performance.now()

  await minifyFiles(minifiedFiles)

  const t2 = performance.now()
  console.log("Minifying took:", Math.round(t2 - t1), "ms")

  const resultInfo = await Promise.all(
    minifiedFiles.map(async (minifiedFile) => {
      const minifiedString = await readFile(minifiedFile, "utf8")
      let minifiedObject
      try {
        minifiedObject = JSON.parse(minifiedString)
      } catch(e) {
        console.error(`The minified file is not valid for: ${minifiedFile}`)
        throw e;
      }
      return { minifiedString, minifiedObject }
    })
  )

  return { pathInfo, originalInfo, resultInfo }
}
