#' Create UCSC track hub for BigWig files
#'
#' This function creates a directory with the configuration files required for
#' creating a UCSC track hub for the BigWig files from a given project. These
#' files can then be hosted on GitHub or elsewhere. For more details about
#' UCSC track hubs, check
#' <https://genome.ucsc.edu/goldenpath/help/hgTrackHubHelp.html>.
#'
#' See
#' <https://github.com/LieberInstitute/recount3-docs/blob/master/UCSC_hubs/create_hubs.R>
#' for an example of how this function was used.
#'
#' @param x A `data.frame` created with `available_samples()` that has typically
#' been subset to a specific project ID from a given organism.
#' @param output_dir A `character(1)` with the output directory.
#' @param hub_name A `character(1)` with the UCSC track hub name you want
#' to display.
#' @param email A `character(1)` with the email used for the UCSC track hub.
#' @param show_max An `integer(1)` with the number of BigWig tracks to show
#' by default in the UCSC track hub. We recommend a single digit number.
#' @param hub_short_label A `character(1)` with the UCSC track hub short
#' label.
#' @param hub_long_label A `character(1)` with the UCSC track hub long label.
#' @param hub_description_url A `character(1)` with the URL to an `html` file
#' that will describe the UCSC track hub to users.
#' @inheritParams locate_url
#'
#' @return A directory at `output_dir` with the files needed for a UCSC
#' track hub.
#' @export
#'
#' @examples
#'
#' ## Find all the mouse samples available from recount3
#' mouse_samples <- available_samples("mouse")
#'
#' ## Subset to project DRP001299
#' info_DRP001299 <- subset(mouse_samples, project == "DRP001299")
#'
#' hub_dir <- create_hub(info_DRP001299)
#'
#' ## List the files created by create_hub()
#' hub_files <- list.files(hub_dir, full.names = TRUE, recursive = TRUE)
#' hub_files
#'
#' ## Check the files contents
#' sapply(hub_files, function(x) {
#'     cat(paste(readLines(x), collapse = "\n"))
#' })
#'
#' ## You can also check the file contents for this example project at
#' ## https://github.com/LieberInstitute/recount3-docs/tree/master/UCSC_hubs/mouse/sra_DRP001299
#' ## or test it out on UCSC directly through the following URL:
#' ## https://genome.ucsc.edu/cgi-bin/hgTracks?db=mm10&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=chr1&hubUrl=https://raw.githubusercontent.com/LieberInstitute/recount3-docs/master/UCSC_hubs/mouse/sra_DRP001299/hub.txt
create_hub <-
    function(x,
    output_dir = file.path(tempdir(), x$project[1]),
    hub_name = "recount3",
    email = "someone@somewhere",
    show_max = 5,
    hub_short_label = "recount3 coverage",
    hub_long_label = "recount3 summaries and queries for large-scaleRNA-seq expression and splicing",
    hub_description_url = "https://rna.recount.bio/index.html",
    recount3_url = getOption("recount3_url", "http://duffel.rail.bio/recount3")) {
        stopifnot(is(x, "data.frame"))
        stopifnot(all(
            c(
                "external_id",
                "project",
                "organism",
                "file_source",
                "project_home"
            ) %in% colnames(x)
        ))
        stopifnot(length(unique(x$organism)) == 1)

        if (grepl(" ", hub_name)) {
            stop(
                "hub_name should be a single word starting with a letter as stated at http://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html.",
                call. = FALSE
            )
        }
        if (nchar(hub_short_label) > 17) {
            warning(
                "The recommended maximum character length for the short label is 17 at http://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html.",
                call. = FALSE
            )
        }
        if (nchar(hub_long_label) > 80) {
            warning(
                "The recommended maximum character length for the long label is 80 at http://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html.",
                call. = FALSE
            )
        }

        dir.create(output_dir, recursive = TRUE)

        content_hub <-
            paste0(
                "hub ",
                hub_name,
                "\nshortLabel ",
                hub_short_label,
                "\nlongLabel ",
                hub_long_label,
                "\ngenomesFile genomes.txt\nemail ",
                email,
                "\ndescriptionUrl ",
                hub_description_url,
                "\n"
            )
        writeLines(content_hub, file.path(output_dir, "hub.txt"))

        org <- ifelse(unique(x$organism) == "human", "hg38", "mm10")
        dir.create(file.path(output_dir, org))
        content_genomes <-
            paste0("genome ", org, "\ntrackDb ", org, "/trackDb.txt\n")
        writeLines(content_genomes, file.path(output_dir, "genomes.txt"))

        by_proj <- split(x, paste0(x$project, "-", x$organism))

        x_bw <- do.call(rbind, lapply(by_proj, function(proj) {
            cbind(
                proj,
                bigWig = locate_url(
                    project = proj$project[1],
                    project_home = proj$project_home[1],
                    type = "bw",
                    organism = proj$organism[1],
                    sample = x$external_id,
                    recount3_url = recount3_url
                )
            )
        }))

        content_trackDb <-
            paste0(
                "track ",
                x_bw$external_id,
                "\nbigDataUrl ",
                x_bw$bigWig,
                "\nshortLabel ",
                x_bw$external_id,
                "\nlongLabel recount3 coverage bigWig for external id ",
                x_bw$external_id,
                " project ",
                x_bw$project,
                " file source ",
                x_bw$file_source,
                "\ntype bigWig\nvisibility ",
                ifelse(seq_len(nrow(x_bw)) <= show_max, "show", "hide"),
                "\nautoScale on\n"
            )
        writeLines(
            content_trackDb,
            file.path(output_dir, org, "trackDb.txt")
        )

        return(output_dir)
    }
