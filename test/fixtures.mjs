import { readdirSync } from "fs"
import { join } from "path"

import { dirname as mjsDirname } from "mjs-dirname"
const __dirname = mjsDirname(import.meta.url)

const standardDirectory = join(__dirname, "fixtures", "standard")
export const standardFiles = readdirSync(standardDirectory).map((file) => join(standardDirectory, file))

const withCommentDirectory = join(__dirname, "fixtures", "with-comment")
export const withCommentFiles = readdirSync(withCommentDirectory).map((file) => join(withCommentDirectory, file))
