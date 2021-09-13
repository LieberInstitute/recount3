test_that("creating a UCSC hub", {

    ## Find all the mouse samples available from recount3
    mouse_samples <- available_samples("mouse")
    ## Subset to project DRP001299
    info_DRP001299 <- subset(mouse_samples, project == "DRP001299")
    hub_dir <- create_hub(info_DRP001299)
    ## List the files created by create_hub()
    hub_files <- list.files(hub_dir, recursive = TRUE)

    expect_equal(hub_files, c("genomes.txt", "hub.txt", "mm10/trackDb.txt"))

    hub_files_full <- list.files(hub_dir, full.names = TRUE, recursive = TRUE)

    expect_equal(
        readLines(hub_files_full[1]),
        c("genome mm10", "trackDb mm10/trackDb.txt", "")
    )
})
