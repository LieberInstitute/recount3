library("here")
library("sessioninfo")

## For this script
dir.create(here::here("inst", "scripts"), recursive = TRUE)

project_info_all <- data.frame(
    project = c("ERP001942", "ERP110066", "SRP186687", "BLADDER", "BRAIN"),
    project_home = rep(c("data_sources/sra", "data_sources/gtex"), c(3, 2)),
    organism = "human"
)

save(project_info_all, file = here::here("inst", "data", paste0(Sys.Date(), "_project_info_all.RData")))

project_info_list <-
    split(project_info_all, seq_len(nrow(project_info_all)))

lapply(project_info_list, function(project_info) {
    rownames(project_info) <- NULL
    output_dir <-
        here::here(
            "inst",
            "data",
            project_info$organism,
            project_info$project_home
        )
    dir.create(output_dir,
        showWarnings = FALSE,
        recursive = TRUE
    )
    file_name <-
        paste0(
            project_info$organism,
            ".",
            basename(project_info$project_home),
            ".",
            project_info$project,
            ".RData"
        )
    save(project_info, file = file.path(output_dir, file_name))
})

## Reproducibility information
print("Reproducibility information:")
Sys.time()
proc.time()
options(width = 120)
session_info()
