#' Read a metadata file
#'
#' This function reads in a `recount3` metadata file into R. You can first
#' locate the file using `file_locate_url()` then download it to your computer
#' using `file_retrieve()`.
#'
#' @param metadata_file A `character(1)` with the local path to a `recount3`
#' metadata file.
#'
#' @return A `data.frame()` with all lower case column names for the sample
#' metadata.
#' @export
#' @importFrom utils read.delim
#'
#' @family internal functions for accessing the recount3 data
#' @examples
#'
#' ## Download the metadata file for project ERP110066
#' url_ERP110066_meta <- file_locate_url("ERP110066", "data_sources/sra")
#' local_ERP110066_meta <- file_retrieve(url = url_ERP110066_meta)
#'
#' ## Read the metadata
#' ERP110066_meta <- read_metadata(local_ERP110066_meta)
#' head(ERP110066_meta)
#'
#' ## Locate and read the GTEx bladder metadata
#' gtex_bladder_meta <- read_metadata(
#'     file_retrieve(
#'         file_locate_url("BLADDER", "data_sources/gtex")
#'     )
#' )
#'
#' head(gtex_bladder_meta)
read_metadata <- function(metadata_file) {

    ## Check the inputs
    stopifnot(
        "'metadata_file' should be a character" = is.character(metadata_file),
        "'metadata_file' should be a single value" = length(metadata_file) == 1,
        "'metadata_file' should point a local file that exists" = file.exists(metadata_file)
    )

    ## Read in the metadata
    meta <- utils::read.delim(metadata_file, sep = "\t", check.names = FALSE)

    ## Make all column names consistently lower case
    colnames(meta) <- tolower(colnames(meta))
    return(meta)
}
