
<!-- README.md is generated from README.Rmd. Please edit that file -->

# recount3 <img src="man/figures/logo.png" align="right" width="200px" >

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Bioc release
status](http://www.bioconductor.org/shields/build/release/bioc/recount3.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/recount3)
[![Bioc devel
status](http://www.bioconductor.org/shields/build/devel/bioc/recount3.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/recount3)
[![Bioc downloads
rank](https://bioconductor.org/shields/downloads/release/recount3.svg)](http://bioconductor.org/packages/stats/bioc/recount3/)
[![Bioc
support](https://bioconductor.org/shields/posts/recount3.svg)](https://support.bioconductor.org/tag/recount3)
[![Bioc
history](https://bioconductor.org/shields/years-in-bioc/recount3.svg)](https://bioconductor.org/packages/release/bioc/html/recount3.html#since)
[![Bioc last
commit](https://bioconductor.org/shields/lastcommit/devel/bioc/recount3.svg)](http://bioconductor.org/checkResults/devel/bioc-LATEST/recount3/)
[![Bioc
dependencies](https://bioconductor.org/shields/dependencies/release/recount3.svg)](https://bioconductor.org/packages/release/bioc/html/recount3.html#since)
[![Codecov test
coverage](https://codecov.io/gh/LieberInstitute/recount3/branch/master/graph/badge.svg)](https://codecov.io/gh/LieberInstitute/recount3?branch=master)
[![R build
status](https://github.com/LieberInstitute/recount3/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/LieberInstitute/recount3/actions)
[![GitHub
issues](https://img.shields.io/github/issues/LieberInstitute/recount3)](https://github.com/LieberInstitute/recount3/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/LieberInstitute/recount3)](https://github.com/LieberInstitute/recount3/pulls)
<!-- badges: end -->

The *[recount3](https://bioconductor.org/packages/3.16/recount3)*
R/Bioconductor package is part of the `recount3` project and is the
latest iteration of the `ReCount` family of projects that provide access
to uniformly-processed RNA sequencing datasets. The **main documentation
website** for all the `recount3`-related projects is available at
[**recount.bio**](https://LieberInstitute.github.io/recount3-docs).
Please check that website for more information about how this
R/Bioconductor package and other tools are related to each other.

## Documentation

For more information about
*[recount3](https://bioconductor.org/packages/3.16/recount3)* check the
vignettes [through
Bioconductor](http://bioconductor.org/packages/recount3) or at the
[documentation website](http://lieberinstitute.github.io/recount3).

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install
*[recount3](https://bioconductor.org/packages/3.16/recount3)* from
[Bioconductor](http://bioconductor.org/) using the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("recount3")
```

## Citation

Below is the citation output from using `citation('recount3')` in R.
Please run this yourself to check for any updates on how to cite
**recount3**.

``` r
print(citation("recount3"), bibtex = TRUE)
#> 
#> To cite package 'recount3' in publications use:
#> 
#>   Collado-Torres L (2023). _Explore and download data from the recount3
#>   project_. doi:10.18129/B9.bioc.recount3
#>   <https://doi.org/10.18129/B9.bioc.recount3>,
#>   https://github.com/LieberInstitute/recount3 - R package version
#>   1.9.1, <http://www.bioconductor.org/packages/recount3>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {Explore and download data from the recount3 project},
#>     author = {Leonardo Collado-Torres},
#>     year = {2023},
#>     url = {http://www.bioconductor.org/packages/recount3},
#>     note = {https://github.com/LieberInstitute/recount3 - R package version 1.9.1},
#>     doi = {10.18129/B9.bioc.recount3},
#>   }
#> 
#>   Wilks C, Zheng SC, Chen FY, Charles R, Solomon B, Ling JP, Imada EL,
#>   Zhang D, Joseph L, Leek JT, Jaffe AE, Nellore A, Collado-Torres L,
#>   Hansen KD, Langmead B (2021). "recount3: summaries and queries for
#>   large-scale RNA-seq expression and splicing." _Genome Biol_.
#>   doi:10.1186/s13059-021-02533-6
#>   <https://doi.org/10.1186/s13059-021-02533-6>,
#>   <https://doi.org/10.1186/s13059-021-02533-6>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     title = {recount3: summaries and queries for large-scale RNA-seq expression and splicing},
#>     author = {Christopher Wilks and Shijie C. Zheng and Feng Yong Chen and Rone Charles and Brad Solomon and Jonathan P. Ling and Eddie Luidy Imada and David Zhang and Lance Joseph and Jeffrey T. Leek and Andrew E. Jaffe and Abhinav Nellore and Leonardo Collado-Torres and Kasper D. Hansen and Ben Langmead},
#>     year = {2021},
#>     journal = {Genome Biol},
#>     doi = {10.1186/s13059-021-02533-6},
#>     url = {https://doi.org/10.1186/s13059-021-02533-6},
#>   }
```

Please note that
*[recount3](https://bioconductor.org/packages/3.16/recount3)* was only
made possible thanks to many other R and bioinformatics software
authors, which are cited either in the vignettes and/or the paper(s)
describing this package.

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
  *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)* customized
  to use [Bioconductor’s docker
  containers](https://www.bioconductor.org/help/docker/) and
  *[BiocCheck](https://bioconductor.org/packages/3.16/BiocCheck)*.
- Code coverage assessment is possible thanks to
  [codecov](https://codecov.io/gh) and
  *[covr](https://CRAN.R-project.org/package=covr)*.
- The [documentation website](http://lieberinstitute.github.io/recount3)
  is automatically updated thanks to
  *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
- The code is styled automatically thanks to
  *[styler](https://CRAN.R-project.org/package=styler)*.
- The documentation is formatted thanks to
  *[devtools](https://CRAN.R-project.org/package=devtools)* and
  *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

## Project history

To clarify the relationship between the R/Bioconductor packages and the
phases of `ReCount` please check the table below:

| Year | Phase                                                         | Main references                                                                                                                            | R/Bioconductor                                                |
|------|---------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| 2011 | [`ReCount`](http://bowtie-bio.sourceforge.net/recount/)       | DOI: [10.1186/1471-2105-12-449](https://doi.org/10.1186/1471-2105-12-449)                                                                  | none                                                          |
| 2017 | [`recount2`](https://jhubiostatistics.shinyapps.io/recount/)  | DOI: [10.1038/nbt.3838](https://doi.org/10.1038/nbt.3838) [10.12688/f1000research.12223.1](https://doi.org/10.12688/f1000research.12223.1) | *[recount](https://bioconductor.org/packages/3.16/recount)*   |
| 2021 | [`recount3`](https://LieberInstitute.github.io/recount3-docs) | DOI: [10.1186/s13059-021-02533-6](https://doi.org/10.1186/s13059-021-02533-6)                                                              | *[recount3](https://bioconductor.org/packages/3.16/recount3)* |

## Teams involved

The `ReCount` family involves the following teams:

- [Ben Langmead’s lab at JHU Computer
  Science](http://www.langmead-lab.org/)
- [Kasper Daniel Hansen’s lab at JHBSPH Biostatistics
  Department](https://www.hansenlab.org/)
- [Leonardo Collado-Torres](http://lcolladotor.github.io/) and
  [Andrew E. Jaffe](http://aejaffe.com/) from
  [LIBD](https://www.libd.org/)
- [Abhinav Nellore’s lab at OHSU](http://nellore.bio/)
- [Jeff Leek’s lab at JHBSPH Biostatistics
  Deparment](http://jtleek.com/)
- Data hosted by the [Registry of Open Data on
  AWS](https://registry.opendata.aws/recount/) and [SciServer from IDIES
  at JHU](https://www.sciserver.org/) through a load balancer called
  [duffel](https://github.com/nellore/digitalocean-duffel).

|                                                                                                                                                                               |                                                                                                              |                                                                                                                                                                         |                                                                                                                                                   |                                                                                                                                                 |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| <a href="http://www.langmead-lab.org/"><img src="http://www.langmead-lab.org/wp-content/uploads/2014/01/Screen-Shot-2014-02-02-at-5.20.13-PM-1024x199.png" width="250px"></a> | <a href="https://www.libd.org/"><img src="http://lcolladotor.github.io/img/LIBD_logo.jpg" width="250px"></a> | <a href="http://nellore.bio/"><img src="https://seekvectorlogo.net/wp-content/uploads/2018/08/oregon-health-science-university-ohsu-vector-logo.png" width="250px"></a> | <a href="https://www.sciserver.org/"><img src="https://skyserver.sdss.org/dr14/en/images/sciserver_logo_inverted_vertical.png" width="250px"></a> | <a href="https://registry.opendata.aws/recount/"><img src="https://assets.opendata.aws/img/AWS-Logo_White-Color_300x180.png" width="250px"></a> |

<script type='text/javascript' id='clustrmaps' src='//cdn.clustrmaps.com/map_v2.js?cl=ffffff&w=300&t=n&d=4xd7F6p1BfdRypx-yEodrXiKhC0xvF0bJJywqR8rMKQ'></script>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-163623894-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-163623894-1');
</script>
