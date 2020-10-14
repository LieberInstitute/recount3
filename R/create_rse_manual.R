#' Internal function for creating a recount3 RangedSummarizedExperiment object
#'
#' This function is used internally by `create_rse()` to construct a `recount3`
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object that contains the base-pair coverage counts at the `gene` or `exon`
#' feature level for a given annotation.
#'
#' @param type  A `character(1)` specifying whether you want to access gene,
#' exon, or exon-exon junction counts.
#' @inheritParams locate_url
#' @inheritParams file_retrieve
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#' @export
#' @importFrom SummarizedExperiment SummarizedExperiment "assayNames<-"
#' "metadata<-"
#' @importFrom S4Vectors DataFrame
#' @importFrom rtracklayer import.bed
#' @importFrom Matrix readMM
#' @importFrom GenomicRanges GRanges
#' @importFrom sessioninfo package_info
#' @references
#'
#' <https://doi.org/10.12688/f1000research.12223.1> for details on the
#' base-pair coverage counts used in recount2 and recount3.
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Unlike create_rse(), here we create an RSE object by
#' ## fully specifying all the arguments for locating this study
#' rse_gene_SRP009615_manual <- create_rse_manual(
#'     "SRP009615",
#'     "data_sources/sra"
#' )
#' rse_gene_SRP009615_manual
#'
#' ## Check how much memory this RSE object uses
#' pryr::object_size(rse_gene_SRP009615_manual)
#'
#' ## Test with a collection that has a single sample
#' ## NOTE: this requires loading the full data for this study when
#' ## creating the RSE object
#' rse_gene_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' )
#' rse_gene_ERP110066_collection_manual
#'
#' ## Check how much memory this RSE object uses
#' pryr::object_size(rse_gene_ERP110066_collection_manual)
#'
#' ## Mouse example
#' rse_gene_DRP002367_manual <- create_rse_manual(
#'     "DRP002367",
#'     "data_sources/sra",
#'     organism = "mouse"
#' )
#' rse_gene_DRP002367_manual
#'
#' ## Information about how this RSE was made
#' metadata(rse_gene_DRP002367_manual)
#'
#' ## Test with a collection that has one sample, at the exon level
#' ## NOTE: this requires loading the full data for this study (nearly 6GB!)
#' \dontrun{
#' rse_exon_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     type = "exon",
#'     recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' )
#' rse_exon_ERP110066_collection_manual
#'
#'
#' ## Check how much memory this RSE object uses
#' pryr::object_size(rse_exon_ERP110066_collection_manual)
#' # 409 MB
#'
#' ## Test with a collection that has one sample, at the junction level
#' ## NOTE: this requires loading the full data for this study
#' system.time(rse_jxn_ERP110066_collection_manual <- create_rse_manual(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     type = "jxn",
#'     recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#' ))
#' rse_jxn_ERP110066_collection_manual
#'
#' ## Check how much memory this RSE object uses
#' ## NOTE: this doesn't run since 2 files are missing on the test site!
#' pryr::object_size(rse_jxn_ERP110066_collection_manual)
#' }
#'
#' \dontrun{
#' ## For testing and debugging
#' project <- "ERP110066"
#' project_home <- "collections/geuvadis_smartseq"
#'
#' project <- "SRP009615"
#' project_home <- "data_sources/sra"
#' type <- "gene"
#' organism <- "human"
#' annotation <- "refseq"
#' jxn_format <- "ALL"
#' bfc <- BiocFileCache::BiocFileCache()
#' recount3_url <- "http://idies.jhu.edu/recount3/data"
#' }
create_rse_manual <- function(project,
    project_home = project_homes(
        organism = organism,
        recount3_url = recount3_url
    ),
    type = c("gene", "exon", "jxn"),
    organism = c("human", "mouse"),
    annotation = annotation_options(organism),
    bfc = BiocFileCache::BiocFileCache(),
    jxn_format = c("ALL", "UNIQUE"),
    recount3_url = getOption("recount3_url", "http://idies.jhu.edu/recount3/data")) {
    type <- match.arg(type)
    organism <- match.arg(organism)
    project_home <- match.arg(project_home)
    annotation <- match.arg(annotation)
    jxn_format <- match.arg(jxn_format)

    ## First the metadata which is the smallest
    message(
        Sys.time(),
        " downloading and reading the metadata."
    )

    metadata <- read_metadata(file_retrieve(
        url = locate_url(
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
    project_home_original <- project_home
    project_home <- metadata$recount_project.file_source[1]

    ## Add the URLs to the BigWig files
    metadata$BigWigURL <- locate_url(
        project = project,
        project_home = project_home,
        type = "bw",
        organism = organism,
        annotation = annotation,
        recount3_url = recount3_url,
        sample = metadata$external_id
    )

    if (type == "jxn") {
        jxn_files <- locate_url(
            project = project,
            project_home = project_home,
            type = "jxn",
            organism = organism,
            annotation = annotation,
            jxn_format = jxn_format,
            recount3_url = recount3_url
        )
    }

    message(
        Sys.time(),
        " downloading and reading the feature information."
    )
    ## Read the feature information
    if (type %in% c("gene", "exon")) {
        feature_info <-
            rtracklayer::import.bed(file_retrieve(
                url = locate_url_ann(
                    type = type,
                    organism = organism,
                    annotation = annotation,
                    recount3_url = recount3_url
                ),
                bfc = bfc
            ))
    } else if (type == "jxn") {
        feature_info <- utils::read.delim(file_retrieve(
            url = jxn_files[grep("\\.RR\\.gz$", jxn_files)],
            bfc = bfc
        ))
        ## Testing with ERP001942 revealed an issue here
        # > table(x$strand)
        #       -       ?       +
        # 1409791    7842 1432569
        feature_info$strand[feature_info$strand == "?"] <- "*"

        feature_info <- GenomicRanges::GRanges(feature_info)
    }

    message(
        Sys.time(),
        " downloading and reading the counts: ",
        nrow(metadata),
        ifelse(nrow(metadata) > 1, " samples", " sample"),
        " across ",
        length(feature_info),
        " features."
    )
    if (type %in% c("gene", "exon")) {
        counts <- read_counts(
            file_retrieve(
                url = locate_url(
                    project = project,
                    project_home = project_home,
                    type = type,
                    organism = organism,
                    annotation = annotation,
                    recount3_url = recount3_url
                ),
                bfc = bfc
            ),
            samples = metadata$external_id
        )
    } else if (type == "jxn") {
        counts <- Matrix::readMM(file_retrieve(
            url = jxn_files[grep("\\.MM\\.gz$", jxn_files)],
            bfc = bfc
        ))

        message(
            Sys.time(),
            " matching exon-exon junction counts with the metadata."
        )
        ## The samples in the MM jxn table are not in the same order as the
        ## metadata!
        jxn_rail <- read.delim(file_retrieve(
            url = jxn_files[grep("\\.ID\\.gz$", jxn_files)],
            bfc = bfc
        ))
        m <- match(metadata$rail_id, jxn_rail$rail_id)
        stopifnot(
            "Metadata rail_id and exon-exon junctions rail_id are not matching." =
                !all(is.na(m))
        )
        counts <- counts[, m, drop = FALSE]
        colnames(counts) <- metadata$external_id
    }

    ## Build the RSE object
    message(
        Sys.time(),
        " construcing the RangedSummarizedExperiment (rse) object."
    )

    stopifnot(
        "Metadata external_id and counts colnames are not matching." =
            identical(metadata$external_id, colnames(counts))
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
    } else if (type == "jxn") {
        rownames(counts) <- as.character(feature_info)
    }

    ## Make names consistent
    names(feature_info) <- rownames(counts)
    rownames(metadata) <- colnames(counts)
    recount3_pkg <- sessioninfo::package_info(
        pkgs = "recount3",
        include_base = FALSE,
        dependencies = FALSE
    )

    rse <- SummarizedExperiment::SummarizedExperiment(
        assays = list(counts = counts),
        colData = S4Vectors::DataFrame(metadata, check.names = FALSE),
        rowRanges = feature_info,
        metadata = list(
            time_created = Sys.time(),
            recount3_version = as.data.frame(recount3_pkg),
            project = project,
            project_home = project_home_original,
            type = type,
            organism = organism,
            annotation = annotation,
            jxn_format = jxn_format,
            recount3_url = recount3_url
        )
    )
    if (type %in% c("gene", "exon")) {
        ## Change the name for gene and exons, just to highlight that these
        ## are not read counts
        assayNames(rse) <- "raw_counts"

        ## Remove jxn_format since it has nothing to do with genes/exons
        metadata(rse)$jxn_format <- NULL
    }
    return(rse)
}
