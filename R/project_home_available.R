#' Find available project home options
#'
#' This function finds the home for a given project (study) of interest based
#' on the `organism` and the `home_type`.
#'
#' @param home_type A `character(1)` specifying whether you are looking for
#' the core data sources for `recount3` or collections which are user-created.
#' @inheritParams file_locate_url
#' @inheritParams file_retrieve
#'
#' @return A `character()` vector with the available `project_home` options.
#' @export
#'
#' @examples
#'
#' ## List the different available `project_home` options for the default
#' ## arguments
#' project_home_available()
project_home_available <-
    function(home_type = c("data_source", "collection"),
    organism = c("human", "mouse"),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3",
    bfc = BiocFileCache::BiocFileCache()) {
        home_type <- match.arg(home_type)
        organism <- match.arg(organism)

        ## Define the base directories
        base_dir <- switch(
            home_type,
            data_source = "data_sources",
            collection = "collections"
        )

        ## Build the query URL
        url <- file.path(recount3_url, organism, base_dir)
        available <- file_list(url = url, bfc = bfc)

        result <- file.path(base_dir, available)
        names(result) <- available

        return(result)
    }
