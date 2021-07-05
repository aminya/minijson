import { minijson } from "./lib"

async function main() {
  const args = process.argv
  await minijson(args, false)
}

main().catch(e => {
  throw e
})
