#' Find available project home options
#'
#' @inheritParams file_locate_url
#'
#' @return A `character()` vector with the available `project_home` options.
#' @export
#' @importFrom XML readHTMLTable
#' @importFrom BiocFileCache bfcrpath
#'
#' @examples
#'
#' project_home_available("metadata")
project_home_available <-
    function(type = c("metadata", "gene", "exon", "jxn", "bw"),
    organism = c("human", "mouse"),
    recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3",
    bfc = BiocFileCache::BiocFileCache()) {
        type <- match.arg(type)
        organism <- match.arg(organism)

        ## Define the base directories
        base_dir <- switch(
            type,
            metadata = "metadata",
            gene = "gene_sums",
            exon = "exon_sums",
            jxn = "jxn",
            bw = "base_sums"
        )

        ## Build the query URL
        url <- file.path(recount3_url, organism, base_dir)

        ## Cache the url so it's only used once
        local_url <- BiocFileCache::bfcrpath(bfc, url)

        ## Now read the HTML
        list_files <- XML::readHTMLTable(local_url)[[1]]$Name

        ## Find the available options
        ## ## From https://stackoverflow.com/questions/12930933/retrieve-the-list-of-files-from-a-url
        available <- list_files[!is.na(list_files)]
        available <- gsub("/", "", available)
        available <- available[which(available != "Parent Directory")]
        return(available)
    }
