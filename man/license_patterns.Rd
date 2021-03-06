% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/licenses.R
\docType{data}
\name{license_patterns}
\alias{license_patterns}
\title{URL components for open access licenses}
\format{
A data frame with the following variables:
\itemize{
\item url:
the URL components (domain and path) to licenses
\item source:
the source which first identified the license URL as indicating open source.
For details, see source.
}
}
\source{
\itemize{
\item \code{dissemin}:
\href{https://dissem.in/}{dissemin} compiled a list of licenses used in Crossref,
which indicate OA availability.
\href{https://oadoi.org}{oaDOI} re-uses this list.
This list has been downloaded from the \href{https://github.com/dissemin/dissemin/blob/0aa00972eb13a6a59e1bc04b303cdcab9189406a/backend/crossref.py#L89}{dissemin source on github}
\item \code{oadoi}:
\href{https://oadoi.org}{oaDOI} also accepted these urls as per a \href{https://github.com/ourresearch/oadoi/issues/49}{github issue}.
}
}
\usage{
license_patterns
}
\description{
Metadata sometimes do not include structured data on the openess of a license, but only URLs to full license texts.
These URL components are taken as an indication that an article is under an open license.
}
\examples{
license_patterns
}
\seealso{
Other data: 
\code{\link{hybrid_publications}()},
\code{\link{unpaywall_df}()}
}
\concept{data}
\keyword{datasets}
