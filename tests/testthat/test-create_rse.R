test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Creating an RSE works (ercc) - user friendly function", {
    rse_DRP002835_test_userfriendly <-
        create_rse(
            data.frame(
                project = "DRP002835",
                organism = "human",
                project_home = "data_sources/sra"
            ),
            annotation = "ercc",
            bfc = test_bfc
        )
    rse_DRP002835_test <-
        create_rse_manual(project = "DRP002835",
            annotation = "ercc",
            bfc = test_bfc)

    expect_equivalent(rse_DRP002835_test_userfriendly, rse_DRP002835_test)
})
