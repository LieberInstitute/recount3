test_that("number of available projects by organism works", {
    expect_equal(dim(available_projects("human")), c(8742, 6))
    expect_equal(dim(available_projects("mouse")), c(10088, 6))
    ## Test https://idies.jhu.edu/recount3/data URLs
    expect_equal(
        dim(available_projects(
            "human",
            recount3_url = "https://idies.jhu.edu/recount3/data"
        )),
        c(8742, 6)
    )
    expect_equal(
        dim(available_projects(
            "mouse",
            recount3_url = "https://idies.jhu.edu/recount3/data"
        )),
        c(10088, 6)
    )
    ## Note that https://idies.jhu.edu/recount3/data actually redirects to
    ## https://data.idies.jhu.edu/recount3/data/
    expect_equal(
        dim(available_projects(
            "human",
            recount3_url = "https://data.idies.jhu.edu/recount3/data/"
        )),
        c(8742, 6)
    )
})
