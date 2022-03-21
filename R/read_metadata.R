#' Read the metadata files
#'
#' This function reads in the `recount3` metadata files into R. You can first
#' locate the files using `locate_url()` then download it to your computer
#' using `file_retrieve()`.
#'
#' @param metadata_files A `character()` with the local path to `recount3`
#' metadata files.
#'
#' @return A `data.frame()` with all lower case column names for the sample
#' metadata.
#' @export
#' @importFrom utils read.delim
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the metadata files for project ERP110066
#' url_ERP110066_meta <- locate_url(
#'     "ERP110066",
#'     "data_sources/sra"
#' )
#' local_ERP110066_meta <- file_retrieve(
#'     url = url_ERP110066_meta
#' )
#'
#' ## Read the metadata
#' ERP110066_meta <- read_metadata(local_ERP110066_meta)
#' dim(ERP110066_meta)
#' colnames(ERP110066_meta)
#'
#' ## Read the metadata files for a project in a collection
#' ## Note: using the test files since I can't access collections right now
#' ## for this collection
#' ERP110066_collection_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         locate_url(
#'             "ERP110066",
#'             "collections/geuvadis_smartseq",
#'             recount3_url = "http://snaptron.cs.jhu.edu/data/temp/recount3"
#'         )
#'     )
#' )
#' dim(ERP110066_collection_meta)
#' ## New columns for this collection
#' colnames(ERP110066_collection_meta)[!colnames(ERP110066_collection_meta) %in% colnames(ERP110066_meta)]
#'
#' ## Read the metadata for a mouse project
#' DRP002367_meta <- read_metadata(
#'     metadata_files = file_retrieve(
#'         locate_url("DRP002367", "data_sources/sra", organism = "mouse")
#'     )
#' )
#' dim(DRP002367_meta)
#'
#' ## Locate and read the GTEx bladder metadata
#' gtex_bladder_meta <- read_metadata(
#'     file_retrieve(
#'         locate_url("BLADDER", "data_sources/gtex")
#'     )
#' )
#'
#' dim(gtex_bladder_meta)
#' colnames(gtex_bladder_meta)
read_metadata <- function(metadata_files) {
    metadata_files <- metadata_files[!is.na(metadata_files)]
    if (length(metadata_files) == 0) {
        stop("The are no metadata files to work with.", call. = FALSE)
    }

    ## Check the inputs
    stopifnot(
        "'metadata_files' should be a character" =
            is.character(metadata_files),
        "'metadata_files' should point a local file that exists" =
            all(file.exists(metadata_files)),
        "'metadata_files' should be named" =
            length(names(metadata_files)) == length(metadata_files)
    )

    ## Read in the metadata files
    meta_list <- lapply(
        metadata_files,
        utils::read.delim,
        sep = "\t",
        check.names = FALSE,
        quote = "",
        comment.char = ""
    )

    meta_rows <- vapply(meta_list, nrow, integer(1)) > 0
    if (any(!meta_rows)) {
        warning("The following metadata files are empty and will be dropped: ",
            paste(names(meta_rows)[!meta_rows], collapse = ", "),
            call. = FALSE
        )
    }
    meta_list <- meta_list[meta_rows]

    ## Key columns
    keys <- c("rail_id", "external_id", "study")

    ## Make column names consistent
    for (i in seq_along(meta_list)) {
        ## Make all column names consistently lower case
        colnames(meta_list[[i]]) <- tolower(colnames(meta_list[[i]]))

        ## Add support for older recount3 files
        if ("study_acc" %in% colnames(meta_list[[i]]) && !"study" %in% colnames(meta_list[[i]])) {
            warning("Replacing study_acc by study in ", names(meta_list)[i], call. = FALSE)
            colnames(meta_list[[i]])[colnames(meta_list[[i]]) == "study_acc"] <- "study"
        }
        if ("run_acc" %in% colnames(meta_list[[i]]) && !"external_id" %in% colnames(meta_list[[i]])) {
            warning("Replacing run_acc by external_id in ", names(meta_list)[i], call. = FALSE)
            colnames(meta_list[[i]])[colnames(meta_list[[i]]) == "run_acc"] <- "external_id"
        }
    }

    ## Merge the metadata files
    meta <- Reduce(function(...) merge(..., by = keys), meta_list)

    ## Add the origin to the colnames
    origin <- vapply(
        strsplit(names(meta_list), "\\."),
        "[",
        character(1),
        2
    )
    origin_n <- vapply(meta_list, ncol, integer(1)) - length(keys)
    stopifnot(all(origin_n >= 0))
    colnames(meta) <- paste0(
        rep(
            c("", paste0(origin, ".")),
            c(length(keys), origin_n)
        ),
        colnames(meta)
    )
    return(meta)
}
