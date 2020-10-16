temp_bfc <- recount3_cache(file.path(tempdir(), "recount3_cache_rm"))
test_url <- "http://idies.jhu.edu/recount3/data/human/data_sources/sra/metadata/35/DRP002835/sra.recount_project.DRP002835.MD.gz"

BiocFileCache::bfcrpath(
    temp_bfc,
    test_url
)

test_that("Wiping out the cache works", {
    expect_equal(
        recount3_cache_files(temp_bfc),
        test_url
    )
    recount3_cache_rm(temp_bfc)
    expect_equal(recount3_cache_files(temp_bfc), character())
})
