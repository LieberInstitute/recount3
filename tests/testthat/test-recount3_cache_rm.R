temp_bfc_rm <- recount3_cache(file.path(tempdir(), "cache_rm_test"))
test_url <- "http://idies.jhu.edu/recount3/data/human/data_sources/sra/metadata/35/DRP002835/sra.recount_project.DRP002835.MD.gz"

BiocFileCache::bfcrpath(
    temp_bfc_rm,
    test_url
)

test_that("Wiping out the cache works", {
    recount3_cache_rm(temp_bfc_rm)
    expect_equal(recount3_cache_files(temp_bfc_rm), character())
})
