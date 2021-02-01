test_bfc <- recount3_cache(
    system.file(
        "test_files",
        package = "recount3",
        mustWork = TRUE
    )
)

test_that("Creating an RSE works (ercc) - user friendly function", {
    rse_DRP002835_test_userfriendly <-
        create_rse(
            data.frame(
                project = "DRP002835",
                organism = "human",
                project_home = "data_sources/sra"
            ),
            annotation = "ercc",
            bfc = test_bfc
        )
    rse_DRP002835_test <-
        create_rse_manual(
            project = "DRP002835",
            annotation = "ercc",
            bfc = test_bfc
        )

    expect_equivalent(rse_DRP002835_test_userfriendly, rse_DRP002835_test)
})


# test_that("Check non-standard recount3_url", {
#     hp <-
#         available_projects(recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3test", available_homes = "data_sources/sra")
#     proj_info <- subset(hp, project == "DRP004088" & project_type == "data_sources")
#     rse_gene_DRP004088 <- create_rse(proj_info, recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3test")
# })
