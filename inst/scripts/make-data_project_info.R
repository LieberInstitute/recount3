# Rscript make-data_project_info.R &> make_data_project_info.txt

library("here")
library("recount3")
library("sessioninfo")

## For this script
dir.create(here::here("inst", "scripts"), recursive = TRUE, showWarnings = FALSE)
dir.create(here::here("inst", "project_data"), recursive = TRUE, showWarnings = FALSE)

project_info_all <- rbind(
    available_projects("human"),
    available_projects("mouse")
)
project_info_all <- subset(project_info_all, project_type == "data_sources")
project_info_all$project_type <- NULL
project_info_all$file_source <- NULL

save(project_info_all, file = here::here("inst", "project_data", paste0(Sys.Date(), "_project_info_all.RData")))

project_info_list <-
    split(project_info_all, seq_len(nrow(project_info_all)))

xx <- lapply(project_info_list, function(project_info) {
    rownames(project_info) <- NULL
    output_dir <-
        here::here(
            "inst",
            "project_data",
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
