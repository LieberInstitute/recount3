
<!-- README.md is generated from README.Rmd. Please edit that file -->

# recount3 <img src="man/figures/logo.png" align="right" width="400px" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/recount3.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/recount3)
[![Codecov test
coverage](https://codecov.io/gh/LieberInstitute/recount3/branch/master/graph/badge.svg)](https://codecov.io/gh/LieberInstitute/recount3?branch=master)
[![R build
status](https://github.com/LieberInstitute/recount3/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/LieberInstitute/recount3/actions)
<!-- badges: end -->

Explore and download data from the recount project available at the
[recount3 website](https://jhubiostatistics.shinyapps.io/recount3/).
Using the `recount3` package you can download
*RangedSummarizedExperiment* objects at the gene, exon or exon-exon
junctions level, the raw counts, the phenotype metadata used, the urls
to the sample coverage bigWig files or the mean coverage bigWig file for
a particular study. The *RangedSummarizedExperiment* objects can be used
by different packages for performing differential expression analysis.
Using [derfinder](http://bioconductor.org/packages/derfinder) you can
perform annotation-agnostic differential expression analyses with the
data from the recount project.

## Documentation

For more information about `recount3` check the vignettes [through
Bioconductor](http://bioconductor.org/packages/recount3) or at the
[documentation website](http://lieberinstitute.github.io/recount3).

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `recount3` using from
[Bioconductor](http://bioconductor.org/) the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("recount3")
```

## Citation

Below is the citation output from using `citation('recount3')` in R.
Please run this yourself to check for any updates on how to cite
**recount3**.

``` r
print(citation('recount3'), bibtex = TRUE)
#> 
#> Collado-Torres L (2020). _Explore and download data from the recount3
#> project_. doi: 10.18129/B9.bioc.recount3 (URL:
#> https://doi.org/10.18129/B9.bioc.recount3),
#> https://github.com/LieberInstitute/recount3 - R package version 0.99.0,
#> <URL: http://www.bioconductor.org/packages/recount3>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {Explore and download data from the recount3 project},
#>     author = {Leonardo Collado-Torres},
#>     year = {2020},
#>     url = {http://www.bioconductor.org/packages/recount3},
#>     note = {https://github.com/LieberInstitute/recount3 - R package version 0.99.0},
#>     doi = {10.18129/B9.bioc.recount3},
#>   }
#> 
#> Wilks C, Collado-Torres L, Zheng SC, Jaffe AE, Nellore A, Hansen KD,
#> Langmead B (2020). "recount3 pre-print title TODO." _bioRxiv_. doi:
#> 10.1101/TODO (URL: https://doi.org/10.1101/TODO), <URL:
#> https://www.biorxiv.org/content/10.1101/TODO>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {recount3 pre-print title TODO},
#>     author = {Christopher Wilks and Leonardo Collado-Torres and Shijie C. Zheng and Andrew E. Jaffe and Abhinav Nellore and Kasper D. Hansen and Ben Langmead},
#>     year = {2020},
#>     journal = {bioRxiv},
#>     doi = {10.1101/TODO},
#>     url = {https://www.biorxiv.org/content/10.1101/TODO},
#>   }
```

Please note that the `recount3` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the derfinderPlot project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Development tools

  - Continuous code testing is possible thanks to [GitHub
    actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
    through *[usethis](https://CRAN.R-project.org/package=usethis)*,
    *[remotes](https://CRAN.R-project.org/package=remotes)*,
    *[sysreqs](https://github.com/r-hub/sysreqs)* and
    *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)*
    customized to use [Bioconductor’s docker
    containers](https://www.bioconductor.org/help/docker/) and
    *[BiocCheck](https://bioconductor.org/packages/3.11/BiocCheck)*.
  - Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh) and
    *[covr](https://CRAN.R-project.org/package=covr)*.
  - The [documentation
    website](http://lieberinstitute.github.io/recount3) is automatically
    updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
  - The code is styled automatically thanks to
    *[styler](https://CRAN.R-project.org/package=styler)*.
  - The documentation is formatted thanks to
    *[devtools](https://CRAN.R-project.org/package=devtools)* and
    *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

## Teams involved

  - [Ben Langmead’s lab at JHU Computer
    Science](http://www.langmead-lab.org/),
  - [Kasper Daniel Hansen’s lab at JHBSPH Biostatistics
    Department](https://www.hansenlab.org/),
  - [Leonardo Collado-Torres](http://lcolladotor.github.io/) and [Andrew
    E. Jaffe](http://aejaffe.com/) from [LIBD](https://www.libd.org/),
  - [Abhinav Nellore’s lab at OHSU](http://nellore.bio/),
  - Data hosted by [SciServer at JHU](https://www.sciserver.org/).

|                                                                                                                                                                               |                                                                                                      |                                                                                                                                                                         |                                                                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| <a href="http://www.langmead-lab.org/"><img src="http://www.langmead-lab.org/wp-content/uploads/2014/01/Screen-Shot-2014-02-02-at-5.20.13-PM-1024x199.png" width="250px"></a> | <a href="https://www.libd.org/"><img src="http://aejaffe.com/media/LIBD_logo.jpg" width="250px"></a> | <a href="http://nellore.bio/"><img src="https://seekvectorlogo.net/wp-content/uploads/2018/08/oregon-health-science-university-ohsu-vector-logo.png" width="250px"></a> | <a href="https://www.sciserver.org/"><img src="https://skyserver.sdss.org/dr14/en/images/sciserver_logo_inverted_vertical.png" width="250px"></a> |

<script type='text/javascript' id='clustrmaps' src='//cdn.clustrmaps.com/map_v2.js?cl=ffffff&w=300&t=n&d=4xd7F6p1BfdRypx-yEodrXiKhC0xvF0bJJywqR8rMKQ'></script>

<!-- Global site tag (gtag.js) - Google Analytics -->

<script async src="https://www.googletagmanager.com/gtag/js?id=UA-163623894-1"></script>

<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-163623894-1');
</script>
