#' Transform the raw counts provided by the recount3 project
#'
#' In preparation for a differential expression analysis, you will have to
#' choose how to scale the raw counts provided by the recount3 project. These
#' raw counts are similar to those provided by the recount2 project, except
#' that they were generated with a different aligner and a modified counting
#' approach. The raw coverage counts for recount2 are described with
#' illustrative figures at <https://doi.org/10.12688/f1000research.12223.1>.
#' Note that the raw counts are the sum of the base level coverage so you have
#' to take into account the total base-pair coverage for the given sample
#' (default option) by using the area under the coverage (AUC), or alternatively
#' use the mapped read lengths. You might want to do some further scaling to
#' take into account the gene or exon lengths. If you prefer to calculate read
#' counts without scaling check the function `compute_read_counts()`.
#'
#' This function is similar to
#' `recount::scale_counts()` but more general and with a different name to
#' avoid NAMESPACE conflicts.
#'
#' To compute RPKMs, use `recount::getRPKM(length_var = "score")`. Similarly,
#' for TPMs, use `recount::getTPM(length_var = "score")`.
#'
#' @param rse A
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' created by `create_rse()`.
#' @param round A `logical(1)` specifying whether to round the transformed
#' counts or not.
#' @inheritParams compute_scale_factors
#' @param ... Further arguments passed to `compute_scale_factors()`.
#'
#' @return A `matrix()` with the transformed (scaled) counts.
#' @export
#' @family count transformation functions
#'
#' @examples
#'
#' ## Create a RSE object at the gene level
#' rse_gene_SRP009615 <- create_rse(recount3_hub("SRP009615"))
#'
#' ## Scale the counts using the AUC
#' assays(rse_gene_SRP009615)$counts <- transform_counts(rse_gene_SRP009615)
#'
#' ## See that now we have two assayNames()
#' rse_gene_SRP009615
#' assayNames(rse_gene_SRP009615)
#' \dontrun{
#' ## You can compare the scaled counts against those from
#' ## recount::scale_counts() from the recount2 project
#' ## which used a different RNA-seq aligner
#' ## If needed, install recount, the R/Bioconductor package for recount2:
#' # BiocManager::install("recount")
#' recount2_sizes <- colSums(assay(recount::scale_counts(
#'     recount::rse_gene_SRP009615,
#'     by = "auc"
#' ), "counts")) / 1e6
#' recount3_sizes <- colSums(assay(rse_gene_SRP009615, "counts")) / 1e6
#' recount_sizes <- data.frame(
#'     recount2 = recount2_sizes[order(names(recount2_sizes))],
#'     recount3 = recount3_sizes[order(names(recount3_sizes))]
#' )
#' plot(recount2 ~ recount3, data = recount_sizes)
#' abline(a = 0, b = 1, col = "purple", lwd = 2, lty = 2)
#'
#' ## Compute RPKMs
#' assays(rse_gene_SRP009615)$RPKM <- recount::getRPKM(rse_gene_SRP009615, length_var = "score")
#' colSums(assay(rse_gene_SRP009615, "RPKM"))
#'
#' ## Compute TPMs
#' assays(rse_gene_SRP009615)$TPM <- recount::getTPM(rse_gene_SRP009615, length_var = "score")
#' colSums(assay(rse_gene_SRP009615, "TPM")) / 1e6 ## Should all be equal to 1
#' }
transform_counts <- function(
    rse,
    by = c("auc", "mapped_reads"),
    targetSize = 4e7,
    L = 100,
    round = TRUE,
    ...) {

    ## Check inputs
    stopifnot(is(rse, "RangedSummarizedExperiment"))
    stopifnot("raw_counts" %in% assayNames(rse))
    stopifnot(is.logical(round))
    stopifnot(length(round) == 1)

    ## Check RSE details
    counts <- SummarizedExperiment::assay(rse, "raw_counts")
    scaleFactor <- compute_scale_factors(
        colData(rse),
        by = by,
        targetSize = targetSize,
        L = L,
        ...
    )

    scaleMat <- matrix(rep(scaleFactor, each = nrow(counts)),
        ncol = ncol(counts)
    )
    scaledCounts <- counts * scaleMat
    if (round) scaledCounts <- round(scaledCounts, 0)
    return(scaledCounts)
}



