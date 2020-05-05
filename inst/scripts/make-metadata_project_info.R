library("here")
library("sessioninfo")

## Locate the project info
proj_files <-
    dir(here::here("inst", "data"),
        "_project_info_all.RData",
        full.names = TRUE
    )
names(proj_files) <-
    gsub(
        "_project_info_all\\.RData",
        "",
        dir(here::here("inst", "data"), "_project_info_all.RData")
    )

## Update this query date
query_date <- "2020-05-05"

## Subset to the files newer or equal to the query_date
proj_files <- proj_files[as.Date(names(proj_files)) >= query_date]

## Read the data
proj_info <- do.call(rbind, lapply(proj_files, function(x) {
    load(x, verbose = TRUE)
    project_info_all
}))

## metadata options
outdir <- "recount3_files"
pkgname <- "recount3"

## Construct the ExperimentHub metadata
meta <- data.frame(
    Title = paste(
        "recount3 project information for project",
        proj_info$project,
        "from data source",
        basename(proj_info$project_home)
    ),
    Description = paste(
        "This entry contains a data.frame with the required information for",
        "running the user-friendly recount3::create_rse() and other functions",
        "for accessing the uniformly processed data from the recount3 project.",
        "This file is specifically tailored for the recount3 Bioconductor",
        "package. Please check the recount3 vignette for more information on
        how to use this file."
    ),
    BiocVersion = "3.11",
    Genome = ifelse(proj_info$organism == "human", "hg38", "mm10"),
    SourceType = "RData",
    SourceUrl = "https://bioconductor.org/packages/recount3",
    SourceVersion = format.Date(as.Date(query_date), "%b %d %Y"),
    Species = ifelse(proj_info$organism == "human", "Homo sapiens", "Mus musculus"),
    TaxonomyId = ifelse(proj_info$organism == "human", 9606, 10090),
    Coordinate_1_based = TRUE,
    DataProvider = "recount3",
    Maintainer = "Leonardo Collado-Torres <lcolladotor@gmail.com>",
    RDataClass = "data.frame",
    DispatchClass = "Rda",
    RDataPath = file.path(
        pkgname,
        outdir,
        paste0(
            project_info$organism,
            ".",
            basename(project_info$project_home),
            ".",
            project_info$project,
            ".RData"
        )
    ),
    Tags = paste0(
        "recount3;",
        proj_info$organism,
        ";",
        basename(proj_info$project_home),
        ";",
        proj_info$project
    ),
    row.names = NULL,
    stringsAsFactors = FALSE
)

dir.create(here::here("inst", "extdata"),
    recursive = TRUE,
    showWarnings = FALSE
)
write.csv(meta,
    file = here::here(
        "inst",
        "extdata",
        paste0(query_date, "_metadata_recount3.csv")
    ),
    row.names = FALSE
)

## Check
if (FALSE) {
    AnnotationHubData::makeAnnotationHubMetadata(here::here())
}

## Reproducibility information
print("Reproducibility information:")
Sys.time()
proc.time()
options(width = 120)
session_info()
