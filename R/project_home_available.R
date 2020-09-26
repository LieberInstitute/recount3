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
#'
#' ## Test files
#' project_home_available("human",
#'     recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' )
project_home_available <-
    function(organism = c("human", "mouse"),
    recount3_url = "https://idies.jhu.edu/recount3/data",
    bfc = BiocFileCache::BiocFileCache()) {
        organism <- match.arg(organism)

        if (recount3_url == "https://idies.jhu.edu/recount3/data") {
            if (organism == "mouse") {
                return("data_sources/sra")
            } else if (organism == "human") {
                return(c("data_sources/sra", "data_sources/gtex", "data_sources/tcga"))
            }
        }

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
