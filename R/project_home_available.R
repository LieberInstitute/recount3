#' Find available project home options
#'
#' This function finds the home for a given project (study) of interest based
#' on the `organism` and the `home_type`.
#'
#' @inheritParams file_locate_url
#' @inheritParams file_retrieve
#'
#' @return A `character()` vector with the available `project_home` options.
#'
#' @family internal functions for accessing the recount3 data
#' @export
#'
#' @examples
#'
#' ## List the different available `project_home` options for the default
#' ## arguments
#' project_home_available("human")
#' project_home_available("mouse")
project_home_available <-
    function(organism = c("human", "mouse"),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3",
    bfc = BiocFileCache::BiocFileCache()) {
        organism <- match.arg(organism)

        ## Define the base directories
        base_dirs <- c(
            "data_sources",
            "collections"
        )
        if (organism == "mouse") {
            ## Currently there are no mouse collections
            base_dirs <- "data_sources"
        }

        homes <- lapply(base_dirs, function(base_dir) {
            ## Build the query URL
            url <- file.path(recount3_url, organism, base_dir)
            names(url) <- url

            ## Find the available options
            available <- file_list(url, bfc = bfc)

            ## Add the paths
            file.path(base_dir, available)
        })
        ## Back to a single character vector
        unlist(homes)
    }
