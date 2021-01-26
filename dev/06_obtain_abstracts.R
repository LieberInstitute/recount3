## Get all the metadata files
get_metadata_files <-
    function(projects,
    recount3_url = getOption("recount3_url", "http://idies.jhu.edu/recount3/data")) {
        do.call(rbind, apply(projects, 1, function(x) {
            x <-
                locate_url(
                    project = x[["project"]],
                    project_home = x[["project_home"]],
                    type = "metadata",
                    organism = x[["organism"]],
                    recount3_url = recount3_url
                )
            res <- data.frame(t(x))
            colnames(res) <-
                gsub("\\..*", "", gsub("^[a-z]+\\.", "", colnames(res)))

            colnames(res)[colnames(res) %in% unique(projects$file_source)] <-
                "project_meta"
            return(res)
        }))
    }

## Get all the project descriptions
get_proj_desc <-
    function(projects, metadata_files, bfc = recount3_cache()) {
        ## Using BiocParallel::bplapply instead of purrr::map fails
        ## likely due to some interaction with BiocFileCache.
        purrr::map(seq_len(nrow(projects)), function(i) {
            x <- projects[i, ]
            if (x[["file_source"]] != "sra") {
                return(data.frame(
                    "study_title" = x[["file_source"]],
                    "study_abstract" = x[["project"]]
                ))
            }

            x <-
                utils::read.delim(
                    file_retrieve(metadata_files[["project_meta"]][i], bfc = bfc, verbose = FALSE),
                    sep = "\t",
                    check.names = FALSE,
                    nrows = 1,
                    quote = "",
                    comment.char = ""
                )
            # x <- utils::read.delim(file_retrieve("http://idies.jhu.edu/recount3/data/human/data_sources/sra/metadata/18/SRP195118/sra.sra.SRP195118.MD.gz", bfc = bfc, verbose = FALSE), sep = "\t", check.names = FALSE, nrows = 1)
            x[, c("study_title", "study_abstract")]
        }) # , BPPARAM = BiocParallel::MulticoreParam(4))
    }

projects_human <- available_projects("human")
meta_human <- get_metadata_files(projects_human)
system.time(desc_human_raw <-
    get_proj_desc(projects_human, meta_human))
desc_human <- do.call(rbind, desc_human_raw)
#     user    system   elapsed
# 9439.869   528.982 16015.980

# system.time(desc_human_raw <- get_proj_desc(projects_human[c(1:3, 8678, 8710), ], meta_human[c(1:3, 8678, 8710), ]))

projects_mouse <- available_projects("mouse")
meta_mouse <- get_metadata_files(projects_mouse)
system.time(desc_mouse_raw <-
    get_proj_desc(projects_mouse, meta_mouse))
#      user    system   elapsed
# 19201.522  1219.096 26679.388
desc_mouse <- do.call(rbind, desc_mouse_raw)


projects_meta <- rbind(
    cbind(projects_human, desc_human),
    cbind(projects_mouse, desc_mouse)
)
dim(projects_meta)
# [1] 18830     8

## Add manually abtract and titles for GTEx
projects_meta$study_title[projects_meta$file_source == "gtex"] <- paste(
    "GTEx v8 data for tissue:", tolower(gsub("_", " ", projects_meta$project[projects_meta$file_source == "gtex"]))
)
projects_meta$study_abstract[projects_meta$file_source == "gtex"] <- "The Genotype-Tissue Expression (GTEx) project is an ongoing effort to build a comprehensive public resource to study tissue-specific gene expression and regulation. Samples were collected from 54 non-diseased tissue sites across nearly 1000 individuals, primarily for molecular assays including WGS, WES, and RNA-Seq. Remaining samples are available from the GTEx Biobank. The GTEx Portal provides open access to data including gene expression, QTLs, and histology images. Check <https://gtexportal.org/> for more information on the GTEx project."

## Add manually abtract and titles for TCGA
projects_meta$study_title[projects_meta$file_source == "tcga"] <- paste(
    "TCGA data for tissue:", projects_meta$project[projects_meta$file_source == "tcga"]
)
projects_meta$study_abstract[projects_meta$file_source == "tcga"] <- "The Cancer Genome Atlas (TCGA), a landmark cancer genomics program, molecularly characterized over 20,000 primary cancer and matched normal samples spanning 33 cancer types. This joint effort between the National Cancer Institute and the National Human Genome Research Institute began in 2006, bringing together researchers from diverse disciplines and multiple institutions. Check <https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga> for more information on the TCGA project."

dir.create(
    here::here("inst", "study-explorer"),
    showWarnings = FALSE,
    recursive = TRUE
)
save(projects_meta,
    file = here::here("inst", "study-explorer", "projects_meta.Rdata")
)

options(width = 120)
sessioninfo::session_info()

