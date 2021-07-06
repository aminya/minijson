import { readdirSync } from "fs"
import { join } from "path"

import { dirname as mjsDirname } from "mjs-dirname"
const __dirname = mjsDirname(import.meta.url)

const directory = join(__dirname, "fixtures")
export const jsonFiles = readdirSync(directory).map((file) => join(directory, file))
