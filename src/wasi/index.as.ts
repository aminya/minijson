import "wasi"
import { Console, CommandLine } from "as-wasi"

import { minify } from "../wasm/index.as"
// import { readJsonFile } from "./lib.as"

function main(): void {
  const commandLine = new CommandLine()
  const args = commandLine.all()

  if (args.length < 2) {
    throw new Error("The number of arguments passed to minijson is not sufficient")
  }

  // TODO fails to read the file
  // const filePath = args[1]
  // const jsonString = readJsonFile(filePath)

  const jsonString = args[1]

  const minifiedJsonString = minify(jsonString)

  Console.log(minifiedJsonString)
}

main()
