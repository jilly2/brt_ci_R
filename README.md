# brt_ci_R
Extracting data to construct confidence intervals for species distribution models (Elith et al. 2008; Boosted Regression Trees brt), in R

Boosted regression trees, or gradient-boosting regression models, provide a way to explore 
presence/absence (or similar metrics of the distribution) of a species of interest, in relation 
to environmental variables, and construct species distribution models. See Elith, Leathwick & 
Hastie (2008; 'ELH'; doi: 10.1111/j.1365-2656.2008.01390.x), and references therein, for an introduction.

This code uses the original brt functions, in the coding langauge R, provided by ELH, and illustrates 
a) how to calculate confidence intervals around the response functions for each environmental driver variable;
b) how to pull out the response functions as the BRT model develops.

The example R code goes as far as exporting the response functions to text files, to be plotted in your 
visualisation software of choice.
 
More recent brt code provides the functionality of a) with automated plotting which is not covered here. 
The functionality of b) is very useful to understand the stability of the response functions to each 
environmental driver, giving insight into the data space.

This project includes 1 R script, 1 example data file and 1 example of Matlab code to visualise the results.

Data are drawn from the public-domain ARGO float database (Coriolis database: )
Remote sensing data are drawn from NASA repositories (see Schwarz 2020, doi:10.1016/j.jenvman.2020.111308, for a full list).
 
The code is developed from the gbm library of Elith et al., by Schwarz;
The data were compiled by Schwarz (Remote sensing seascapes as predictors of surface biomass and PIC; 
paper in prep).

To adapt the code for your own data, the most important step is to change 
1. the input file name and
2. the column numbers in the call to gbm.fit

The example data file comprises (all data are standardised, except row-number):
### Column 1: Sequential row numbers;
### Column 2: Continuous response variable = chl-a concentration from NASA MODIS-Aqua (level 2 data) extracted at Argo float locations over the period 2003 to 2016
### Column 3: Mixed layer depth (derived from ARGO float data - Holte et al. 2017, doi:10.1002/2017GL073426)
### Column 4: Salinity anomaly (ARGO)
### Column 5: Water depth (ETOPO 1; Amante & Eakins, 2009; https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/docs/ETOPO1.pdf)
### Column 6: Julian day
### Column 7: Sea surface temperature omaly (deg.C, relative to daily climatology 2003-2016; MODIS-Aqua)
### Column 8: Lateral SST gradient
### Column 9: Change in SST per day (static pixels)
### Column 10: Wind speed anomaly (relative to daily climatogolgy 2003-2016; Quikscat and ASCAT)
### Column 11: Photosynthetically-available radiation PAR (MODIS-Aqua)
### Column 12: Vertical Ekman pumping velocity w (calculated from wind stress curl and ARGO water density)
### Column 13: Lateral Ekman forcing M (calculated from wind stress and ARGO water density)
### Column 14: Eddy kinetic energy EKE (calculated from geostrophic currents; AVISO/CMEMS altimetry products)
### Column 15: Absolute geostrophic current velocity (calculated from geostrophic currents)
### Column 16: Rossby number (calculated from geostrophic currents)
### Column 17: 7 day cumulative PAR (MODIS-Aqua)

