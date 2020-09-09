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
#' @param jxn_format A `character(1)` specifying whether the exon-exon junction
#' files are derived from all the reads (`ALL`) or only the uniquely mapping
#' read counts (`UNIQUE`). Note that `UNIQUE` is only available for some
#' projects.
#' @param recount3_url A `character(1)` specifying the home URL for `recount3`
#' or a local directory where you have mirrored `recount3`.
#'
#' @return A `character()` with the URL(s) for the file(s) of interest.
#' @export
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Example for metadata files from a project from SRA
#' file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra"
#' )
#'
#' ## Example for metadata files from a project that is part of a collection
#' file_locate_url(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#' )
#'
#' ## Example for a BigWig file
#' file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra",
#'     "bw",
#'     "human",
#'     "ERR204900"
#' )
#'
#' ## Locate example gene count files
#' file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra",
#'     "gene"
#' )
#' file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra",
#'     "gene",
#'     annotation = "refseq"
#' )
#'
#' ## Example for a gene count file from a project that is part of a collection
#' file_locate_url(
#'     "ERP110066",
#'     "collections/geuvadis_smartseq",
#'     "gene"
#' )
#'
#' ## Locate example junction files
#' file_locate_url(
#'     "ERP110066",
#'     "data_sources/sra",
#'     "jxn"
#' )
file_locate_url <-
    function(project,
    project_home = project_home_available(
        organism = organism,
        recount3_url = recount3_url
    ),
    type = c("metadata", "gene", "exon", "jxn", "bw"),
    organism = c("human", "mouse"),
    sample = NULL,
    annotation = annotation_options(organism),
    jxn_format = c("ALL", "UNIQUE"),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {
        type <- match.arg(type)
        organism <- match.arg(organism)
        project_home <- match.arg(project_home)
        annotation <- match.arg(annotation)
        jxn_format <- match.arg(jxn_format)

        ## Define the base directories
        base_dir <- switch(
            type,
            metadata = "metadata",
            gene = "gene_sums",
            exon = "exon_sums",
            jxn = "junctions",
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
            jxn = paste0(jxn_format, ".", c("MM.gz", "RR.gz")),
            bw = "ALL.bw"
        ))

        ## Check that sample exists when type == 'bw'
        if (type == "bw") {
            if (is.null(sample)) {
                stop("You need to specify the 'sample' when type = 'bw'.",
                    call. = FALSE
                )
            }
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

        ## Metadata case
        if (type == "metadata") {
            file_tag <- c(basename(project_home), "recount_project", "recount_qc")
        } else {
            file_tag <- base_dir
        }

        ## Define the base file path
        base_file <- paste0(basename(project_home), ".", file_tag, ".", project)

        ## Handle the BigWig file case
        if (type == "bw") {
            base_url <- file.path(
                base_url,
                substr(sample, nchar(sample) - 1, nchar(sample))
            )
            base_file <- paste0(base_file, "_", sample)
        }

        ## Construct the final url(s)
        if (dirname(project_home) == "collections") {
            ## Deal with metadata collection case

            ## Locate the file source from the metadata files
            url_collection_meta <- file.path(
                recount3_url,
                organism,
                project_home,
                "metadata",
                paste0(basename(project_home), ".recount_project.gz")
            )
            names(url_collection_meta) <- basename(url_collection_meta)

            metadata <- read_metadata(
                file_retrieve(url = url_collection_meta)
            )
            i <- which(metadata$recount_project.project == project)
            stopifnot(
                "The 'project' is not part of this collection." = length(i) > 0
            )
            file_source <- metadata$recount_project.file_source[i[1]]

            ## Find the files from the file source
            url <- file_locate_url(
                project = project,
                project_home = file_source,
                type = type,
                organism = organism,
                sample = sample,
                annotation = annotation,
                recount3_url = recount3_url
            )

            ## Deal with metadata collection case
            if (type == "metadata") {

                ## Add the custom collection metadata
                url <- c(
                    url,
                    file.path(
                        recount3_url,
                        organism,
                        project_home,
                        "metadata",
                        paste0(
                            basename(project_home), ".custom.gz"
                        )
                    )
                )
            }
        } else {
            url <- file.path(base_url, paste0(base_file, file_ext))
        }
        names(url) <- basename(url)

        ## Done
        return(url)
    }
