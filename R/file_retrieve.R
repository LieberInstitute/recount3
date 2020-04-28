#' Download a cache a remote file
#'
#' @param url A `character(1)` with the file URL.
#' @param bfc A `BiocFileCache` object
#' [BiocFileCache-class][BiocFileCache::BiocFileCache-class].
#'
#' @return A `character(1)` with the path to the cached file.
#' @export
#' @importFrom BiocFileCache bfcrpath
#' @importFrom methods is
#'
#' @examples
#'
#' file_url <- file_locate_url("ERP001942", "sra", "metadata", "human")
#' file_local <- file_retrieve(url = file_url)
file_retrieve <- function(url, bfc = BiocFileCache::BiocFileCache()) {
    # if(!file.exists(url)) {
    #     stop("The 'url'", url, "does not exist.", call. = FALSE)
    # }
    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.", call. = FALSE)
    }
    BiocFileCache::bfcrpath(bfc, url)
}
