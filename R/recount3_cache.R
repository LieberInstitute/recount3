#' Specify where to cache the recount3 files
#'
#' This function allows you to specify where the recount3 files will be cached
#' to. It is powered by
#' [BiocFileCache-class][BiocFileCache::BiocFileCache-class].
#'
#' @param cache_dir A `character(1)` specifying the directory that will be used
#' for caching the data. If `NULL` a sensible default location will be used.
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
recount3_cache <- function(cache_dir = getOption("recount3_cache", NULL)) {
    if(is.null(cache_dir)) cache_dir <- tools::R_user_dir("recount3", "cache")
    BiocFileCache::BiocFileCache(cache_dir)
}
