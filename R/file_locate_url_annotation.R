#' Construct the URL to a recount3 annotation file
#'
#' Given a expression feature `type`, `organism` and `annotation`, this
#' function constructs the URL (or file path) to access a recount3
#' annotation file. This function is used by `create_rse_manual()`.
#'
#' @param type  A `character(1)` specifying whether you want to access gene
#' counts or exon data.
#' @inheritParams create_rse_manual
#'
#' @return A `character(1)` with the URL (or file path) to access the
#' recount3 annotation file.
#'
#' @family internal functions for accessing the recount3 data
#' @export
#'
#' @examples
#'
#' file_locate_url_annotation()
#' file_locate_url_annotation(organism = "mouse")
file_locate_url_annotation <- function(type = c("gene", "exon"),
    organism = c("human", "mouse"),
    annotation = annotation_options(organism),
    recount3_url = "http://idies.jhu.edu/recount3/data") {
    type <- match.arg(type)
    organism <- match.arg(organism)
    annotation <- match.arg(annotation)

    ## Define the base directories
    base_dir <- switch(type,
        gene = "gene_sums",
        exon = "exon_sums"
    )

    ## Define the annotation to work with
    ann_ext <-
        annotation_ext(organism = organism, annotation = annotation)

    base_file <- paste0(organism, ".", base_dir, ".", ann_ext)
    url <-
        file.path(
            recount3_url,
            organism,
            "annotations",
            base_dir,
            paste0(base_file, ".gtf.gz")
        )
    names(url) <- basename(url)

    return(url)
}
