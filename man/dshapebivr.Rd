% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{dshapebivr}
\alias{dshapebivr}
\title{Bivariate Kernel density estimation for data classified in polygons or shapes}
\usage{
dshapebivr(
  data,
  burnin = 2,
  samples = 5,
  adaptive = FALSE,
  shapefile,
  gridsize = 200,
  boundary = FALSE,
  deleteShapes = NULL,
  fastWeights = TRUE,
  numChains = 1,
  numThreads = 1
)
}
\arguments{
\item{data}{data.frame with 3 columns: x-coordinate, y-coordinate (i.e. center of polygon) and number of observations in area.}

\item{burnin}{burn-in sample size}

\item{samples}{sampling iteration size}

\item{adaptive}{TRUE for adaptive kernel density estimation}

\item{shapefile}{shapefile with number of polygons equal to nrow(data)}

\item{gridsize}{number of evaluation grid points}

\item{boundary}{boundary corrected kernel density estimate?}

\item{deleteShapes}{shapefile containing areas without observations}

\item{fastWeights}{if TRUE weigths for boundary estimation are only computed for first 10 percent of samples to speed up computation}

\item{numChains}{number of chains of SEM algorithm}

\item{numThreads}{number of threads to be used (only applicable if more than one chains)}
}
\value{
The function returns a list object with the following objects (besides all input objects):
\item{\code{Mestimates}}{kde object containing the corrected density estimate}
\item{\code{gridx}}{Vector Grid of x-coordinates on which density is evaluated}
\item{\code{gridy}}{Vector Grid of y-coordinates on which density is evaluated}
\item{\code{resultDensity}}{Matrix with Estimated Density for each iteration}
\item{\code{resultX}}{Matrix of true latent values X estimates}
}
\description{
Bivariate Kernel density estimation for data classified in polygons or shapes
}
\examples{
\dontrun{
library(maptools)

# Read Shapefile of Berlin Urban Planning Areas (download available from:
# https://www.statistik-berlin-brandenburg.de/opendata/RBS_OD_LOR_2015_12.zip)
Berlin <- rgdal::readOGR("X:/SomeDir/RBS_OD_LOR_2015_12.shp") #(von daten.berlin.de)

# Get Dataset of Berlin Population (download available from:
# https://www.statistik-berlin-brandenburg.de/opendata/EWR201512E_Matrix.csv)
data <- read.csv2("X:/SomeDir/EWR201512E_Matrix.csv")

# Form Dataset for Estimation Process
dataIn <- cbind(t(sapply(1:length(Berlin@polygons),
 function(x) Berlin@polygons[[x]]@labpt)), data$E_E65U80)

#Estimate Bivariate Density
Est <- dshapebivr(data = dataIn, burnin = 5, samples = 10, adaptive = FALSE,
                 shapefile = Berlin, gridsize = 325, boundary = TRUE)}

# Plot Density over Area:
\dontrun{breaks <- seq(1E-16,max(Est$Mestimates$estimate),length.out = 20)
image.plot(x=Est$Mestimates$eval.points[[1]],y=Est$Mestimates$eval.points[[2]],
          z=Est$Mestimates$estimate, asp=1, breaks = breaks,
          col =  colorRampPalette(brewer.pal(9,"YlOrRd"))(length(breaks)-1))
plot(Berlin, add=TRUE)}
}
