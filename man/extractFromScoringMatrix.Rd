% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{extractFromScoringMatrix}
\alias{extractFromScoringMatrix}
\title{Extract from Scoring matrix}
\usage{
extractFromScoringMatrix(ScoringFrame, grainType1, grainType2)
}
\arguments{
\item{ScoringFrame}{Scoring matrix of type data.frame (needs to be of symmetric, matrix like format)}

\item{grainType1}{factor vector of grain types contained in ScoringFrame}

\item{grainType2}{same as \code{grainType1}}
}
\value{
numeric vector of length \code{grainType1} with the elements of \code{ScoringFrame}
that are defined by \code{grainType1} and \code{grainType2}
}
\description{
Vectorized function to efficiently extract elements from scoring matrix of type data.frame
}
\author{
fherla
}
