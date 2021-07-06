import { minifyFixture } from "./utils.mjs"

describe("Normal JSON", () => {
  it("1", async () => {
    const { jsonString, jsonObject, minifiedString, minifiedObject } = await minifyFixture("1")
    expect(jsonObject).toEqual(minifiedObject)
  })
})
