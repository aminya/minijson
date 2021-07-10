import { SpecReporter } from "jasmine-spec-reporter"

jasmine.getEnv().clearReporters() // remove default reporter logs
jasmine.getEnv().addReporter(
  new SpecReporter({
    spec: {
      displaySuccessful: true,
      displayPending: true,
      displayFailed: true,
    },
  })
)
