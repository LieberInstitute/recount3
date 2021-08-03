test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

url_DRP002835_meta <- locate_url(
    "DRP002835",
    "data_sources/sra"
)

test_that("Reading metadata files works", {
    meta <-
        read_metadata(file_retrieve(url_DRP002835_meta, bfc = test_bfc))
    expect_s3_class(meta, "data.frame")
    expect_equal(nrow(meta), 2)
    expect_equal(ncol(meta), 174)
    expect_error(read_metadata(NULL), "The are no metadata files to work with")
})

## Some files have issues, like the one reported at:
## https://github.com/LieberInstitute/recount3/issues/5
test_that("Incomplete metadata", {
    url <- locate_url(project = "SRP103067", project_home = "data_sources/sra", type = "metadata")
    metadata_files <- file_retrieve(url)
    expect_warning(read_metadata(metadata_files), "The following metadata files are empty and will be dropped")
})
