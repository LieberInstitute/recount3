#' List available annotation options for a given organism
#'
#' This function will return the available annotation options for a given
#' `organism`.
#'
#' @inheritParams file_locate_url
#'
#' @return A `character()` vector with the supported annotation options for the
#' given `organism`.
#' @export
#'
#' @examples
#'
#' annotation_options("human")
#' annotation_options("mouse")
annotation_options <- function(organism = c("human", "mouse")) {
    if (organism == "human") {
        options <- c(
            "gencode_v26",
            "gencode_v29",
            "fantom6_cat",
            "refseq",
            "ercc",
            "sirv"
        )
    } else if (organism == "mouse") {
        options <- c("gencode_v23")
    }
    return(options)
}
