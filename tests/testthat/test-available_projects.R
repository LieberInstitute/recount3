test_that("number of available projects by organism works", {
    expect_equal(dim(available_projects("human")), c(8742, 5))
    expect_equal(dim(available_projects("mouse")), c(10088, 5))
})
