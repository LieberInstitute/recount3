#' Obtain the file extension for a given organism and annotation
#'
#' Given an `organism` and an `annotation`, this function returns the
#' corresponding file extension used in the `recount3` files.
#'
#' @param annotation A `character(1)` specifying which annotation you want to
#' use.
#' @inheritParams file_locate_url
#'
#'
#' @return A `character(1)` with the annotation file extension to be used.
#' @export
#'
#' @examples
#'
#' annotation_ext("human")
#' annotation_ext("mouse")
annotation_ext <- function(organism = c("human", "mouse"),
    annotation = annotation_options(organism)) {
    organism <- match.arg(organism)
    annotation <- match.arg(annotation)

    ## Define the annotation to work with
    if (organism == "human") {
        ann_ext <- switch(
            annotation,
            gencode_v26 = "G026",
            gencode_v29 = "G029",
            ercc = "ERCC",
            sirv = "SIRV"
        )
    } else if (organism == "mouse") {
        ann_ext <- switch(
            annotation,
            gencode_v23 = "G023"
        )
    }

    return(ann_ext)
}
