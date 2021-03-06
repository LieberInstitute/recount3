% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotation_ext.R
\name{annotation_ext}
\alias{annotation_ext}
\title{Obtain the file extension for a given organism and annotation}
\usage{
annotation_ext(
  organism = c("human", "mouse"),
  annotation = annotation_options(organism)
)
}
\arguments{
\item{organism}{A \code{character(1)} specifying which organism you want to
download data from. Supported options are \code{"human"} or \code{"mouse"}.}

\item{annotation}{A \code{character(1)} specifying which annotation you want to
use.}
}
\value{
A \code{character(1)} with the annotation file extension to be used.
}
\description{
Given an \code{organism} and an \code{annotation}, this function returns the
corresponding file extension used in the \code{recount3} files.
}
\examples{

annotation_ext("human")
annotation_ext("human", "fantom6_cat")
annotation_ext("human", "refseq")
annotation_ext("mouse")
}
\seealso{
Other internal functions for accessing the recount3 data: 
\code{\link{create_rse_manual}()},
\code{\link{file_retrieve}()},
\code{\link{locate_url_ann}()},
\code{\link{locate_url}()},
\code{\link{project_homes}()},
\code{\link{read_counts}()},
\code{\link{read_metadata}()}
}
\concept{internal functions for accessing the recount3 data}
