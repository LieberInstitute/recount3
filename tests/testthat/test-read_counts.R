test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Reading counts works", {
    cts <- read_counts(file_retrieve(
        locate_url(
            "DRP002835",
            "data_sources/sra",
            type = "gene",
            annotation = "ercc"
        ),
        bfc = test_bfc
    ))
    expect_is(cts, "matrix")
    expect_equal(dim(cts), c(92, 2))
})
