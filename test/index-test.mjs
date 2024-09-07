import "./reporter.mjs"
import { minifyFixtures } from "./helper.mjs"
import { minifyFiles, minifyString } from "../dist/lib.js"
import { standardFiles, withCommentFiles } from "./fixtures.mjs"
import { rm } from "fs/promises"

// minify
const standard = await minifyFixtures(standardFiles, false)
const withComment = await minifyFixtures(withCommentFiles, true)

describe("minijson", () => {
  describe("minifyFiles standard", () => {
    const { pathInfo, originalInfo, resultInfo } = standard
    // expects
    const fixtureNum = pathInfo.length
    for (let iFixture = 0; iFixture !== fixtureNum; ++iFixture) {
      it(pathInfo[iFixture].originalFile, () => {
        expect(resultInfo[iFixture].minifiedObject).toEqual(originalInfo[iFixture].originalObject)
        expect(resultInfo[iFixture].minifiedString).toEqual(JSON.stringify(originalInfo[iFixture].originalObject))
      })
    }

    afterAll(async () => {
      await Promise.all(pathInfo.map((file) => rm(file.minifiedFile)))
    })
  })

  describe("minifyFiles with comment", () => {
    const { pathInfo, originalInfo, resultInfo } = withComment

    // expects
    const fixtureNum = pathInfo.length
    for (let iFixture = 0; iFixture !== fixtureNum; ++iFixture) {
      it(pathInfo[iFixture].originalFile, () => {
        expect(resultInfo[iFixture].minifiedObject).toEqual(originalInfo[iFixture].originalObject)
        expect(resultInfo[iFixture].minifiedString).toEqual(JSON.stringify(originalInfo[iFixture].originalObject))
      })
    }

    afterAll(async () => {
      await Promise.all(pathInfo.map((file) => rm(file.minifiedFile)))
    })
  })

  describe("minifyString", () => {
    it("minifies a string", async () => {
      const minifiedString = await minifyString(`
        {
          "foo": "bar",
          "bar": ["baz", "bum", "zam"],
          "something": 10,
          "else": 20
        }
        `)
      expect(minifiedString).toBe(`{"foo":"bar","bar":["baz","bum","zam"],"something":10,"else":20}`)
    })
  })
})
