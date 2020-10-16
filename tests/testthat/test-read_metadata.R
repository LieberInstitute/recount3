test_bfc <- recount3_cache(system.file("inst",
    "test_files",
    package = "recount3",
    mustWork = TRUE))

url_DRP002835_meta <- locate_url("DRP002835",
    "data_sources/sra")

test_that("Reading metadata files works", {
    meta <-
        read_metadata(file_retrieve(url_DRP002835_meta, bfc = test_bfc))
    expect_s3_class(meta, "data.frame")
    expect_equal(nrow(meta), 2)
    expect_equal(ncol(meta), 174)
})