#' Compute count scaling factors
#'
#' This function computes the count scaling factors used by
#' `transform_counts()`. This function is similar to
#' `recount::scale_counts(factor_only = TRUE)`, but it is more general.
#'
#' @param by Either `auc` or `mapped_reads`. If set to `auc` it
#' will compute the scaling factor by the total coverage of the sample. That is,
#' the area under the curve (AUC) of the coverage. If set to `mapped_reads` it
#' will scale the counts by the number of mapped reads (in the QC annotation),
#' whether the library was paired-end or not, and the desired read length (`L`).
#' @param targetSize A `numeric(1)` specifying the target library size in number
#' of single end reads.
#' @param L A `integer(1)` specifying the target read length. It is only used
#' when `by = 'mapped_reads'` since it cancels out in the calculation when
#' using `by = 'auc'`.
#' @param auc A `character(1)` specifying the metadata column
#' name that contains the area under the coverage (AUC). Note that there are
#' several possible AUC columns provided in the sample metadata generated
#' by `create_rse()`.
#' @param mapped_reads A `character(1)` specifying the metadata column
#' name that contains the number of mapped reads.
#' @param paired_end A `logical()` vector specifying whether each
#' sample is paired-end or not.
#' @inheritParams is_paired_end
#'
#' @return A `numeric()` with the sample scale factors that are used by
#' `transform_counts()`.
#' @export
#' @importFrom SummarizedExperiment assayNames colData assays
#' @family count transformation functions
#'
#' @examples
#'
#' ## Download the metadata for SRP009615, a single-end study
#' SRP009615_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         file_locate_url(
#'             "SRP009615",
#'             "data_sources/sra",
#'         )
#'     )
#' )
#'
#' ## Compute the scaling factors
#' compute_scale_factors(SRP009615_meta, by = "auc")
#' compute_scale_factors(SRP009615_meta, by = "mapped_reads")
#'
#' ## Download the metadata for DRP000499, a paired-end study
#' DRP000499_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         file_locate_url(
#'             "DRP000499",
#'             "data_sources/sra",
#'         )
#'     )
#' )
#'
#' ## Compute the scaling factors
#' compute_scale_factors(DRP000499_meta, by = "auc")
#' compute_scale_factors(DRP000499_meta, by = "mapped_reads")
#' \dontrun{
#' ## You can compare the factors against those from recount::scale_counts()
#' ## from the recount2 project which used a different RNA-seq aligner
#' ## If needed, install recount, the R/Bioconductor package for recount2:
#' # BiocManager::install("recount")
#' recount2_factors <- recount::scale_counts(
#'     recount::rse_gene_SRP009615,
#'     by = "auc", factor_only = TRUE
#' )
#' recount3_factors <- compute_scale_factors(SRP009615_meta, by = "auc")
#' recount_factors <- data.frame(
#'     recount2 = recount2_factors[order(names(recount2_factors))],
#'     recount3 = recount3_factors[order(names(recount3_factors))]
#' )
#' plot(recount2 ~ recount3, data = recount_factors)
#' abline(a = 0, b = 1, col = "purple", lwd = 2, lty = 2)
#' }
#'
compute_scale_factors <- function(
    x,
    by = c("auc", "mapped_reads"),
    targetSize = 4e7,
    L = 100,
    auc = "recount_qc.bc_auc.all_reads_all_bases",
    avg_mapped_read_length = "recount_qc.star.average_mapped_length",
    mapped_reads = "recount_qc.star.all_mapped_reads", # mapped_reads = "recount_qc.bc_frag.count"
    paired_end = is_paired_end(x, avg_mapped_read_length)) {
    if (is(x, "RangedSummarizedExperiment")) x <- colData(x)
    by <- match.arg(by)

    ## Check inputs
    stopifnot(all(c(auc, avg_mapped_read_length, mapped_reads, "external_id") %in% colnames(x)))
    stopifnot(length(targetSize) == 1)
    stopifnot(is.numeric(targetSize) || is.integer(targetSize))
    stopifnot(length(L) == 1)
    stopifnot(is.numeric(L) || is.integer(L))

    if (by == "auc") {
        # L cancels out:
        # have to multiply by L to get the desired library size,
        # but then divide by L to take into account the read length since the
        # raw counts are the sum of base-level coverage.
        scaleFactor <- targetSize / x[[auc]]
    } else if (by == "mapped_reads") {
        scaleFactor <- targetSize * L * ifelse(paired_end, 2, 1) /
            (x[[mapped_reads]] * x[[avg_mapped_read_length]]^2)

        ## Compared to recount::scale_counts(),
        ## x[[mapped_reads]] is not double the number of fragments
        ## unlike
        ## colData(rse)$mapped_read_count
        ## in recount::scale_counts()
        ## Hence, no need to square (^2) the paired_end ifelse() statement
        # scaleFactor <- targetSize * L *
        #     ifelse(SummarizedExperiment::colData(rse)$paired_end, 2, 1)^2 /
        #     (SummarizedExperiment::colData(rse)$mapped_read_count *
        #         SummarizedExperiment::colData(rse)$avg_read_length^2)
    }

    ## Assign the sample names
    names(scaleFactor) <- x$external_id
    return(scaleFactor)
}

