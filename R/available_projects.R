#' List available samples in recount3
#'
#' This function returns a `data.frame()` with the samples that are available
#' from `recount3`. Note that a specific sample might be available from a
#' given `data_source` and none or many `collections`.
#'
#' @inheritParams project_home_available
#'
#' @return A `data.frame()` with the sample ID used by the original source of
#' the data (`external_id`), the project ID (`project`), the `organism`, the
#' `file_source` from where the data was accessed, the date the sample
#' was processed (`date_processed`) in `YYYY-MM-DD` format,
#' the `recount3` project home location (`project_home`), and the project
#' `project_type` that differentiates between `data_sources` and `compilations`.
#'
#' @export
#' @importFrom utils read.delim
#'
#' @examples
#'
#' ## Find all the human samples available from recount3
#' human_samples <- available_samples()
#' dim(human_samples)
#' head(human_samples)
#'
#' ## How many are from a data source vs a compilation?
#' table(human_samples$project_type, useNA = "ifany")
#'
#' ## What are the unique file sources?
#' table(
#'     human_samples$file_source[human_samples$project_type == "data_sources"]
#' )
#'
#' ## Find all the mouse samples available from recount3
#' mouse_samples <- available_samples("mouse")
#' dim(mouse_samples)
#' head(mouse_samples)
#'
#' ## How many are from a data source vs a compilation?
#' table(mouse_samples$project_type, useNA = "ifany")
available_samples <- function(organism = c("human", "mouse"),
    recount3_url = "http://idies.jhu.edu/recount3/data",
    bfc = BiocFileCache::BiocFileCache()) {
    organism <- match.arg(organism)

    homes <- project_home_available(
        organism = organism,
        recount3_url = recount3_url,
        bfc = bfc
    )


    urls <- file.path(
        recount3_url,
        organism,
        homes,
        "metadata",
        paste0(basename(homes), ".recount_project.MD.gz")
    )
    names(urls) <- basename(homes)

    local_files <- file_retrieve(urls, bfc = bfc)

    samples_list <- lapply(
        local_files,
        utils::read.delim,
        sep = "\t",
        check.names = FALSE
    )
    samples <- do.call(rbind, lapply(samples_list, function(df) {
        colnames(df) <- gsub(".*\\.", "", colnames(df))
        return(df)
    }))
    rownames(samples) <- NULL

    ## Make organism names consistent with the R package
    samples$organism[samples$organism == "Homo sapiens"] <- "human"
    samples$organism[samples$organism == "Mus musculus"] <- "mouse"

    ## Remove study since it's duplicated with project
    stopifnot(identical(samples$project, samples$study))
    samples$study <- NULL

    ## Don't show the file_source, since that's handled by create_rse*()
    samples$file_source <- basename(samples$file_source)
    samples$project_home <- samples$metadata_source
    samples$metadata_source <- NULL

    ## data_source vs compilation
    samples$project_type <- dirname(samples$project_home)

    ## don't show the rail_id since it's internal
    samples$rail_id <- NULL

    return(samples)
}


#' List available projects in recount3
#'
#' @inheritParams available_samples
#'
#' @return A `data.frame()` with the project ID (`project`), the `organism`, the
#' `file_source` from where the data was accessed,
#' the `recount3` project home location (`project_home`), and the project
#' `project_type` that differentiates between `data_sources` and `compilations`.
#' @export
#'
#' @examples
#'
#' ## Find all the human projects
#' human_projects <- available_projects()
#'
#' ## Explore the results
#' dim(human_projects)
#' head(human_projects)
#'
#' ## How many are from a data source vs a compilation?
#' table(human_projects$project_type, useNA = "ifany")
#'
#' ## What are the unique file sources?
#' table(
#'     human_projects$file_source[human_projects$project_type == "data_sources"]
#' )
#'
#' ## Note that big projects are broken up to make them easier to access
#' ## For example, GTEx and TCGA are broken up by tissue
#' head(subset(human_projects, file_source == "gtex"))
#' head(subset(human_projects, file_source == "tcga"))
#'
#' ## Find all the mouse projects
#' mouse_projects <- available_projects(organism = "mouse")
#'
#' ## Explore the results
#' dim(mouse_projects)
#' head(mouse_projects)
#'
#' ## How many are from a data source vs a compilation?
#' table(mouse_projects$project_type, useNA = "ifany")
#'
#' ## What are the unique file sources?
#' table(
#'     mouse_projects$file_source[mouse_projects$project_type == "data_sources"]
#' )
available_projects <- function(organism = c("human", "mouse"),
    recount3_url = "http://idies.jhu.edu/recount3/data",
    bfc = BiocFileCache::BiocFileCache()) {
    organism <- match.arg(organism)

    samples <- available_samples(
        organism = organism,
        recount3_url = recount3_url,
        bfc = bfc
    )

    ## Remove sample-specific info
    samples$external_id <- NULL
    samples$date_processed <- NULL
    samples$project_type <- NULL

    ## Identify the unique projects
    projects <- samples[!duplicated(samples), , drop = FALSE]
    projects$project_type <- dirname(projects$project_home)

    return(projects)
}
