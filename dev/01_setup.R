## Create the package
usethis::create_package('recount3')

## Create the dev directory
dir.create('dev')
file.create('dev/01_setup.R')
rstudioapi::navigateToFile('dev/01_setup.R')

## Ignore the dev directory
system('echo dev >> .Rbuildignore')

## Edited the DESCRIPTION file using recount & spatialLIBD as the templates

usethis::use_package_doc()
usethis::use_github_action('check-standard')
usethis::use_github_action("test-coverage")

## pkgdown setup
usethis::use_pkgdown()
usethis::use_github_action('pkgdown')

## Support files
usethis::use_readme_rmd() ## using recount & spatialLIBD as the templates
usethis::use_news_md()
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge('Experimental')
usethis::use_bioc_badge()

## Tests
usethis::use_testthat()

## Vignette
usethis::use_vignette('recount3-quickstart', 'recount3 quick start guide')
usethis::use_package('BiocStyle', 'Suggests')
usethis::use_package('knitcitations', 'Suggests')
usethis::use_package('sessioninfo', 'Suggests')

## Main packages
usethis::use_package('SummarizedExperiment', 'Depends')
usethis::use_package('BiocFileCache')
usethis::use_package('AnnotationHub')

## GitHub
devtools::document()
usethis::use_git() ## Don't commit yet, since I need to ignore the .Rproj file
usethis::use_git_ignore('*.Rproj')
usethis::use_github('LieberInstitute')
usethis::use_github_actions_badge('check-standard')
usethis::use_github_actions_badge('test-coverage')
usethis::use_github_actions_badge('pkgdown')
