#' Specify where to cache the recount3 files
#'
#' This function allows you to specify where the recount3 files will be cached
#' to. It is powered by
#' [BiocFileCache-class][BiocFileCache::BiocFileCache-class].
#'
#' @param dir A `character(1)` specifying the directory that will be used
#' for caching the data.
#'
#' @return A [BiocFileCache-class][BiocFileCache::BiocFileCache-class]
#' object where the recount3 files will be cached to.
#' @importFrom tools R_user_dir
#' @export
#' @family recount3 cache functions
#'
#' @examples
#'
#' ## Locate the recount3 cache default directory
#' recount3_cache()
recount3_cache <- function(dir = getOption("recount3_cache", NULL)) {
    if(is.null(dir)) dir <- tools::R_user_dir("recount3", "cache")
    BiocFileCache::BiocFileCache(dir)
}
