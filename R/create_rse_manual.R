#' Internal function for creating a recount3 RangedSummarizedExperiment object
#'
#' This function is used internally by `create_rse()` to construct a `recount3`
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object that contains the base-pair coverage counts at the `gene` or `exon`
#' feature level for a given annotation.
#'
#' @param type  A `character(1)` specifying whether you want to access gene,
#' exon, or exon-exon junction counts.
#' @inheritParams file_locate_url
#' @inheritParams file_retrieve
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#' @export
#' @importFrom SummarizedExperiment SummarizedExperiment
#' @importFrom S4Vectors DataFrame
#' @importFrom rtracklayer import
#' @importFrom Matrix readMM
#' @references
#'
#' <https://doi.org/10.12688/f1000research.12223.1> for details on the
#' base-pair coverage counts used in recount2 and recount3.
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' rse_gene_ERP110066_manual <- create_rse_manual(
#'     "ERP110066",
#'     "data_sources/sra"
#' )
#' rse_gene_ERP110066_manual
#'
#' rse_gene_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq"
#' )
#' rse_gene_ERP110066_collection_manual
#'
#'
#' rse_exon_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     type = "exon"
#' )
#' rse_exon_ERP110066_collection_manual
#'
#' system.time(rse_jxn_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     type = "jxn"
#' ))
#' rse_jxn_ERP110066_collection_manual
#' \dontrun{
#' project <- "ERP110066"
#' project_home <- "collections/geuvadis_smartseq"
#' type <- "jxn"
#' organism <- "human"
#' annotation <- "gencode_v26"
#' bfc <- BiocFileCache::BiocFileCache()
#' recount3_url <- "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' }
create_rse_manual <- function(project,
    project_home = project_home_available(
        organism = organism,
        recount3_url = recount3_url,
        bfc = bfc
    ),
    type = c("gene", "exon", "jxn"),
    organism = c("human", "mouse"),
    annotation = annotation_options(organism),
    bfc = BiocFileCache::BiocFileCache(),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {
    type <- match.arg(type)
    organism <- match.arg(organism)
    project_home <- match.arg(project_home)
    annotation <- match.arg(annotation)

    ## First the metadata which is the smallest
    message(paste(Sys.time(), "downloading and reading the metadata"))
    metadata <- read_metadata(file_retrieve(
        url = file_locate_url(
            project = project,
            project_home = project_home,
            type = "metadata",
            organism = organism,
            annotation = annotation,
            recount3_url = recount3_url
        ),
        bfc = bfc
    ))

    ## Update the project_home based on the metadata
    project_home <- metadata$recount_project.file_source[1]

    ## Add the URLs to the BigWig files
    metadata$BigWigURL <- file_locate_url(
        project = project,
        project_home = project_home,
        type = "bw",
        organism = organism,
        annotation = annotation,
        recount3_url = recount3_url,
        sample = metadata$run_acc
    )

    if (type == "jxn") {
        jxn_files <- file_locate_url(
            project = project,
            project_home = project_home,
            type = "jxn",
            organism = organism,
            annotation = annotation,
            recount3_url = recount3_url
        )
    }

    message(paste(
        Sys.time(),
        "downloading and reading the feature information"
    ))
    ## Read the feature information
    if (type %in% c("gene", "exon")) {
        feature_info <-
            rtracklayer::import(file_retrieve(
                url = file_locate_url_annotation(
                    type = type,
                    organism = organism,
                    annotation = annotation,
                    recount3_url = recount3_url
                ),
                bfc = bfc
            ))
    } else if (type == "jxn") {
        feature_info <-
            GenomicRanges::GRanges(utils::read.delim(file_retrieve(
                url = jxn_files[grep("\\.RR\\.gz$", jxn_files)],
                bfc = bfc
            )))
    }

    message(
        paste(
            Sys.time(),
            "downloading and reading the counts:",
            nrow(metadata),
            ifelse(nrow(metadata) > 1, "samples", "sample"),
            "across",
            length(feature_info),
            "features."
        )
    )
    if (type %in% c("gene", "exon")) {
        counts <- read_counts(
            file_retrieve(
                url = file_locate_url(
                    project = project,
                    project_home = project_home,
                    type = type,
                    organism = organism,
                    annotation = annotation,
                    recount3_url = recount3_url
                ),
                bfc = bfc
            ),
            samples = metadata$run_acc
        )
    } else if (type == "jxn") {
        counts <- Matrix::readMM(file_retrieve(
            url = jxn_files[grep("\\.MM\\.gz$", jxn_files)],
            bfc = bfc
        ))

        ## Read in the metadata again if needed (like with collections)
        if (ncol(counts) > nrow(metadata)) {
            metadata_full <- read_metadata(file_retrieve(
                url = file_locate_url(
                    project = project,
                    project_home = project_home,
                    type = "metadata",
                    organism = organism,
                    annotation = annotation,
                    recount3_url = recount3_url
                ),
                bfc = bfc
            ))
            m <- match(metadata$run_acc, metadata_full$run_acc)
            counts <- counts[, m, drop = FALSE]
            colnames(counts) <- metadata$run_acc
        }
    }

    ## Build the RSE object
    message(paste(
        Sys.time(),
        "construcing the RangedSummarizedExperiment (rse) object"
    ))

    stopifnot(
        "Metadata run_acc and counts colnames are not matching." =
            identical(metadata$run_acc, colnames(counts))
    )

    if (type == "gene") {
        stopifnot(
            "Gene names and count rownames are not matching." =
                identical(feature_info$gene_id, rownames(counts))
        )
    } else if (type == "exon") {
        stopifnot(
            "Exon names and count rownames are not matching." =
                identical(feature_info$recount_exon_id, rownames(counts))
        )
    }

    ## Make names consistent
    names(feature_info) <- rownames(counts)
    rownames(metadata) <- colnames(counts)

    rse <- SummarizedExperiment::SummarizedExperiment(
        assays = list(counts = counts),
        colData = S4Vectors::DataFrame(metadata, check.names = FALSE),
        rowRanges = feature_info
    )
    return(rse)
}
