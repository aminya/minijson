import { readFile, copyFile, rm } from "fs/promises"
import { join } from "path"
import { minijson } from "../dist/lib.js"

const fixtureDir = "./test/fixtures"

export async function minifyFixture(fixtureName) {
  const originalFile = join(fixtureDir, `${fixtureName}.json`)
  const minifiedFile = join(fixtureDir, `${fixtureName}-minified.json`)
  await copyFile(originalFile, minifiedFile)

  const jsonString = await readFile(originalFile, "utf8")
  const jsonObject = JSON.parse(jsonString)

  await minijson([minifiedFile])

  const minifiedString = await readFile(minifiedFile, "utf8")
  const minifiedObject = JSON.parse(minifiedString)

  await rm(minifiedFile)

  return { jsonString, jsonObject, minifiedString, minifiedObject }
}
