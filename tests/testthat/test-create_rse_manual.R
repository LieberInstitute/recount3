temp_bfc <- recount3_cache(tempdir())
test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Creating an RSE works (ercc)", {
    rse_DRP002835_temp <-
        create_rse_manual(project = "DRP002835",
            annotation = "ercc",
            bfc = temp_bfc)
    rse_DRP002835_test <-
        create_rse_manual(project = "DRP002835",
            annotation = "ercc",
            bfc = test_bfc)

    expect_equivalent(rse_DRP002835_temp, rse_DRP002835_test)
    expect_s4_class(rse_DRP002835_test, "RangedSummarizedExperiment")

    rse_DRP002835_temp_exon <-
        create_rse_manual(
            project = "DRP002835",
            annotation = "ercc",
            bfc = test_bfc,
            type = "exon"
        )
    expect_equal(colData(rse_DRP002835_temp_exon),
        colData(rse_DRP002835_temp))
    expect_equal(dim(rse_DRP002835_temp_exon), dim(rse_DRP002835_temp))
})
