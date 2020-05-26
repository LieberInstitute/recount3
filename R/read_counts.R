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
#' ## Download the gene counts file for project ERP110066
#' url_ERP110066_gene <- file_locate_url("ERP110066", "data_sources/sra", type = "gene")
#' local_ERP110066_gene <- file_retrieve(url = url_ERP110066_gene)
#'
#' ## Read the gene counts, take about 3 seconds
#' system.time(ERP110066_gene_counts <- read_counts(local_ERP110066_gene))
#' dim(ERP110066_gene_counts)
#'
#' ## Explore the top left corner
#' ERP110066_gene_counts[seq_len(6), seq_len(6)]
#'
#' ## Explore the first 6 samples.
#' summary(ERP110066_gene_counts[, seq_len(6)])
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
#' \dontrun{
#' local_ERP110066_exon <- file_retrieve(
#'     file_locate_url(
#'         "ERP110066",
#'         "data_sources/sra",
#'         type = "exon"
#'     )
#' )
#' local_ERP110066_exon
#'
#' ## Read the exon counts, takes about 50-60 seconds
#' system.time(ERP110066_exon_counts <- read_counts(local_ERP110066_exon))
#' dim(ERP110066_exon_counts)
#'
#' ## Explore the top left corner
#' ERP110066_exon_counts[seq_len(6), seq_len(6)]
#'
#' ## Explore the first 6 samples.
#' summary(ERP110066_exon_counts[, seq_len(6)])
#' }
read_counts <- function(counts_file) {
    ## To get the number of samples
    counts_info <- read.delim(counts_file, skip = 2, nrows = 1)

    # ## Now read in the data without having to guess the column classes
    # counts <- read.delim(counts_file, skip = 2, row.names = 1, colClasses = c("character", rep("integer", ncol(counts_info) - 1)))

    ## Maybe switch to readr: takes 17 secs on the gene counts, so no.
    # counts <- readr::read_tsv(counts_file, skip = 2, col_types = paste(c("c", rep("i", ncol(counts_info) - 1)), collapse = ""))

    ## Fastest of them all
    counts <-
        data.table::fread(
            counts_file,
            skip = 2,
            colClasses = c("character", rep("integer", ncol(counts_info) - 1)),
            nThread = 1,
            sep = "\t",
            data.table = FALSE
        )
    #
    #     if (colnames(counts)[1] == "gene_id") {
    #         rnames <- counts$gene_id
    #         select_cols <- colnames(counts)[-1]
    #     } else {
    #         rnames <-
    #             paste0(counts$chromosome, ":", counts$start, "-", counts$end)
    #         select_cols <- colnames(counts)[-seq_len(3)]
    #     }
    rnames <- counts[[1]]
    counts <- as.matrix(counts[, -1, drop = FALSE])
    rownames(counts) <- rnames
    return(counts)
}
