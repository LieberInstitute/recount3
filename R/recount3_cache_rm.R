#' Remove recount3 cached files
#'
#' This function removes the recount3 files you have
#' stored in your `recount3_cache()`.
#'
#' @inheritParams file_retrieve
#'
#' @return A `character(0)` if the removal of files was successful.
#' @export
#' @importfrom BiocFileCache bfcinfo bfcremove
#' @family recount3 cache functions
#'
#' @examples
#' ## List the URLs you have downloaded
#' recount3_cache_files()
#'
#' \dontrun{
#' ## Now delete the cached files
#' recount3_cache_rm()
#'
#' ## List againt your recount3 files (should be empty)
#' recount3_cache_files()
#' }
recount3_cache_rm <- function(bfc = recount3_cache()) {
    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.",
            call. = FALSE)
    }

    ## Locate all files
    bfc_files <- bfcinfo(bfc)

    ## Find files from recount3
    bfc_recount3 <- grep("recount3", bfc_files[["fpath"]])

    bfcremove(bfc, rids = bfc_files[["rid"]][bfc_recount3])
}
