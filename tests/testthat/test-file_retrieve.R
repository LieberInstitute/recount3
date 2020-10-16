test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)
test_url <-
    "http://idies.jhu.edu/recount3/data/human/data_sources/sra/metadata/35/DRP002835/sra.recount_project.DRP002835.MD.gz"

test_that("multiplication works", {
    expect_equivalent(
        file_retrieve(test_url, test_bfc),
        BiocFileCache::bfcrpath(test_bfc, test_url)
    )

    expect_equal(file_retrieve(tempdir()), tempdir())
    expect_error(
        file_retrieve(test_url, bfc = tempdir()),
        "should be a BiocFileCache::BiocFileCache"
    )
    expect_warning(
        file_retrieve("http://idies.jhu.edu/recount4"),
        "does not exist or is not available"
    )
})
