#' Read the metadata files
#'
#' This function reads in the `recount3` metadata files into R. You can first
#' locate the files using `file_locate_url()` then download it to your computer
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
#' url_ERP110066_meta <- file_locate_url("ERP110066", "data_sources/sra")
#' local_ERP110066_meta <- file_retrieve(url = url_ERP110066_meta)
#'
#' ## Read the metadata
#' ERP110066_meta <- read_metadata(local_ERP110066_meta)
#' head(ERP110066_meta)
#' \dontrun{
#' ## Locate and read the GTEx bladder metadata
#' gtex_bladder_meta <- read_metadata(
#'     file_retrieve(
#'         file_locate_url("BLADDER", "data_sources/gtex")
#'     )
#' )
#'
#' head(gtex_bladder_meta)
#' }
read_metadata <- function(metadata_files) {

    ## Check the inputs
    stopifnot(
        "'metadata_files' should be a character" = is.character(metadata_files),
        "'metadata_files' should point a local file that exists" = all(file.exists(metadata_files))
    )

    ## Read in the metadata files
    meta_list <- lapply(
        metadata_files,
        utils::read.delim,
        sep = "\t",
        check.names = FALSE
    )

    ## Merge the metadata files
    for (i in seq_along(meta_list)) {
        ## Make all column names consistently lower case
        colnames(meta_list[[i]]) <- tolower(colnames(meta_list[[i]]))

        if (i == 1) {
            ## Initialize
            meta <- meta_list[[i]]
        } else {
            ## Then merge one by one
            merge(meta, meta_list[[i]])
        }
    }
    return(meta)
}
