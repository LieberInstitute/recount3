#' Download a remote file and cache it to re-use later
#'
#' @param url A `character(1)` with the file URL or the actual local path in
#' which case, it won't be cached. If `length(url) > 1` , this function
#' will be used recursively.
#' @param bfc A [BiocFileCache-class][BiocFileCache::BiocFileCache-class]
#' object where the files will be cached to, typically created by
#' `recount3_cache()`.
#' @param verbose A `logical(1)` indicating whether to show messages with
#' updates.
#'
#' @return A `character(1)` with the path to the cached file.
#' @export
#' @importFrom BiocFileCache bfcrpath
#' @importFrom methods is
#' @importFrom httr http_error
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the metadata file for project SRP009615
#' url_SRP009615_meta <- locate_url(
#'     "SRP009615",
#'     "data_sources/sra"
#' )
#' local_SRP009615_meta <- file_retrieve(
#'     url = url_SRP009615_meta
#' )
#' local_SRP009615_meta
#'
#' ## Download the gene counts file for project SRP009615
#' url_SRP009615_gene <- locate_url(
#'     "SRP009615",
#'     "data_sources/sra",
#'     type = "gene"
#' )
#' local_SRP009615_gene <- file_retrieve(
#'     url = url_SRP009615_gene
#' )
#' local_SRP009615_gene
file_retrieve <-
    function(url,
    bfc = recount3_cache(),
    verbose = getOption("recount3_verbose", TRUE)) {
        ## In case you are working with more than one url (like with metadata)
        if (length(url) > 1) {
            return(vapply(
                url,
                file_retrieve,
                character(1),
                bfc = bfc,
                verbose = verbose
            ))
        }

        ## In case the url is a local file, there's no need to cache it then
        if (file.exists(url)) {
            return(url)
        } else {
            url_failed <- tryCatch(
                http_error(url),
                error = function(e) { return (TRUE)}
            )
            if (url_failed) {
                if (!grepl("tcga\\.recount_pred|gtex\\.recount_pred", url)) {
                    warning("The 'url' <",
                        url,
                        "> does not exist or is not available.",
                        call. = FALSE
                    )
                }
                res <- as.character(NA)
                names(res) <- names(url)
                return(res)
            }
        }

        if (!methods::is(bfc, "BiocFileCache")) {
            stop("'bfc' should be a BiocFileCache::BiocFileCache object.",
                call. = FALSE
            )
        }
        if (verbose) {
            message(Sys.time(), " caching file ", basename(url), ".")
        }
        res <- BiocFileCache::bfcrpath(
            bfc,
            url,
            exact = TRUE,
            verbose = verbose
        )
        names(res) <- names(url)
        return(res)
    }
