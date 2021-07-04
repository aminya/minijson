declare module "as-bind/dist/as-bind.cjs.js" {
  import * as CoreLoader from "@assemblyscript/loader"

  // General asbind versionn
  export const version: number

  // Our APIs
  export const instantiate: typeof CoreLoader.instantiate

  export const instantiateSync: typeof CoreLoader.instantiateSync
}
