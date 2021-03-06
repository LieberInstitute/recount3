% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/expand_sra_attributes.R
\name{expand_sra_attributes}
\alias{expand_sra_attributes}
\title{Expand SRA attributes}
\usage{
expand_sra_attributes(rse)
}
\arguments{
\item{rse}{A \link[SummarizedExperiment:RangedSummarizedExperiment-class]{RangedSummarizedExperiment-class}
object created by \code{create_rse()} or \code{create_rse_manual()}.}
}
\value{
A \link[SummarizedExperiment:RangedSummarizedExperiment-class]{RangedSummarizedExperiment-class}
object with expanded metadata columns.
}
\description{
This function expands the SRA attributes stored in \code{sra.sample_attributes}
variable in the \code{colData()} slot of a
\link[SummarizedExperiment:RangedSummarizedExperiment-class]{RangedSummarizedExperiment-class}
produced by \code{create_rse()}.
}
\details{
Note that this function will work on projects available from SRA only.
Furthermore, SRA attributes are project-specific. Thus, if you use this
function in more than one RSE object, you won't be able to combine them
easily with \code{cbind()} and will need to manually merge the \code{colData()} slots
from your set of RSE files before being able to run \code{cbind()}.
}
\examples{

## Find all available human projects
human_projects <- available_projects()

## Find the project you are interested in
proj_info <- subset(
    human_projects,
    project == "SRP009615" & project_type == "data_sources"
)

## Create a RSE object at the gene level
rse_gene_SRP009615 <- create_rse(proj_info)

## Expand the SRA attributes (see details for more information)
rse_gene_SRP009615 <- expand_sra_attributes(rse_gene_SRP009615)
}
\author{
Andrew E Jaffe modified by Leonardo Collado-Torres.
}
