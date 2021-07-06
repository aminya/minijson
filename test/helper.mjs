import { readFile, copyFile, rm } from "fs/promises"
import { minijson } from "../dist/lib.js"

export async function minifyFixture(fixture) {
  const fixtureName = fixture.slice(0, fixture.length - 5)
  const originalFile = `${fixtureName}.json`
  const minifiedFile = `${fixtureName}-minified.json`
  await copyFile(originalFile, minifiedFile)

  const jsonString = await readFile(originalFile, "utf8")
  const jsonObject = JSON.parse(jsonString)

  await minijson([minifiedFile])

  const minifiedString = await readFile(minifiedFile, "utf8")
  const minifiedObject = JSON.parse(minifiedString)

  await rm(minifiedFile)

  return { jsonString, jsonObject, minifiedString, minifiedObject }
}
