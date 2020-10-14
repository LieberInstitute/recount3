#' Locate recount3 cached files
#'
#' This function returns the list of URLs of the recount3 files you have
#' stored in your `recount3_cache()`.
#'
#' @inheritParams file_retrieve
#'
#' @return A `character()` with the URLs of the recount3 files you have
#' downloaded.
#' @export
#' @importfrom BiocFileCache bfcinfo
#' @family recount3 cache functions
#'
#' @examples
#' ## List the URLs you have downloaded
#' recount3_cache_files()
recount3_cache_files <- function(bfc = recount3_cache()) {
    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.",
            call. = FALSE)
    }

    ## Locate all files
    bfc_files <- bfcinfo(bfc)

    ## Find files from recount3
    bfc_recount3 <- grep("recount3", bfc_files[["fpath"]])

    ## List the original URLs for the data
    bfc_files[["fpath"]][bfc_recount3]
}
