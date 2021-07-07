import { spawnMinijson } from "./lib"

async function main() {
  await spawnMinijson(process.argv)
}

main().catch((e) => {
  throw e
})
