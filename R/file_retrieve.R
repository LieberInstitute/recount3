#' Download a remote file and cache it to re-use later
#'
#' @param url A `character(1)` with the file URL or the actual local path in
#' which case, it won't be cached.
#' @param bfc A [BiocFileCache-class][BiocFileCache::BiocFileCache-class]
#' object where the files will be cached to.
#'
#' @return A `character(1)` with the path to the cached file.
#' @export
#' @importFrom BiocFileCache bfcrpath
#' @importFrom methods is
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the metadata file for project ERP001942
#' url_ERP001942_meta <- file_locate_url("ERP001942", "data_sources/sra")
#' local_ERP001942_meta <- file_retrieve(url = url_ERP001942_meta)
#' local_ERP001942_meta
#'
#' ## Download the gene counts file for project ERP001942
#' url_ERP001942_gene <- file_locate_url("ERP001942", "data_sources/sra", type = "gene")
#' local_ERP001942_gene <- file_retrieve(url = url_ERP001942_gene)
#' local_ERP001942_gene
file_retrieve <- function(url, bfc = BiocFileCache::BiocFileCache()) {
    ## In case the url is a local file, there's no need to cache it then
    if (file.exists(url)) {
        return(url)
    }
    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.", call. = FALSE)
    }
    BiocFileCache::bfcrpath(bfc, url)
}
