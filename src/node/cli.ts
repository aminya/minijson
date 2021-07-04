import { minify, readJsonFile } from "./lib"

async function main() {
  if (process.argv.length <= 2) {
    throw new Error("The number of arguments passed to as-jsonminify is not sufficient")
  }
  const fileName = process.argv[2]
  const jsonString = await readJsonFile(fileName)
  const minifiedJson = await minify(jsonString)

  console.log(minifiedJson)
}

main().catch((err) => {
  throw err
})
