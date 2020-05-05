#' Construct the URL to access a particular `recount3` file
#'
#' Given an organism of interest, this function constructs the URL for accessing
#' one of the output files from the `recount3` project. You can then download
#' the file using `file_retrieve()`.
#'
#' @param project A `character(1)` with the ID for a given study.
#' @param project_home A `character(1)` with the home directory for the
#' `project`. You can find these using `project_home_available()`.
#' @param type A `character(1)` specifying whether you want to access gene
#' counts, exon counts, exon-exon junctions or base-pair BigWig coverage files
#' (one per `sample`).
#' @param organism A `character(1)` specifying which organism you want to
#' download data from. Supported options are `"human"` or `"mouse"`.
#' @param sample A `character()` vector with the sample ID(s) you want to
#' download.
#' @param annotation A `character(1)` specifying which annotation you want to
#' download. Only used when `type` is either `gene` or `exon`.
#' @param recount3_url A `character(1)` specifying the home URL for `recount3`
#' or a local directory where you have mirrored `recount3`.
#'
#' @return A `character(1)` with the URL for the file of interest.
#' @export
#'
#' @examples
#'
#' ## Example for a metadata file
#' file_locate_url("ERP001942", "data_sources/sra")
#'
#' ## Example for a BigWig file
#' file_locate_url("ERP001942", "data_sources/sra", "bw", "human", "ERR204900")
file_locate_url <-
    function(project,
    project_home = project_home_available(
        organism = organism,
        recount3_url = recount3_url
    ),
    type = c("metadata", "gene", "exon", "jxn", "bw"),
    organism = c("human", "mouse"),
    sample = NULL,
    annotation = c("gencode_v26", "gencode_v29", "ercc", "sirv"),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {
        type <- match.arg(type)
        organism <- match.arg(organism)
        project_home <- match.arg(project_home)
        annotation <- match.arg(annotation)

        ## Define the base directories
        base_dir <- switch(
            type,
            metadata = "metadata",
            gene = "gene_sums",
            exon = "exon_sums",
            jxn = "something_todo",
            bw = "base_sums"
        )

        ## Define the annotation to work with
        ann_ext <- annotation_ext(organism = organism, annotation = annotation)

        ## Define the file extensions
        file_ext <- paste0(".", switch(
            type,
            metadata = "MD.gz",
            gene = paste0(ann_ext, ".gz"),
            exon = paste0(ann_ext, ".gz"),
            jxn = "something_todo",
            bw = "ALL.bw"
        ))

        ## Check that sample exists when type == 'bw'
        if (type == "bw") {
            if (is.null(sample)) {
                stop("You need to specify the 'sample' when type = 'bw'.",
                    call. = FALSE
                )
            }
        } else if (type == "jxn") {
            stop("Currently type = 'jxn' is not supported", call. = FALSE)
        }

        ## Base URL
        base_url <- file.path(
            recount3_url,
            organism,
            project_home,
            base_dir,
            substr(project, nchar(project) - 1, nchar(project)),
            project
        )

        ## Define the base file path
        base_file <- paste0(basename(project_home), ".", base_dir, ".", project)

        ## Handle the BigWig file case
        if (type == "bw") {
            base_url <- file.path(base_url, substr(sample, nchar(sample) - 1, nchar(sample)))
            base_file <- paste0(base_file, "_", sample)
        }

        ## Construct the final url
        url <- file.path(base_url, paste0(base_file, file_ext))
        names(url) <- base_file

        ## Done
        return(url)
    }
