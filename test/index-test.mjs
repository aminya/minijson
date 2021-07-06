import { minifyFixtures } from "./helper.mjs"
import { jsonFiles } from "./fixtures.mjs"
import { rm } from "fs/promises"

// minify
const { pathInfo, originalInfo, resultInfo } = await minifyFixtures(jsonFiles)

describe("minijson", () => {
  // expects
  const fixtureNum = pathInfo.length
  for (let iFixture = 0; iFixture !== fixtureNum; ++iFixture) {
    it(pathInfo[iFixture].originalFile, () => {
      expect(resultInfo[iFixture].minifiedObject).toEqual(originalInfo[iFixture].originalObject)
    })
  }

  afterAll(async () => {
    await Promise.all(pathInfo.map((file) => rm(file.minifiedFile)))
  })
})
