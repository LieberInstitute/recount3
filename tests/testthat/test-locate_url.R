test_that("Locating URLs works", {
    url_jxn <- locate_url(
        "SRP009615",
        "data_sources/sra",
        "jxn"
    )
    expect_equal(length(url_jxn), 3)
    expect_equal(
        basename(url_jxn),
        paste0("sra.junctions.SRP009615.ALL.", c("MM", "RR", "ID"), ".gz")
    )
    url_exon <- locate_url(
        "SRP009615",
        "data_sources/sra",
        "exon"
    )
    expect_equal(length(url_exon), 1)
    expect_equal(basename(url_exon), "sra.exon_sums.SRP009615.G026.gz")
    url_bw <- locate_url("DRR028129",
        "data_sources/sra",
        "bw",
        sample = "DRR028129"
    )
    expect_equal(length(url_bw), 1)
    expect_equal(
        basename(url_bw),
        "sra.base_sums.DRR028129_DRR028129.ALL.bw"
    )
    expect_error(
        locate_url(
            "DRR028129",
            "data_sources/sra",
            "bw"
        ),
        "You need to specify the 'sample' when type = 'bw'"
    )
    expect_equivalent(
        locate_url(
            "ERP110066",
            "collections/geuvadis_smartseq",
            "gene",
            recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
        ),
        "http://snaptron.cs.jhu.edu/data/temp/recount3/human/data_sources/sra/gene_sums/66/ERP110066/sra.gene_sums.ERP110066.G026.gz"
    )
    expect_error(
        locate_url(
            "random",
            "collections/geuvadis_smartseq",
            "gene",
            recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
        ),
        "The 'project' is not part of this collection"
    )
})
