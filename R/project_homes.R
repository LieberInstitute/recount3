#' Find available project home options
#'
#' This function finds the home for a given project (study) of interest based
#' on the `organism` and the `home_type`.
#'
#' By default it reads a small text file from
#' `recount3_url`/`organism`/homes_index using `readLines()`. This text file
#' should contain each possible project home per line. See
#' <http://duffel.rail.bio/recount3/human/homes_index> for an example.
#'
#' @inheritParams locate_url
#' @inheritParams file_retrieve
#'
#' @return A `character()` vector with the available `project_home` options.
#'
#' @importFrom RCurl url.exists
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
        recount3_url = getOption("recount3_url", "http://duffel.rail.bio/recount3")) {
        organism <- match.arg(organism)

        ## Choose cached values if they exist
        option_name <- paste0("recount3_", organism, "_project_homes_URL_", recount3_url)
        homes <- getOption(option_name)
        if (!is.null(homes))
            return(homes)

        ## Construct the URL for the homes_index file
        homes_url <-
            paste(recount3_url, organism, "homes_index", sep = "/")
        if (url.exists(homes_url)) {
            homes_from_url <- readLines(homes_url)

            ## Cache the result for the resulting organism so we don't need
            ## to check this again in this R session
            options_list <- list(homes_from_url)
            names(options_list) <- option_name
            options(options_list)

            ## Return result found
            return(homes_from_url)
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
                "'recount3_url' is not a valid supported URL since it's missing the URL/<organism>/homes_index text file or 'recount3_url' is not an existing directory in your file system.",
                call. = FALSE
            )
        }

        ## Define the base directories
        base_dirs <- c("data_sources",
            "collections")

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
