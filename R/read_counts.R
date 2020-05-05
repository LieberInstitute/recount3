#' Read a counts file
#'
#' This function reads in a `recount3` gene or gexon counts file into R. You can
#' first locate the file using `file_locate_url()` then download it to your
#' computer using `file_retrieve()`.
#'
#' @param counts_file A `character(1)` with the local path to a `recount3`
#' counts file.
#'
#' @return A `data.frame()` with sample IDs as the column names.
#' @export
#' @importFrom utils read.delim
#'
#' @references
#'
#' <https://doi.org/10.12688/f1000research.12223.1> for details on the
#' base-pair coverage counts used in recount2 and recount3.
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the gene counts file for project ERP001942
#' url_ERP001942_gene <- file_locate_url("ERP001942", "data_sources/sra", type = "gene")
#' local_ERP001942_gene <- file_retrieve(url = url_ERP001942_gene)
#'
#' ## Read the gene counts, take about 25 seconds
#' system.time(ERP001942_gene_counts <- read_counts(local_ERP001942_gene))
#' dim(ERP001942_gene_counts)
#'
#' ## Explore the top left corner
#' ERP001942_gene_counts[seq_len(6), seq_len(6)]
#'
#' ## Explore the first 6 samples.
#' summary(ERP001942_gene_counts[, seq_len(6)])
#'
#' ## Note that the count units are in
#' ## base-pair coverage counts just like in the recount2 project.
#' ## See https://doi.org/10.12688/f1000research.12223.1 for more details
#' ## about this type of counts.
#' ## They can be converted to reads per 40 million reads, RPKM and other
#' ## counts. This is more easily done once assembled into a
#' ## RangedSummarizedExperiment object.
read_counts <- function(counts_file) {
    ## Maybe switch to readr, specify column classes
    counts <- read.delim(counts_file, skip = 2, row.names = 1)
    return(counts)
}
