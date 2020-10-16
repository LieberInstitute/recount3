test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Reading counts works", {
    cts_file <- file_retrieve(
        locate_url(
            "DRP002835",
            "data_sources/sra",
            type = "gene",
            annotation = "ercc"
        ),
        bfc = test_bfc
    )
    cts <- read_counts(cts_file)
    expect_is(cts, "matrix")
    expect_equal(dim(cts), c(92, 2))
    expect_equal(dim(read_counts(cts_file, samples = colnames(cts)[1])), c(92, 1))
    expect_error(
        read_counts(cts_file, samples = "random"),
        "Invalid sample names are: 'random'"
    )
})
