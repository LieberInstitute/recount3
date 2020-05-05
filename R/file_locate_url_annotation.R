file_locate_url_annotation <- function(type = c("gene", "exon"),
    organism = c("human", "mouse"),
    annotation = annotation_options(organism),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {
    type <- match.arg(type)
    organism <- match.arg(organism)
    annotation <- match.arg(annotation)

    ## Define the base directories
    base_dir <- switch(
        type,
        gene = "gene_sums",
        exon = "exon_sums"
    )

    ## Define the annotation to work with
    if (organism == "human") {
        ann_ext <- switch(
            annotation,
            gencode_v26 = "G026",
            gencode_v29 = "G029",
            ercc = "ERCC",
            sirv = "SIRV"
        )
    }
}
