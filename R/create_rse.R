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
#' project to work on using `available_projects()`.
#' @inheritParams create_rse_manual
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#' @export
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
#' ## Explore the resulting RSE gene object
#' rse_gene_SRP009615
#'
#' ## Information about how this RSE object was made
#' metadata(rse_gene_SRP009615)
#'
#' ## Number of genes by number of samples
#' dim(rse_gene_SRP009615)
#'
#' ## Information about the genes
#' rowRanges(rse_gene_SRP009615)
#'
#' ## Sample metadata
#' colnames(colData(rse_gene_SRP009615))
#'
#' ## Check how much memory this RSE object uses
#' pryr::object_size(rse_gene_SRP009615)
#'
#' ## Create an RSE object using gencode_v29 instead of gencode_v26
#' rse_gene_SRP009615_gencode_v29 <- create_rse(
#'     proj_info,
#'     annotation = "gencode_v29",
#'     verbose = FALSE
#' )
#' rowRanges(rse_gene_SRP009615_gencode_v29)
#'
#' ## Create an RSE object using FANTOM6_CAT instead of gencode_v26
#' rse_gene_SRP009615_fantom6_cat <- create_rse(
#'     proj_info,
#'     annotation = "fantom6_cat"
#' )
#' rowRanges(rse_gene_SRP009615_fantom6_cat)
#'
#' ## Create an RSE object using RefSeq instead of gencode_v26
#' rse_gene_SRP009615_refseq <- create_rse(
#'     proj_info,
#'     annotation = "refseq"
#' )
#' rowRanges(rse_gene_SRP009615_refseq)
#'
#' ## Create an RSE object using ERCC instead of gencode_v26
#' rse_gene_SRP009615_ercc <- create_rse(
#'     proj_info,
#'     annotation = "ercc"
#' )
#' rowRanges(rse_gene_SRP009615_ercc)
#'
#' ## Create an RSE object using SIRV instead of gencode_v26
#' rse_gene_SRP009615_sirv <- create_rse(
#'     proj_info,
#'     annotation = "sirv"
#' )
#' rowRanges(rse_gene_SRP009615_sirv)
#'
#' ## Obtain a list of RSE objects for all gene annotations
#' rses_gene <- lapply(annotation_options(), function(x) {
#'     create_rse(proj_info, type = "gene", annotation = x)
#' })
#' names(rses_gene) <- annotation_options()
#' rses_gene
#'
#' ## Create a RSE object at the exon level
#' rse_exon_SRP009615 <- create_rse(
#'     proj_info,
#'     type = "exon"
#' )
#'
#' ## Explore the resulting RSE exon object
#' rse_exon_SRP009615
#'
#' dim(rse_exon_SRP009615)
#' rowRanges(rse_exon_SRP009615)
#' pryr::object_size(rse_exon_SRP009615)
#'
#' ## Create a RSE object at the exon-exon junction level
#' rse_jxn_SRP009615 <- create_rse(
#'     proj_info,
#'     type = "jxn"
#' )
#'
#' ## Explore the resulting RSE exon-exon junctions object
#' rse_jxn_SRP009615
#'
#' dim(rse_jxn_SRP009615)
#' rowRanges(rse_jxn_SRP009615)
#' pryr::object_size(rse_jxn_SRP009615)
#'
#' ## Obtain a list of RSE objects for all exon annotations
#' \dontrun{
#' rses_exon <- lapply(annotation_options(), function(x) {
#'     create_rse(proj_info, type = "exon", annotation = x, verbose = FALSE)
#' })
#' names(rses_exon) <- annotation_options()
#' }
create_rse <-
    function(project_info,
    type = c("gene", "exon", "jxn"),
    annotation = annotation_options(project_info$organism),
    bfc = recount3_cache(),
    jxn_format = c("ALL", "UNIQUE"),
    recount3_url = getOption("recount3_url", "http://idies.jhu.edu/recount3/data"),
    verbose = getOption("recount3_verbose", TRUE)) {
        ## Check the inputs
        stopifnot(
            "'project_info' should be a data.frame" =
                is.data.frame(project_info),
            "'project_info' should only have one row" =
                nrow(project_info) == 1,
            "'project_info' should contain columns 'project', 'project_home' and 'organism'." =
                all(
                    c("project", "project_home", "organism") %in%
                        colnames(project_info)
                )
        )

        type <- match.arg(type)
        annotation <- match.arg(annotation)
        jxn_format <- match.arg(jxn_format)

        rse <- create_rse_manual(
            project = project_info$project,
            project_home = project_info$project_home,
            type = type,
            organism = project_info$organism,
            annotation = annotation,
            bfc = bfc,
            jxn_format = jxn_format,
            recount3_url = recount3_url,
            verbose = verbose
        )

        return(rse)
    }
