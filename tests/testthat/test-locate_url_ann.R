test_that("Default annotation URLs by organism", {
    expect_equivalent(
        locate_url_ann(
            organism = "human",
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        "https://recount-opendata.s3.amazonaws.com/recount3/release/human/annotations/gene_sums/human.gene_sums.G026.gtf.gz"
    )
    expect_equivalent(
        locate_url_ann(
            organism = "mouse",
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        "https://recount-opendata.s3.amazonaws.com/recount3/release/mouse/annotations/gene_sums/mouse.gene_sums.M023.gtf.gz"
    )
})
