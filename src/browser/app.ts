import { minify } from "./lib"

function main() {
  const jsonField = document.getElementById("JSONField") as HTMLInputElement | null
  const getJSONButton = document.getElementById("getJSONButton")
  const jsonOutput = document.getElementById("JSONOutput") as HTMLOutputElement | null
  if (jsonField === null || getJSONButton === null || jsonOutput === null) {
    throw new Error("Page did not render correctly")
  }
  getJSONButton.onclick = async () => {
    const jsonString = jsonField.value
    const minifiedJSON = await minify(jsonString)
    jsonOutput.value = minifiedJSON
  }
}

main()
