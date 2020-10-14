#' Read a counts file
#'
#' This function reads in a `recount3` gene or gexon counts file into R. You can
#' first locate the file using `locate_url()` then download it to your
#' computer using `file_retrieve()`.
#'
#' @param counts_file A `character(1)` with the local path to a `recount3`
#' counts file.
#' @param samples A `character()` with `external_id` sample IDs to read in. When
#' `NULL` (default), all samples will be read in. This argument is used by
#' `create_rse_manual()`.
#'
#' @return A `data.frame()` with sample IDs as the column names.
#' @export
#' @importFrom utils read.delim
#' @importFrom data.table fread
#' @importFrom R.utils gunzip
#'
#' @references
#'
#' <https://doi.org/10.12688/f1000research.12223.1> for details on the
#' base-pair coverage counts used in recount2 and recount3.
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the gene counts file for project SRP009615
#' url_SRP009615_gene <- locate_url(
#'     "SRP009615",
#'     "data_sources/sra",
#'     type = "gene"
#' )
#' local_SRP009615_gene <- file_retrieve(url = url_SRP009615_gene)
#'
#' ## Read the gene counts, take about 3 seconds
#' system.time(SRP009615_gene_counts <- read_counts(local_SRP009615_gene))
#' dim(SRP009615_gene_counts)
#'
#' ## Explore the top left corner
#' SRP009615_gene_counts[seq_len(6), seq_len(6)]
#'
#' ## Explore the first 6 samples.
#' summary(SRP009615_gene_counts[, seq_len(6)])
#'
#' ## Note that the count units are in
#' ## base-pair coverage counts just like in the recount2 project.
#' ## See https://doi.org/10.12688/f1000research.12223.1 for more details
#' ## about this type of counts.
#' ## They can be converted to reads per 40 million reads, RPKM and other
#' ## counts. This is more easily done once assembled into a
#' ## RangedSummarizedExperiment object.
#'
#' ## Locate and retrieve an exon counts file
#' local_SRP009615_exon <- file_retrieve(
#'     locate_url(
#'         "SRP009615",
#'         "data_sources/sra",
#'         type = "exon"
#'     )
#' )
#' local_SRP009615_exon
#'
#' ## Read the exon counts, takes about 50-60 seconds
#' system.time(
#'     SRP009615_exon_counts <- read_counts(
#'         local_SRP009615_exon
#'     )
#' )
#' dim(SRP009615_exon_counts)
#' pryr::object_size(SRP009615_exon_counts)
#'
#' ## Explore the top left corner
#' SRP009615_exon_counts[seq_len(6), seq_len(6)]
#'
#' ## Explore the first 6 samples.
#' summary(SRP009615_exon_counts[, seq_len(6)])
read_counts <- function(counts_file, samples = NULL) {
    ## To get the number of samples
    counts_info <-
        read.delim(
            counts_file,
            skip = 2,
            nrows = 1,
            check.names = FALSE
        )

    ## Samples to read in
    if (is.null(samples)) {
        to_read <- colnames(counts_info)
    } else {
        if (!all(samples %in% colnames(counts_info))) {
            invalid_samples <-
                paste(samples[!samples %in% colnames(counts_info)], collapse = "', '")
            stop(
                "Not all 'samples' are present in the 'counts_file'. Invalid sample names are: '",
                invalid_samples,
                "'",
                call. = FALSE
            )
        }

        to_read <- c(colnames(counts_info)[1], samples)
    }

    ## Now read in the data without having to guess the column classes
    counts <-
        data.table::fread(
            counts_file,
            skip = 2,
            colClasses = c("character", rep("integer", ncol(counts_info) - 1)),
            nThread = 1,
            sep = "\t",
            data.table = FALSE,
            select = to_read
        )

    ## Save the row names
    rnames <- counts[[1]]

    ## Cast to a matrix
    counts <- as.matrix(counts[, -1, drop = FALSE])
    rownames(counts) <- rnames
    return(counts)
}
