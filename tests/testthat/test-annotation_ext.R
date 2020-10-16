test_that("Default annotation extentions by organism", {
    expect_equal(annotation_ext("human"), "G026")
    expect_equal(annotation_ext("mouse"), "M023")
})
