temp_bfc_rm <- recount3_cache(file.path(tempdir(), "cache_rm_test"))
test_url <- "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/sra/metadata/35/DRP002835/sra.recount_project.DRP002835.MD.gz"

BiocFileCache::bfcrpath(
    temp_bfc_rm,
    test_url
)

test_that("Wiping out the cache works", {
    recount3_cache_rm(temp_bfc_rm)
    expect_equal(recount3_cache_files(temp_bfc_rm), character())
    expect_error(recount3_cache_rm(
        tempdir(),
        "should be a BiocFileCache::BiocFileCache object"
    ))
})
