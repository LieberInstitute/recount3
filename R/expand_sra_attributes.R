#' Expand SRA attributes
#'
#' This function expands the SRA attributes stored in `sra.sample_attributes`
#' variable in the `colData()` slot of a
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' produced by `create_rse()`.
#'
#' Note that this function will work on projects available from SRA only.
#' Furthermore, SRA attributes are project-specific. Thus, if you use this
#' function in more than one RSE object, you won't be able to combine them
#' easily with `cbind()` and will need to manually merge the `colData()` slots
#' from your set of RSE files before being able to run `cbind()`.
#'
#'
#' @param rse A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object created by `create_rse()` or `create_rse_manual()`.
#'
#' @return A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object with expanded metadata columns.
#' @export
#' @importFrom SummarizedExperiment colData<-
#' @author Andrew E Jaffe modified by Leonardo Collado-Torres.
#'
#' @examples
#'
#' ## Find all available human projects
#' human_projects <- available_projects()
#'
#' ## Find the project you are interested in
#' proj_info <- subset(
#'     human_projects,
#'     project == "SRP009615" & project_type == "data_sources"
#' )
#'
#' ## Create a RSE object at the gene level
#' rse_gene_SRP009615 <- create_rse(proj_info)
#'
#' ## Expand the SRA attributes (see details for more information)
#' rse_gene_SRP009615 <- expand_sra_attributes(rse_gene_SRP009615)
expand_sra_attributes <- function(rse) {
    if (!"sra.sample_attributes" %in% colnames(colData(rse))) {
        warning(
            "sra.sample_attributes was absent from the input rse. Will return the original rse object.",
            call. = FALSE
        )
        return(rse)
    }
    d <- strsplit(rse$sra.sample_attributes, "|", fixed = TRUE)
    names(d) <- colnames(rse)
    d <- lapply(d, function(x) {
        names(x) <- .ss(x, ";;")
        x <- .ss(x, ";;", 2)
    })
    d <- do.call(rbind, d)
    colnames(d) <- paste0("sra_attribute.", gsub(" ", "_", colnames(d)))
    colData(rse) <- cbind(colData(rse), d)
    return(rse)
}

## Taken from https://github.com/LieberInstitute/jaffelab/blob/master/R/ss.R
.ss <- function(x, pattern, slot = 1, ...) {
    sapply(strsplit(x = x, split = pattern, ...), "[", slot)
}
