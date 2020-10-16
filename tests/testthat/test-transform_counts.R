test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("transforming counts works", {
    rse_DRP002835 <-
        create_rse(
            data.frame(
                project = "DRP002835",
                organism = "human",
                project_home = "data_sources/sra"
            ),
            annotation = "ercc",
            bfc = test_bfc
        )
    expect_error(transform_counts(tempdir(), "RangedSummarizedExperiment"))
    expect_error(
        transform_counts(
            SummarizedExperiment::SummarizedExperiment(rowData = GenomicRanges::GRanges())
        ),
        "raw_counts"
    )
    expect_error(transform_counts(rse_DRP002835, round = 1), "logical")
    expect_error(transform_counts(rse_DRP002835, round = c(TRUE, FALSE)), "== 1 is not TRUE")
    expect_equivalent(colSums(transform_counts(rse_DRP002835)), c(1, 3))
    expect_equivalent(colSums(transform_counts(rse_DRP002835, by = "mapped_reads")), c(3, 9))
})
