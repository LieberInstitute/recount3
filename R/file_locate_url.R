#' Title
#'
#' @param project A `character(1)`
#' @param project_home
#' @param type
#' @param sample
#' @param organism
#' @param recount3
#'
#' @return
#' @export
#'
#' @examples
#'
#' file_locate_url("ERP001942", "sra", "metadata", "human")
#'
#' file_locate_url("ERP001942", "sra", "bw", "human", "ERR204900")
file_locate_url <-
    function(project,
    project_home = project_home_available(
        type = type,
        organism = organism,
        recount3_url = recount3_url
    ),
    type = c("metadata", "gene", "exon", "jxn", "bw"),
    organism = c("human", "mouse"),
    sample = NULL,
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3") {
        type <- match.arg(type)
        organism <- match.arg(organism)
        project_home <- match.arg(project_home)

        ## Define the base directories
        base_dir <- switch(
            type,
            metadata = "metadata",
            gene = "gene_sums",
            exon = "exon_sums",
            jxn = "jxn",
            bw = "base_sums"
        )

        ## Define the file extensions
        file_ext <- switch(
            type,
            metadata = ".md.tsv.gz",
            gene = ".gz",
            exon = ".gz",
            jxn = ".something_todo",
            bw = ".bw"
        )

        ## Check that sample exists when type == 'bw'
        if (type == "bw") {
            if (is.null(sample)) {
                stop("You need to specify the 'sample' when type = 'bw'.",
                    call. = FALSE
                )
            }
        } else if (type == "jxn") {
            stop("Currently type = 'jxn' is not supported", call. = FALSE)
        }

        ## Construct the url
        if (type == "bw") {
            url <-
                file.path(
                    recount3_url,
                    organism,
                    base_dir,
                    project_home,
                    substr(project, nchar(project) - 1, nchar(project)),
                    project,
                    paste0("ALL.", sample, file_ext)
                )
        } else {
            url <-
                file.path(
                    recount3_url,
                    organism,
                    base_dir,
                    project_home,
                    substr(project, nchar(project) - 1, nchar(project)),
                    project,
                    paste0(project, file_ext)
                )
        }
        return(url)
    }
