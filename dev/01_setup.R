## Create the package
usethis::create_package("recount3")

## Create the dev directory
dir.create("dev")
file.create("dev/01_setup.R")
rstudioapi::navigateToFile("dev/01_setup.R")

## Ignore the dev directory
system("echo dev >> .Rbuildignore")

## Edited the DESCRIPTION file using recount & spatialLIBD as the templates

## GitHub tests
## Original one
# usethis::use_github_action('check-standard')
## Modified one:
usethis::use_github_action("check-bioc",
    url = "https://raw.githubusercontent.com/leekgroup/derfinderPlot/master/.github/workflows/check-bioc.yml"
)

## pkgdown setup
usethis::use_pkgdown()

## Support files
usethis::use_readme_rmd() ## using recount & spatialLIBD as the templates
usethis::use_news_md()

usethis::use_tidy_coc()
usethis::use_tidy_contributing()
## Customize the support message to mention the Bioconductor Support Website
usethis::use_tidy_support()
support <- readLines(".github/SUPPORT.md")
support <-
    gsub(
        "\\[community.rstudio.com\\]\\(https://community.rstudio.com/\\), and/or StackOverflow",
        "the [Bioconductor Support Website](https://support.bioconductor.org/) using the appropriate package tag",
        support
    )
writeLines(support, ".github/SUPPORT.md")

## Use my own ISSUE template, modified from https://github.com/lcolladotor/osca_LIIGH_UNAM_2020
contents <- xfun::read_utf8("https://raw.githubusercontent.com/leekgroup/derfinderPlot/master/.github/ISSUE_TEMPLATE/issue_template.md")
save_as <- file.path(".github", "ISSUE_TEMPLATE", "issue_template.md")
usethis:::create_directory(dirname(save_as))
usethis::write_over(proj_path(save_as), contents)

## Add some badges
usethis::use_lifecycle_badge("Experimental")
usethis::use_bioc_badge()

## Tests
usethis::use_testthat()
usethis::use_test("citation")
usethis::use_coverage()

## Vignette
usethis::use_vignette("recount3-quickstart", "recount3 quick start guide")
usethis::use_package("BiocStyle", "Suggests")
usethis::use_package("knitcitations", "Suggests")
usethis::use_package("sessioninfo", "Suggests")
usethis::use_package("RefManageR", "Suggests")

## Main packages
usethis::use_package("SummarizedExperiment", "Depends")
usethis::use_package("BiocFileCache")
usethis::use_package("AnnotationHub")

## GitHub
devtools::document()
usethis::use_git() ## Don't commit yet, since I need to ignore the .Rproj file
usethis::use_git_ignore("*.Rproj")
usethis::use_github("LieberInstitute")

## GitHub badges
usethis::use_github_actions_badge("R-CMD-check-bioc")

## Update style for this document
styler::style_file("dev/01_setup.R", transformers = styler::tidyverse_style(indent_by = 4))

## Update prior to committing
file.create("dev/02_update.R")
rstudioapi::navigateToFile("dev/02_update.R")
