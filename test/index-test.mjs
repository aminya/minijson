import { minifyFixture } from "./helper.mjs"
import { jsonFiles } from "./fixtures.mjs"

describe("minijson", () => {
  for (const jsonFile of jsonFiles) {
    it(jsonFile, async () => {
      const { jsonString, jsonObject, minifiedString, minifiedObject } = await minifyFixture(jsonFile)
      expect(jsonObject).toEqual(minifiedObject)
    })
  }
})