#' Guess whether the samples are paired end
#'
#' Based on two alignment metrics, this function guesses the samples are paired
#' end or not.
#'
#' @param x Either a
#' [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' created by `create_rse()` or the sample metadata created by
#' `read_metadata()`.
#' @param avg_read_length A `character(1)` specifying the metadata column
#' name that contains the average read length prior to aligning.
#' @param avg_mapped_read_length A `character(1)` specifying the metdata column
#' name that contains the average fragment length after aligning. This is
#' typically twice the average read length for paired-end reads.
#'
#' @return A `logical()` vector specifying whether each sample was likely
#' paired-end or not.
#' @export
#' @family count transformation functions
#'
#' @examples
#'
#' ## Download the metadata for SRP009615, a single-end study
#' SRP009615_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         file_locate_url(
#'             "SRP009615",
#'             "data_sources/sra",
#'         )
#'     )
#' )
#'
#' ## Are the samples paired end?
#' is_paired_end(SRP009615_meta)
#'
#' ## Download the metadata for DRP000499, a paired-end study
#' DRP000499_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         file_locate_url(
#'             "DRP000499",
#'             "data_sources/sra",
#'         )
#'     )
#' )
#' is_paired_end(DRP000499_meta)
is_paired_end <- function(x,
    avg_mapped_read_length = "recount_qc.star.average_mapped_length",
    avg_read_length = "recount_seq_qc.avg_len") {
    if (is(x, "RangedSummarizedExperiment")) x <- colData(x)
    stopifnot(all(c(avg_read_length, avg_mapped_read_length, "external_id") %in% colnames(x)))
    ratio <- round(x[[avg_mapped_read_length]] / x[[avg_read_length]], 0)
    if (!all(ratio %in% c(1, 2))) {
        warning(
            "is_paired_end(): Looks like some samples failed to align and will return NA.",
            call. = FALSE
        )
        ratio[!ratio %in% c(1, 2)] <- NA
    }
    res <- ratio == 2
    names(res) <- x$external_id
    return(res)
}

#' Compute read counts
#'
#' As described in the recount workflow, the counts provided by the recount2
#' project are base-pair counts. You can scale them using `transform_counts()`
#' or compute the read counts using the area under coverage information (AUC).
#'
#' This function is similar to
#' `recount::read_counts(use_paired_end = TRUE, round = TRUE)` but more general
#' and with a different name to avoid NAMESPACE conflicts. Note that the default
#' value of `round` is different than in `recount::read_counts()`. This
#' was done to match the default value of `round` in `transform_counts()`.
#'
#' @inheritParams transform_counts
#' @inheritParams is_paired_end
#'
#' @return A `matrix()` with the read counts. By default this function uses
#' the average read length to the QC annotation.
#' @export
#' @family count transformation functions
#'
#' @references
#' Collado-Torres L, Nellore A and Jaffe AE. recount workflow: Accessing over
#' 70,000 human RNA-seq samples with Bioconductor version 1; referees: 1
#' approved, 2 approved with reservations. F1000Research 2017, 6:1558
#' doi: 10.12688/f1000research.12223.1.
#'
#' @examples
#'
#' ## Create a RSE object at the gene level
#' rse_gene_SRP009615 <- create_rse(recount3_hub("SRP009615"))
#' colSums(compute_read_counts(rse_gene_SRP009615)) / 1e6
#'
#' ## Create a RSE object at the gene level
#' rse_gene_DRP000499 <- create_rse(recount3_hub("DRP000499"))
#' colSums(compute_read_counts(rse_gene_DRP000499)) / 1e6
#' \dontrun{
#' ## You can compare the read counts against those from recount::read_counts()
#' ## from the recount2 project which used a different RNA-seq aligner
#' ## If needed, install recount, the R/Bioconductor package for recount2:
#' # BiocManager::install("recount")
#' recount2_readsums <- colSums(assay(recount::read_counts(
#'     recount::rse_gene_SRP009615
#' ), "counts")) / 1e6
#' recount3_readsums <- colSums(compute_read_counts(rse_gene_SRP009615)) / 1e6
#' recount_readsums <- data.frame(
#'     recount2 = recount2_readsums[order(names(recount2_readsums))],
#'     recount3 = recount3_readsums[order(names(recount3_readsums))]
#' )
#' plot(recount2 ~ recount3, data = recount_readsums)
#' abline(a = 0, b = 1, col = "purple", lwd = 2, lty = 2)
#'
#' ## Repeat for DRP000499, a paired-end study
#' recount::download_study("DRP000499", outdir = tempdir())
#' load(file.path(tempdir(), "rse_gene.Rdata"), verbose = TRUE)
#'
#' recount2_readsums <- colSums(assay(recount::read_counts(
#'     rse_gene
#' ), "counts")) / 1e6
#' recount3_readsums <- colSums(compute_read_counts(rse_gene_DRP000499)) / 1e6
#' recount_readsums <- data.frame(
#'     recount2 = recount2_readsums[order(names(recount2_readsums))],
#'     recount3 = recount3_readsums[order(names(recount3_readsums))]
#' )
#' plot(recount2 ~ recount3, data = recount_readsums)
#' abline(a = 0, b = 1, col = "purple", lwd = 2, lty = 2)
#' }
#'
compute_read_counts <- function(rse, round = TRUE, avg_mapped_read_length = "recount_qc.star.average_mapped_length") {
    stopifnot(is(rse, "RangedSummarizedExperiment"))
    stopifnot("raw_counts" %in% assayNames(rse))
    stopifnot(avg_mapped_read_length %in% colnames(colData(rse)))


    counts <- t(t(assays(rse)$raw_counts) / colData(rse)[[avg_mapped_read_length]])

    if (round) counts <- round(counts, 0)

    return(counts)
}