# ─ Session info ───────────────────────────────────────────────────────────────────────────────────────────────────────
#  setting  value
#  version  R version 4.0.3 (2020-10-10)
#  os       macOS Big Sur 10.16
#  system   x86_64, darwin17.0
#  ui       RStudio
#  language (EN)
#  collate  en_US.UTF-8
#  ctype    en_US.UTF-8
#  tz       America/New_York
#  date     2021-01-25
#
# ─ Packages ───────────────────────────────────────────────────────────────────────────────────────────────────────────
#  !  package              * version  date       lib source
#     assertthat             0.2.1    2019-03-21 [1] CRAN (R 4.0.2)
#     Biobase              * 2.50.0   2020-10-27 [1] Bioconductor
#     BiocFileCache          1.14.0   2020-10-27 [1] Bioconductor
#     BiocGenerics         * 0.36.0   2020-10-27 [1] Bioconductor
#     BiocParallel           1.24.1   2020-11-06 [1] Bioconductor
#     Biostrings             2.58.0   2020-10-27 [1] Bioconductor
#     bit                    4.0.4    2020-08-04 [1] CRAN (R 4.0.2)
#     bit64                  4.0.5    2020-08-30 [1] CRAN (R 4.0.2)
#     bitops                 1.0-6    2013-08-17 [1] CRAN (R 4.0.2)
#     blob                   1.2.1    2020-01-20 [1] CRAN (R 4.0.2)
#     callr                  3.5.1    2020-10-13 [1] CRAN (R 4.0.2)
#     cli                    2.2.0    2020-11-20 [1] CRAN (R 4.0.2)
#     clisymbols             1.2.0    2017-05-21 [1] CRAN (R 4.0.2)
#     colorout               1.2-2    2020-11-03 [1] Github (jalvesaq/colorout@726d681)
#     crayon                 1.3.4    2017-09-16 [1] CRAN (R 4.0.2)
#     curl                   4.3      2019-12-02 [1] CRAN (R 4.0.1)
#     data.table             1.13.6   2020-12-30 [1] CRAN (R 4.0.2)
#     DBI                    1.1.0    2019-12-15 [1] CRAN (R 4.0.2)
#     dbplyr                 2.0.0    2020-11-03 [1] CRAN (R 4.0.3)
#     DelayedArray           0.16.0   2020-10-27 [1] Bioconductor
#     desc                   1.2.0    2018-05-01 [1] CRAN (R 4.0.2)
#     devtools             * 2.3.2    2020-09-18 [1] CRAN (R 4.0.2)
#     digest                 0.6.27   2020-10-24 [1] CRAN (R 4.0.2)
#     dplyr                  1.0.2    2020-08-18 [1] CRAN (R 4.0.2)
#     ellipsis               0.3.1    2020-05-15 [1] CRAN (R 4.0.2)
#     evaluate               0.14     2019-05-28 [1] CRAN (R 4.0.1)
#     fansi                  0.4.1    2020-01-08 [1] CRAN (R 4.0.2)
#     fs                     1.5.0    2020-07-31 [1] CRAN (R 4.0.2)
#     generics               0.1.0    2020-10-31 [1] CRAN (R 4.0.2)
#     GenomeInfoDb         * 1.26.2   2020-12-08 [1] Bioconductor
#     GenomeInfoDbData       1.2.4    2020-11-03 [1] Bioconductor
#     GenomicAlignments      1.26.0   2020-10-27 [1] Bioconductor
#     GenomicRanges        * 1.42.0   2020-10-27 [1] Bioconductor
#     glue                   1.4.2    2020-08-27 [1] CRAN (R 4.0.2)
#     here                   1.0.1    2020-12-13 [1] CRAN (R 4.0.3)
#     htmltools              0.5.0    2020-06-16 [1] CRAN (R 4.0.2)
#     httr                   1.4.2    2020-07-20 [1] CRAN (R 4.0.2)
#     IRanges              * 2.24.1   2020-12-12 [1] Bioconductor
#     knitr                  1.30     2020-09-22 [1] CRAN (R 4.0.2)
#     lattice                0.20-41  2020-04-02 [1] CRAN (R 4.0.3)
#     lifecycle              0.2.0    2020-03-06 [1] CRAN (R 4.0.2)
#     lubridate              1.7.9.2  2020-11-13 [1] CRAN (R 4.0.2)
#     magrittr               2.0.1    2020-11-17 [1] CRAN (R 4.0.2)
#     Matrix                 1.3-0    2020-12-22 [1] CRAN (R 4.0.2)
#     MatrixGenerics       * 1.2.0    2020-10-27 [1] Bioconductor
#     matrixStats          * 0.57.0   2020-09-25 [1] CRAN (R 4.0.2)
#     memoise                1.1.0    2017-04-21 [1] CRAN (R 4.0.2)
#     pillar                 1.4.7    2020-11-20 [1] CRAN (R 4.0.2)
#     pkgbuild               1.2.0    2020-12-15 [1] CRAN (R 4.0.3)
#     pkgconfig              2.0.3    2019-09-22 [1] CRAN (R 4.0.2)
#     pkgload                1.1.0    2020-05-29 [1] CRAN (R 4.0.2)
#     prettyunits            1.1.1    2020-01-24 [1] CRAN (R 4.0.2)
#     processx               3.4.5    2020-11-30 [1] CRAN (R 4.0.3)
#     prompt                 1.0.0    2020-12-18 [1] Github (gaborcsardi/prompt@b332c42)
#     ps                     1.5.0    2020-12-05 [1] CRAN (R 4.0.2)
#     purrr                  0.3.4    2020-04-17 [1] CRAN (R 4.0.2)
#     R.methodsS3            1.8.1    2020-08-26 [1] CRAN (R 4.0.2)
#     R.oo                   1.24.0   2020-08-26 [1] CRAN (R 4.0.2)
#     R.utils                2.10.1   2020-08-26 [1] CRAN (R 4.0.2)
#     R6                     2.5.0    2020-10-28 [1] CRAN (R 4.0.2)
#     rappdirs               0.3.1    2016-03-28 [1] CRAN (R 4.0.2)
#     Rcpp                   1.0.5    2020-07-06 [1] CRAN (R 4.0.2)
#     RCurl                  1.98-1.2 2020-04-18 [1] CRAN (R 4.0.2)
#  VP recount3             * 1.1.2    2020-11-04 [?] Bioconductor
#     remotes                2.2.0    2020-07-21 [1] CRAN (R 4.0.2)
#     rlang                  0.4.10   2020-12-30 [1] CRAN (R 4.0.2)
#     rmarkdown              2.6      2020-12-14 [1] CRAN (R 4.0.3)
#     rprojroot              2.0.2    2020-11-15 [1] CRAN (R 4.0.2)
#     Rsamtools              2.6.0    2020-10-27 [1] Bioconductor
#     RSQLite                2.2.1    2020-09-30 [1] CRAN (R 4.0.2)
#     rsthemes               0.1.0    2020-11-03 [1] Github (gadenbuie/rsthemes@6391fe5)
#     rstudioapi             0.13     2020-11-12 [1] CRAN (R 4.0.2)
#     rtracklayer            1.50.0   2020-10-27 [1] Bioconductor
#     S4Vectors            * 0.28.1   2020-12-09 [1] Bioconductor
#     sessioninfo            1.1.1    2018-11-05 [1] CRAN (R 4.0.2)
#     SummarizedExperiment * 1.20.0   2020-10-27 [1] Bioconductor
#     suncalc                0.5.0    2019-04-03 [1] CRAN (R 4.0.2)
#     testthat             * 3.0.1    2020-12-17 [1] CRAN (R 4.0.3)
#     tibble                 3.0.4    2020-10-12 [1] CRAN (R 4.0.2)
#     tidyselect             1.1.0    2020-05-11 [1] CRAN (R 4.0.2)
#     usethis              * 2.0.0    2020-12-10 [1] CRAN (R 4.0.2)
#     vctrs                  0.3.6    2020-12-17 [1] CRAN (R 4.0.3)
#     withr                  2.3.0    2020-09-22 [1] CRAN (R 4.0.2)
#     xfun                   0.19     2020-10-30 [1] CRAN (R 4.0.2)
#     XML                    3.99-0.5 2020-07-23 [1] CRAN (R 4.0.2)
#     XVector                0.30.0   2020-10-28 [1] Bioconductor
#     yaml                   2.2.1    2020-02-01 [1] CRAN (R 4.0.2)
#     zlibbioc               1.36.0   2020-10-28 [1] Bioconductor
#
# [1] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
#
#  V ── Loaded and on-disk version mismatch.
#  P ── Loaded and on-disk path mismatch.

## Un-used older code
# projects$gene <- apply(projects, 1, function(x)
#     locate_url(
#         project = x["project"],
#         project_home = x["project_home"],
#         type = "gene",
#         organism = x["organism"],
#         recount3_url = recount3_url
#     ))
#
# projects$exon <- apply(projects, 1, function(x)
#     locate_url(
#         project = x["project"],
#         project_home = x["project_home"],
#         type = "exon",
#         organism = x["organism"],
#         recount3_url = recount3_url
#     ))
#
# projects <-
#     cbind(projects, do.call(rbind, apply(projects, 1, function(x) {
#         x <-
#             locate_url(
#                 project = x["project"],
#                 project_home = x["project_home"],
#                 type = "jxn",
#                 organism = x["organism"],
#                 recount3_url = recount3_url
#             )
#         res <- data.frame(t(x))
#         colnames(res) <-
#             paste0("jxn_", gsub("^.*\\.", "", gsub("\\.gz", "", colnames(res))))
#         return(res)
#     })))
