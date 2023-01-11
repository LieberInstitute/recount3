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
    expect_equivalent(
        locate_url("SKIN",
            "data_sources/gtex",
            "bw",
            sample = "GTEX-1117F-2926-SM-5GZYI.1",
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/gtex/base_sums/IN/SKIN/YI/gtex.base_sums.SKIN_GTEX-1117F-2926-SM-5GZYI.1.ALL.bw"
    )
    expect_equivalent(
        locate_url("SKIN",
            "data_sources/gtex",
            "bw",
            sample = c("GTEX-1117F-2926-SM-5GZYI.1", "GTEX-111CU-1126-SM-5EGIM.1"),
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        c(
            "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/gtex/base_sums/IN/SKIN/YI/gtex.base_sums.SKIN_GTEX-1117F-2926-SM-5GZYI.1.ALL.bw",
            "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/gtex/base_sums/IN/SKIN/IM/gtex.base_sums.SKIN_GTEX-111CU-1126-SM-5EGIM.1.ALL.bw"
        )
    )
    expect_equivalent(
        locate_url("SKIN",
            "data_sources/gtex",
            "bw",
            sample = c("GTEX-1192X-0008-SM-5Q5B7.1", "GTEX-WVLH-0008-SM-4MVPD.1"),
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        c(
            "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/gtex/base_sums/IN/SKIN/B7/gtex.base_sums.SKIN_GTEX-1192X-0008-SM-5Q5B7.1.ALL.bw",
            "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/gtex/base_sums/IN/SKIN/PD/gtex.base_sums.SKIN_GTEX-WVLH-0008-SM-4MVPD.1.ALL.bw"
        )
    )
    gtex_samples <- subset(
        available_samples(),
        project_home == "data_sources/gtex"
    )
    expect_true(all(
        substr(
            gtex_samples$external_id,
            nchar(gtex_samples$external_id) - 1,
            nchar(gtex_samples$external_id)
        ) %in% c(".1", ".2", ".3")
    ))
    expect_equivalent(
        locate_url("ACC",
            "data_sources/tcga",
            "bw",
            sample = "193ccbe6-104f-49b4-bdb2-c82ee36fdaad",
            recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release"
        ),
        "https://recount-opendata.s3.amazonaws.com/recount3/release/human/data_sources/tcga/base_sums/CC/ACC/AD/tcga.base_sums.ACC_193ccbe6-104f-49b4-bdb2-c82ee36fdaad.ALL.bw"
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
