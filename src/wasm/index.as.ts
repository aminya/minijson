import { RegExp, Match } from "assemblyscript-regex"

const tokenizer = new RegExp('"|(/\\*)|(\\*/)|(//)|\\n|\\r|[|]', "g")

const spaceOrBreakRegex = new RegExp("\\s|\\n|\\r")

const repeatingBackSlashRegex = new RegExp("(\\\\)*$")

export function minify(jsonString: string): string {
  let in_string = false
  let in_multiline_comment = false
  let in_singleline_comment = false
  const new_str: string[] = []
  let str_num = 0
  let from = 0
  let rightContext: string = ""

  tokenizer.lastIndex = 0

  let match: Match | null = null

  // eslint-disable-next-line
  while (true) {
    match = tokenizer.exec(jsonString)
    if (match === null) {
      break
    }

    const firstIndex = match.index
    const lastInddex = tokenizer.lastIndex

    const leftContext = jsonString.substring(0, firstIndex) // eslint-disable-line @typescript-eslint/no-unsafe-argument
    rightContext = jsonString.substring(lastInddex) // eslint-disable-line @typescript-eslint/no-unsafe-argument

    if (!in_multiline_comment && !in_singleline_comment) {
      let leftContextSubstr = leftContext.substring(from)
      if (!in_string) {
        // TODO fix replacement
        leftContextSubstr = leftContextSubstr.replaceAll(" ", "").replaceAll("\r", "").replaceAll("\n", "")
      }
      new_str[str_num++] = leftContextSubstr
    }
    from = tokenizer.lastIndex

    const firstMatch = match.matches[0]
    if (firstMatch == '"' && !in_multiline_comment && !in_singleline_comment) {
      const lcMatch = repeatingBackSlashRegex.exec(leftContext)
      if (!in_string || lcMatch === null || lcMatch.matches.length % 2 === 0) {
        // start of string with ", or unescaped " character found to end string
        in_string = !in_string
      }
      --from // include " character in next catch
      rightContext = jsonString.substring(from)
    } else if (firstMatch === "/*" && !in_string && !in_multiline_comment && !in_singleline_comment) {
      in_multiline_comment = true
    } else if (firstMatch === "*/" && !in_string && in_multiline_comment && !in_singleline_comment) {
      in_multiline_comment = false
    } else if (firstMatch === "//" && !in_string && !in_multiline_comment && !in_singleline_comment) {
      in_singleline_comment = true
    } else if (
      (firstMatch === "\n" || firstMatch === "\r") &&
      !in_string &&
      !in_multiline_comment &&
      in_singleline_comment
    ) {
      in_singleline_comment = false
    } else if (!in_multiline_comment && !in_singleline_comment && spaceOrBreakRegex.test(firstMatch) === false) {
      new_str[str_num++] = firstMatch
    }
  }
  new_str[str_num++] = rightContext
  return new_str.join("")
}
