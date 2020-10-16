test_that("Annotation options by organism", {
    expect_equal(
        annotation_options("human"),
        c(
            "gencode_v26",
            "gencode_v29",
            "fantom6_cat",
            "refseq",
            "ercc",
            "sirv"
        )
    )
    expect_equal(annotation_options("mouse"), "gencode_v23")
})
