#' Create a recount3 RangedSummarizedExperiment gene or exon object
#'
#' Once you have identified a project you want to work with, you can use this
#' function to construct a `recount3`
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' (RSE) object at the gene or exon expression feature level. This function will
#' retrieve the data, cache it, then assemble the RSE object.
#'
#' @param project_info A `data.frame()` with one row that contains the
#' information for the project you are interested in. You can find which
#' project to work on using `todo()`.
#' @inheritParams create_rse_manual
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#' @export
#'
#' @examples
#'
#' ## Find the project you are interested in
#' ## (temporarily build this data.frame)
#' proj_info <- data.frame(
#'     project = "ERP001942",
#'     project_home = "data_sources/sra",
#'     organism = "human"
#' )
#'
#' rse_gene_ERP001942 <- create_rse(proj_info)
#'
#' ## Explore the resulting RSE object
#' rse_gene_ERP001942
#'
#' dim(rse_gene_ERP001942)
#' rowRanges(rse_gene_ERP001942)
#' colData(rse_gene_ERP001942)
#' colnames(colData(rse_gene_ERP001942))
create_rse <- function(project_info, type = c("gene", "exon"), annotation = annotation_options(project_info$organism), bfc = BiocFileCache::BiocFileCache(), recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {

    ## Check the inputs
    stopifnot(
        "'project_info' should be a data.frame" = is.data.frame(project_info),
        "'project_info' should only have one row" = nrow(project_info) == 1,
        "'project_info' should contain columns 'project', 'project_home' and 'organism'." = all(c("project", "project_home", "organism") %in% colnames(project_info))
    )

    type <- match.arg(type)
    annotation <- match.arg(annotation)

    rse <- create_rse_manual(
        project = project_info$project,
        project_home = project_info$project_home,
        type = type,
        organism = project_info$organism,
        annotation = annotation,
        bfc = bfc,
        recount3_url = recount3_url
    )

    return(rse)
}
