################################ CHL with argo:
#
#read in tab-delimited data:
model.data<-read.table("brt_simplification_CHL_Dargo_20181022.txt",na.strings="NaN",header=1) # ADAPT THIS FOR YOUR DATA

# Confidence intervals will be generated by randomly sub-sampling the rows of input data and generating a
# distribution model. Each model has a response function for each predictor variable (in this example,
# chl is the response variable; environmental data are the predictors - see readme file).
# In an ideal world, 1000 or more random subsamples would be taken, but if you have limited processing power
# or limited input data rows, that may not be possible. This is time-consuming, so 100 repetitions are 
# specified here.  Experiment with this, to see what suits your data and computing system.
# 
# for 100 repetitions, subsample the data, fit a model and save the fit functions:
Nreps <- 100
Nvars <- 15  ### ADAPT THIS FOR YOUR DATA
maxTrees <- 6 # max. number of steps of function development to save
fitfunctionsCHLar <- array(0,dim=c(Nvars,Nreps,maxTrees, 100))
fitfunctionsCHLarX <-array(0,dim=c(Nvars,Nreps,maxTrees, 100))

for (iRep in 1:Nreps) {

  # progress report:
  messageString <- c('Iteration: ', iRep)
  message(messageString)

  # random selection of data rows:
  Ndata <- 3884 ######### CAUTION - HARD CODED FOR CHL_A - ADAPT THIS FOR YOUR DATA
  isub <- sample.int(Ndata,Ndata/2, replace=FALSE)
  datasub <- model.data[isub,]

  par(mfrow=c(1,1))
  chl.fit <- gbm.step(data=datasub,
  gbm.x = 3:17,
  gbm.y = 2,
  family = "gaussian",
  tree.complexity = 10,
  learning.rate = 0.001,
  bag.fraction = 0.7,
   )

  # Pull out the fitted functions for each predictor and save,
  # including development as trees are added, for added insight (some
  # response functions stabilise much faster than others):
  Nvars=length(chl.fit$contributions$var)
  Ntrees = chl.fit$n.trees
  treeStep <- as.integer(Ntrees/5)
  treeIndex <- matrix(nrow=1, ncol=6)

  for (tmpI in 1:5) {
     treeIndex[tmpI] <- (tmpI-1)*treeStep + 1
  }
  treeIndex[6] <- Ntrees

  for (iVar in 1:Nvars) {
     for (iTree in 1:maxTrees)  {
  tmpmatrix <- plot.gbm(chl.fit,i.var=iVar, n.trees=treeIndex[iTree], return.grid=TRUE)
  fitfunctionsCHLar[iVar,iRep,iTree,] <- tmpmatrix[,2]
  fitfunctionsCHLarX[iVar,iRep,iTree,] <- tmpmatrix[,1]
     }
  }
}

## In the next step, 95% confidence intervals are calculated for each response function based
#  on the 100 repeat model creations. Each response function has a CI95 value for each interval
# of the response variable space (the range of values that the response variable takes, in this dataset).
#  If you change Nreps, edit line 80.

# Loop through vars and 100 predictor steps to get mean, se=sd/31.6 and dump each to file.
chlMeanFit <- array(0,dim=c(Nvars, 100))  # output mean fit at 100 pred.values
chlSEFit <- array(0,dim=c(Nvars,100))     # output standard error of fit
chlMeanFitX <- array(0,dim=c(Nvars,100))  # output x values

for (iVar in 1:Nvars) {
  subset <- fitfunctionsCHLar[iVar,,maxTrees,]
  subset2 <- fitfunctionsCHLarX[iVar,,maxTrees,]

  for (iPos in 1:100)  {
 
      chlMeanFit[iVar, iPos] <- mean(subset[,iPos])
      chlSEFit[iVar, iPos] <- sd(subset[,iPos])/10 # sqrt(N) = sqrt(100)=10
      chlMeanFitX[iVar, iPos] <- mean(subset2[,iPos])
  }
}

# Additional loop to get 5 development stages as trees are being added:
chlMeanFitDEV <- array(0,dim=c(Nvars,maxTrees-1,100))
chlSEFitDEV <- array(0,dim=c(Nvars,maxTrees-1,100))
chlMeanFitDEVX <- array(0,dim=c(Nvars,maxTrees-1,100))

for (iVar in 1:Nvars) {
for (iTree in 1:(maxTrees-1)) {
subset <- fitfunctionsCHLar[iVar,,iTree,]
subset2 <- fitfunctionsCHLarX[iVar,,iTree,]
for (iPos in 1:100) {
chlMeanFitDEV[iVar,iTree,iPos] <-mean(subset[,iPos])
chlSEFitDEV[iVar,iTree,iPos] <-mean(subset[,iPos])/10 #sqrt(N)=10
chlMeanFitDEVX[iVar,iTree,iPos] <-mean(subset2[,iPos])
    }
  }
}


# Write out arrays (15 vars x 100 columns):
write.table(chlMeanFit, file="brt_D20181027_15CHL_argo_CI_allVars.txt", append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")
write.table(chlMeanFitX, file="brt_D20181027_15CHL_argo_CI_allVarsX.txt", append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")
write.table(chlSEFit, file="brt_D20181027_15CHL_argo_CI_allVarsSE.txt", append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")

# Write out development arrays (15 vars x 5 stages x 100 columns):
for (iTree in 1:5) {
  fname <- sprintf('%s%d%s','brt_D20181027_15CHL_argo_CImean_tree_', iTree, '.txt')
  write.table(chlMeanFitDEV[,iTree,],file=fname,append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")

  fname <- sprintf('%s%d%s','brt_D20181027_15CHL_argo_CIse_tree_', iTree, '.txt')
  write.table(chlSEFitDEV[,iTree,],file=fname,append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")

  fname <- sprintf('%s%d%s','brt_D20181027_15CHL_argo_CIx_tree_', iTree, '.txt')
  write.table(chlMeanFitDEVX[,iTree,],file=fname,append=FALSE, col.names=FALSE, quote=FALSE, sep="  ")
}

# The response functions can be plotted in R, but I prefer Matlab for this step (see third project file).
