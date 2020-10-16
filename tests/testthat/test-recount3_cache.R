test_bfc <- recount3_cache(
    system.file(
        "inst",
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Setting up the cache", {
    expect_s4_class(test_bfc, "BiocFileCache")
})
