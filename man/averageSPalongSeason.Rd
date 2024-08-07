% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/averageSPalongSeason.R
\name{averageSPalongSeason}
\alias{averageSPalongSeason}
\title{Compute a seasonal timeseries of an average snowprofile}
\usage{
averageSPalongSeason(
  SPx,
  sm = summary(SPx),
  AvgDayBefore = NULL,
  DateEnd = max(sm$date),
  keep.profiles = TRUE,
  progressbar = requireNamespace("progress", quietly = TRUE),
  dailyRescaling = c("settleTopOldSnow", "settleEntireOldSnow")[1],
  proportionPWL = 0.3,
  breakAtSim = 0.9,
  breakAfter = 2,
  verbose = FALSE,
  resamplingRate = 0.5,
  top.down = FALSE,
  checkGlobalAlignment = FALSE,
  prefLayerWeights = NA,
  dims = c("gtype", "hardness", "ddate"),
  weights = c(0.375, 0.125, 0.5),
  ...
)
}
\arguments{
\item{SPx}{a \link[sarp.snowprofile:snowprofileSet]{sarp.snowprofile::snowprofileSet} that contains all profiles from the region to be averaged at all days of the season for which you want to compute the average profile.
Identically to \link{dbaSP}, weak layers need to be labeled prior to this function call, see \link{dbaSP} and \link[sarp.snowprofile:findPWL]{sarp.snowprofile::labelPWL}. Note that only daily sampling is
allowed at this point (i.e., one profile per grid point per day).}

\item{sm}{a summary of \code{SPx} containing meta-data}

\item{AvgDayBefore}{an average \link[sarp.snowprofile:snowprofile]{sarp.snowprofile::snowprofile} from the previous day. This is only necessary if you want to resume the computation
mid season.}

\item{DateEnd}{an end date character string (\code{"YYYY-MM-DD"}) if you only want to compute the timeseries up to a certain point
in time. Defaults to the future-most date contained in the meta-data object \code{sm}.}

\item{keep.profiles}{Do you want to keep the (resampled) individual snow profiles from \code{SPx} in your return object? \strong{Note}
that this must be \code{TRUE} if you plan to \link{backtrackLayers} to derive any kind of summary statistics for the averaged layers.
See Notes below, and examples of how to conveniently \link{backtrackLayers}.}

\item{progressbar}{display a progress bar during computation?}

\item{dailyRescaling}{choose between two settlement rescaling approaches. \code{settleEntireOldSnow} re-scales the entire old snow
column so that the average snow height represents the median snow height from the profile set. \code{settleTopOldSnow} (the default)
re-scales the upper part of the old snow column to achieve the same goal. While the former mostly leads to buried layers being
settled to too deep snow depths, the default approach aims to leave those buried layers unchanged, which are located at depths
that represent the median depths of their aligned layers.}

\item{proportionPWL}{decimal number that specifies the proportion required to average an ensemble of grain types as weak layer type.
A value of 0.3, for example, means that layers will get averaged to a PWL type if 30\% of the layers are of PWL type.
Meaningful range is between \verb{[0.1, 0.5]}. Values larger than 0.5 get set to 0.5.}

\item{breakAtSim}{stop iterations when \link{simSP} between the last average profiles is beyond that value. Can range between \verb{[0, 1]}. Default values differ between \link{dbaSP} and \link{averageSP}.}

\item{breakAfter}{integer specifying how many values of simSP need to be above \code{breakAtSim} to stop iterating. Default values differ between \link{dbaSP} and \link{averageSP}.}

\item{verbose}{print similarities between old and new average in between iterations?}

\item{resamplingRate}{Resampling rate for a regular depth grid among the profiles}

\item{top.down}{a \link{dtwSP} parameter, which needs to be set to \code{FALSE} to ensure correct growing of the snowpack during snowfall.}

\item{checkGlobalAlignment}{a \link{dtwSP} parameter, which needs to be set to \code{FALSE} analogous to \code{top.down}}

\item{prefLayerWeights}{a \link{dtwSP} parameter. Might be best to set this to \code{NA}, but can potentially be set to
\code{layerWeightingMat(FALSE)} \emph{in case of} averaging a very large geographic region with temporal lags between weather events.}

\item{dims}{a \link{dtwSP} parameter, which is modified to include deposition date alignments per default}

\item{weights}{a \link{dtwSP} parameter that sets the according weights to the \code{dims} specified above.}

\item{...}{any other parameters passed on to \link{dbaSP} and then \link{dtwSP}.}
}
\value{
A list of class \code{avgSP_timeseries} containing the fields \verb{$avgs} with a \link[sarp.snowprofile:snowprofileSet]{sarp.snowprofile::snowprofileSet} of the average profiles at each day.
If \code{keep.profiles == TRUE} a field \verb{$sets} with the according profiles informing the average profile at each day (which can be
used to \link{backtrackLayers} to compute summary statistics of the averaged layers). And two fields \verb{$call} and \verb{$meta}. The
latter contains several useful meta-information such as \code{...$date}, \code{...$hs}, \code{...$hs_median}, \code{...$thicknessPPDF_median}, or \code{...$rmse}, which gauges
the representativity of the average profile (the closer to \code{0}, the better; the closer to \code{1}, the worse).
}
\description{
This routine computes the seasonal timeseries of the average snow profile for a given region/set of profiles. The total snow height of the
seasonal average profile closely follows the \emph{median snow height} represented by the group of profiles each day. Also the
new snow amounts represent the \emph{median new snow amounts} within the group (i.e., PP and DF grains). The routine maintains
temporal consistency by using the previous day average profile as initial condition to derive the next day's. This creates the need for re-scaling
the layer thicknesses each day to account for snow settlement and melting. Two different re-scaling approaches have been implemented,
which both aim to re-scale the old snow part of the column (i.e., the snow which was on the ground already at the previous day).
See parameter description for more details. Also note, that the routine can be started at any day of the season by providing
an average profile from the previous day. The routine modifies several parameters, which are passed on to \link{dtwSP}. These
parameters differ from the defaults specified in \link{dtwSP}, which are held very generic, whereas the application in this function
is much more specific to certain requirements and algorithm behavior. For more details, refer to the reference paper.
}
\details{
Computing the seasonal average profile for an entire season and about 100 grid points (with a max of 150 cm snow depth) takes roughly 60 mins.
}
\note{
\itemize{
\item If you don't provide an AvgDayBefore, it will be computed with \link{averageSP} and \emph{default} parameters
(dots won't be passed to initializing the first average profile)!
\item Even though \link{backtrackLayers} allows for backtracking layers based on height, it is not recommended to try and
backtrack layers if \code{keep.profiles = FALSE}, since profiles that can't be aligned to the average profile (\verb{$avgs[[i]]})
are being discarded from the profile set at that day (\verb{$sets[[i]]}), which changes \code{queryID}s in the backtrackingTable.
Conclusion: If you want to backtrack layers from the seasonal average profile, you \emph{must} \code{keep.profiles = TRUE}. See examples!
}
}
\examples{

run_the_examples <- FALSE  # exclude long-running examples
if (run_the_examples) {

## compute average timeseries for simplistic example data set 'SPspacetime'
## first: label weak layers (you can choose your own rules and thresholds!)
SPspacetime <- snowprofileSet(lapply(SPspacetime, function(sp) {
 labelPWL(sp, pwl_gtype = c("SH", "DH", "FC", "FCxr"), threshold_RTA = 0.8)
}))  # label weak layers in each profile of the profile set 'SPspacetime'

## second: average along several days
avgTS <- averageSPalongSeason(SPspacetime)

## explore resulting object
names(avgTS)

# timeseries figure
plot(avgTS$avgs, main = "average time series")
# add line representing median snow height
lines(avgTS$meta$date, avgTS$meta$hs_median)
# add line representing median new snow amounts
lines(avgTS$meta$date, avgTS$meta$hs - avgTS$meta$thicknessPPDF_median, lty = 'dashed')

# individual profile sets from one day
plot(avgTS$sets[[1]], SortMethod = "hs", main = "individual profiles from first day")


## backtrack individual layers of the average profile...
individualLayers <- backtrackLayers(avgProfile = avgTS$avgs[[1]],
                      profileSet = avgTS$sets[[1]],
                      layer = findPWL(avgTS$avgs[[1]], pwl_gtype = c("SH", "DH"),
                                      pwl_date = "2018-10-17", threshold_RTA = 0.8))
## ... to retrieve summary statistics or distributions, e.g. stability distribution
hist(individualLayers[[1]]$rta)
hist(individualLayers[[1]]$depth)

## see the Vignette about averaging profiles for more examples!


}

}
\references{
Herla, F., Haegeli, P., and Mair, P. (2022). A data exploration tool for averaging and accessing large data sets of snow stratigraphy profiles useful for avalanche forecasting,
The Cryosphere, 16(8), 3149–3162, https://doi.org/10.5194/tc-16-3149-2022
}
\seealso{
\link{dbaSP}, \link{averageSP}, \link[sarp.snowprofile:findPWL]{sarp.snowprofile::labelPWL}
}
\author{
fherla
}
