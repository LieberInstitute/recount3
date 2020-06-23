#' Download a remote file and cache it to re-use later
#'
#' @param url A `character(1)` with the file URL or the actual local path in
#' which case, it won't be cached. If `length(url) > 1` , this function
#' will be used recursively.
#' @param bfc A [BiocFileCache-class][BiocFileCache::BiocFileCache-class]
#' object where the files will be cached to.
#'
#' @return A `character(1)` with the path to the cached file.
#' @export
#' @importFrom BiocFileCache bfcrpath
#' @importFrom methods is
#' @importFrom RCurl url.exists
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the metadata file for project ERP110066
#' url_ERP110066_meta <- file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra"
#' )
#' local_ERP110066_meta <- file_retrieve(
#'     url = url_ERP110066_meta
#' )
#' local_ERP110066_meta
#'
#' ## Download the gene counts file for project ERP110066
#' url_ERP110066_gene <- file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra",
#'     type = "gene"
#' )
#' local_ERP110066_gene <- file_retrieve(
#'     url = url_ERP110066_gene
#' )
#' local_ERP110066_gene
file_retrieve <- function(url, bfc = BiocFileCache::BiocFileCache()) {
    ## In case you are working with more than one url (like with metadata)
    if (length(url) > 1) {
        return(vapply(url, file_retrieve, character(1), bfc = bfc))
    }

    ## In case the url is a local file, there's no need to cache it then
    if (file.exists(url)) {
        return(url)
    } else if (!url.exists(url)) {
        stop("The 'url' <", url, "> does not exist or is not available.", call. = FALSE)
    }

    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.", call. = FALSE)
    }
    message(paste("Caching file", basename(url)))
    res <- BiocFileCache::bfcrpath(bfc, url, exact = TRUE)
    names(res) <- names(url)
    return(res)
}
