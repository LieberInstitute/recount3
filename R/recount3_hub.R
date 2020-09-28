#' Access recount3 project_info objects through ExperimentHub
#'
#' This function downloads from `ExperimentHub` the list of available
#' recount3 projects. However, you might be more tempted to explore the
#' data interactively using code like
#' `eh2 <- AnnotationHub::display(ExperimentHub::ExperimentHub())`
#'
#' @param project A `character(1)` specifying the project ID you are interested
#' in. Could be a SRA study ID or could be a specific GTEx or TCGA tissue.
#' @param data_source A `character(1)` specifying the data source.
#' @inheritParams file_locate_url
#' @param eh An `ExperimentHub` object
#' [ExperimentHub-class][ExperimentHub::ExperimentHub-class].
#'
#' @return A `data.frame()` with one row and three columns that contain
#' the information needed by `create_rse()` for accessing the data.
#'
#' @export
#' @import ExperimentHub
#' @importFrom AnnotationHub query
#' @importFrom methods is
#'
#' @examples
#'
#' ## Locate a project of interest
#' project_info <- recount3_hub("SRP009615")
#'
#' ## For an interactive display use:
#' if (interactive()) {
#'     ## Open an interactive display
#'     eh2 <- AnnotationHub::display(ExperimentHub::ExperimentHub())
#'
#'     ## Select one study, then hit the "send" button on the interactive
#'     ## display
#'
#'     ## Check that you selected one study
#'     if (length(eh2) == 1) {
#'         ## Download the data using the ExperimentHub [[ syntax
#'         project_info <- eh2[[1]]
#'     }
#' }
#'
#' ## Create a RangedSummarizedExperiment object for this project
#' create_rse(project_info)
recount3_hub <- function(
    project,
    data_source = c("sra", "gtex", "tcga"),
    organism = c("human", "mouse"),
    eh = ExperimentHub::ExperimentHub()) {

    ## For R CMD check
    file_source <- project_type <- NULL

    ## Check inputs
    stopifnot(methods::is(eh, "ExperimentHub"))

    organism <- match.arg(organism)
    data_source <- match.arg(data_source)

    ## Build the query
    tags <- paste0(
        "recount3;",
        organism,
        ";",
        data_source,
        ";",
        project
    )
    title <- paste(
        "recount3 project information for project",
        project,
        "from data source",
        data_source
    )

    ## Query ExperimentHub
    q <- AnnotationHub::query(eh, pattern = c(tags, title))

    if (length(q) == 1) {
        ## ExperimentHub has the data =)
        return(q[[1]])
    } else {
        message(
            Sys.time(),
            " the project ",
            project,
            " was not found on ExperimentHub.\n",
            "Using a backup mechanism powered by recount3::available_projects()."
        )

        ## ExperimentHub backup: re-make on the fly
        projs <- available_projects(organism = organism)
        project_query <- project
        organism_query <- organism
        res <- subset(
            projs,
            organism == organism_query & project == project_query & file_source == data_source & project_type == "data_sources"
        )

        stopifnot(
            "Did not find a project with your specified query." =
                nrow(res) == 1
        )

        ## Make it consistent with the data from the hub
        res$file_source <- NULL
        res$project_type <- NULL
        rownames(res) <- NULL

        ## Done
        return(res)
    }
}
