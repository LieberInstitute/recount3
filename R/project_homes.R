#' Find available project home options
#'
#' This function finds the home for a given project (study) of interest based
#' on the `organism` and the `home_type`.
#'
#' @inheritParams locate_url
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
#' project_homes("human")
#' project_homes("mouse")
#'
#' ## Test files
#' project_homes("human",
#'     recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' )
project_homes <-
    function(organism = c("human", "mouse"),
    recount3_url = getOption("recount3_url", "http://idies.jhu.edu/recount3/data")) {
        organism <- match.arg(organism)

        if (recount3_url == "http://idies.jhu.edu/recount3/data") {
            if (organism == "mouse") {
                return("data_sources/sra")
            } else if (organism == "human") {
                return(c(
                    "data_sources/sra",
                    "data_sources/gtex",
                    "data_sources/tcga"
                ))
            }
        } else if (recount3_url == "http://snaptron.cs.jhu.edu/data/temp/recount3") {
            if (organism == "mouse") {
                return("data_sources/sra")
            } else if (organism == "human") {
                return(
                    c(
                        "data_sources/sra",
                        "data_sources/gtex",
                        "collections/ccle",
                        "collections/geuvadis_smartseq",
                        "collections/gtex_geuvadis"
                    )
                )
            }
        } else if (!file.exists(recount3_url)) {
            stop(
                "'recount3_url' is not a valid URL or is it not an existing directory in your file system.",
                call. = FALSE
            )
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
            path <- file.path(recount3_url, organism, base_dir)

            ## Find the available options
            available <- dir(path)

            ## Add the paths
            file.path(base_dir, available)
        })
        ## Back to a single character vector
        unlist(homes)
    }
