import "wasi"
import { FileSystem } from "as-wasi"

export function readJsonFile(filePath: string): string {
  const file = FileSystem.open(filePath, "r+")
  if (file === null) {
    throw new Error("File doesn't exist: " + filePath) // eslint-disable-line prefer-template
  }
  const data = file.read()
  if (data === null) {
    throw new Error("File could not be read: " + filePath) // eslint-disable-line prefer-template
  }
  return data.toString()
}
