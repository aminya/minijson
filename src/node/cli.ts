import { minifyFiles } from "./lib"

async function main() {
  const args = process.argv
  await minifyFiles(args, false)
}

main().catch((e) => {
  throw e
})
