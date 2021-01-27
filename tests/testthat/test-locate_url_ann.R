test_that("Default annotation URLs by organism", {
    expect_equivalent(
        locate_url_ann(
            organism = "human",
            recount3_url = "http://idies.jhu.edu/recount3/data"
        ),
        "http://idies.jhu.edu/recount3/data/human/annotations/gene_sums/human.gene_sums.G026.gtf.gz"
    )
    expect_equivalent(
        locate_url_ann(
            organism = "mouse",
            recount3_url = "http://idies.jhu.edu/recount3/data"
        ),
        "http://idies.jhu.edu/recount3/data/mouse/annotations/gene_sums/mouse.gene_sums.M023.gtf.gz"
    )
})
