test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Locating cached files", {
    cached_files <- recount3_cache_files(test_bfc)
    expect_equal(length(cached_files), 9)
    expect_equal(sum(grepl("metadata", cached_files)), 5)
    expect_equal(sum(grepl("DRP002835", cached_files)), 7)
})
