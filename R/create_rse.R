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
#'     project = "ERP110066",
#'     project_home = "data_sources/sra",
#'     organism = "human"
#' )
#'
#' ## Create a RSE object at the gene level
#' rse_gene_ERP110066 <- create_rse(proj_info)
#'
#' ## Explore the resulting RSE gene object
#' rse_gene_ERP110066
#'
#' ## Information about how this RSE object was made
#' metadata(rse_gene_ERP110066)
#'
#' ## Number of genes by number of samples
#' dim(rse_gene_ERP110066)
#'
#' ## Information about the genes
#' rowRanges(rse_gene_ERP110066)
#'
#' ## Sample metadata
#' colnames(colData(rse_gene_ERP110066))
#'
#' ## Check how much memory this RSE object uses
#' pryr::object_size(rse_gene_ERP110066)
#'
#' ## Create a second RSE object using another annotation
#' rse_gene_ERP110066_gencode_v29 <- create_rse(
#'     proj_info,
#'     annotation = "gencode_v29"
#' )
#' rowRanges(rse_gene_ERP110066_gencode_v29)
#'
#' ## Doesn't work right now
#' # rse_gene_ERP110066_refseq <- create_rse(
#' #     proj_info,
#' #     annotation = "refseq"
#' # )
#'
#' ## Create a RSE object at the exon level
#' \dontrun{
#' rse_exon_ERP110066 <- create_rse(
#'     proj_info,
#'     type = "exon"
#' )
#'
#' ## Explore the resulting RSE exon object
#' rse_exon_ERP110066
#'
#' dim(rse_exon_ERP110066)
#' rowRanges(rse_exon_ERP110066)
#' pryr::object_size(rse_exon_ERP110066)
#' # 5.73 GB
#' }
#'
#' ## Create a RSE object at the exon-exon junction level
#' rse_jxn_ERP110066 <- create_rse(
#'     proj_info,
#'     type = "jxn"
#' )
#'
#' ## Explore the resulting RSE exon object
#' rse_jxn_ERP110066
#'
#' dim(rse_jxn_ERP110066)
#' rowRanges(rse_jxn_ERP110066)
#' pryr::object_size(rse_jxn_ERP110066)
#'
#' ## Remove the example rse_jxn for memory purposes
#' rm(rse_jxn_ERP110066)
create_rse <-
    function(project_info,
    type = c("gene", "exon", "jxn"),
    annotation = annotation_options(project_info$organism),
    bfc = BiocFileCache::BiocFileCache(),
    jxn_format = c("ALL", "UNIQUE"),
    recount3_url = "https://idies.jhu.edu/recount3/data") {
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
            recount3_url = recount3_url
        )

        return(rse)
    }
