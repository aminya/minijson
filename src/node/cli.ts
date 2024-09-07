import { spawnMinijson } from "./lib"

async function main() {
  await spawnMinijson(process.argv.slice(2))
}

main().catch((e) => {
  throw e
})
