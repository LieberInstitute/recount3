#' Default recount3 data host
#'
#' This function returns the default URL for the recount3 data host.
#'
#' The data host for recount3 has changed over time. We use duffel.rail.bio
#' to handle these changes. However, the most recent change required a newer
#' TLS version that most Windows users don't have. This is why we made this
#' function that changes the result based on the operating system. You can
#' still overwrite the result by setting the `recount3_url` option in your
#' `~/.Rprofile` file.
#'
#' @return A `character(1)` with the default `recount3_url`.
#' @export
#'
#' @examples
recount3_url <- function() {
    ## Use duffel by default except on Windows machines
    default_url <-
        ifelse(.Platform$OS.type != "windows",
            "http://duffel.rail.bio/recount3",
            "https://recount-opendata.s3.amazonaws.com/recount3/release"
        )
    getOption("recount3_url", default_url)
}
