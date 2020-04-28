#' Find available sub-directories for a given URL
#'
#' This function lists all the available files inside a given URL. If `url` is
#' a local directory, such as when you download all the `recount3` files to
#' your computer, then this function will list all the files inside `url`.
#'
#' @param url A `character(1)` with either a URL or a local file path.
#' @inheritParams file_retrieve
#'
#' @return A `character()` vector with the available options.
#' @export
#' @importFrom XML readHTMLTable
#' @importFrom BiocFileCache bfcrpath
#' @importFrom methods is
#'
#' @examples
#'
#' file_list("http://snaptron.cs.jhu.edu/data/temp/recount3/human/data_sources/")
#' ## file_list(system.file("inst", package = "recount3"))
file_list <- function(url, bfc = BiocFileCache::BiocFileCache()) {
    if (file.exists(url)) {
        return(dir(url))
    }

    if (!methods::is(bfc, "BiocFileCache")) {
        stop("'bfc' should be a BiocFileCache::BiocFileCache object.", call. = FALSE)
    }

    ## Cache the url so it's only used once
    local_url <- BiocFileCache::bfcrpath(bfc, url)

    ## Now read the HTML
    list_files <- XML::readHTMLTable(local_url)[[1]]$Name

    ## Find the available options
    ## ## From https://stackoverflow.com/questions/12930933/retrieve-the-list-of-files-from-a-url
    available <- list_files[!is.na(list_files)]
    available <- gsub("/", "", available)
    available <- available[which(available != "Parent Directory")]
    return(available)
}
