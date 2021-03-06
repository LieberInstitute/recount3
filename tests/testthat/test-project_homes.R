test_that("Default project homes by organism", {
    expect_equal(
        project_homes("human"),
        c(
            "data_sources/sra",
            "data_sources/gtex",
            "data_sources/tcga"
        )
    )
    expect_equal(project_homes("mouse"), "data_sources/sra")
    expect_error(
        project_homes(recount3_url = file.path(tempdir(), "random")),
        "is not a valid supported URL"
    )
    expect_equal(project_homes(recount3_url = tempdir()), character(0))
})
