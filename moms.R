
setwd('/mnt/snelson/flight')
require(ggplot2)
library(tm)
library(distrom)
install.packages("devtools")
library(devtools)
install.packages("quanteda")
devtools::install_github("kbenoit/quanteda")
library(quanteda)
library(Matrix)

## read in data (orig queried from Vertica)
moms<-read.csv('moms.csv', stringsAsFactors=FALSE)
X<-factor(moms$region_desc)
length(X)

## dtm was created in Python and exported to a Market Matrix file. 
## read it in
dtm<-readMM('X.mtx')

## run dmr
sparseDTM <- sparseMatrix( i = dtm$i, j=dtm$j, x =dtm$v)
dim(sparseDTM)
sparseX <- sparseMatrix(i=1:length(X), j=unclass(X),x=rep(1,length(X)) )
sparseX <- sparseX[,colSums(sparseX)!=0]
dim(sparseX)
fit<-dmr(cl=NULL, covars=sparseX, counts=dtm, verb=1)


## Individual Poisson model fits and AICc selection
par(mfrow=c(5,1))
par(mar = rep(1, 4))
for(j in 1:5){
  plot(fit[[j]])
  mtext(names(fit)[j],font=2,line=2) }

##CA vs CO; CA=8, CO=9
par(mfrow=c(1,1))
B <- coef(fit)
dim(B)
state_coefs<-t(B[2:nrow(B),])
dim(state_coefs)
df<-data.frame(matrix(state_coefs, 
                      nrow=dim(state_coefs)[1], 
                      ncol=dim(state_coefs)[2]),
               row.names=freq_terms)
colnames(df)<-levels(X)
dim(df)

plot_df<-df[df$CA>0 & df$CO>0,]
ggplot(plot_df, aes(CA,CO)) + geom_point() + 
  geom_text(aes(label=row.names(plot_df)))

plot_df<-df[df$CA>0 & df$NY>0,]
ggplot(plot_df, aes(CA,NY)) + geom_point() + 
  geom_text(aes(label=row.names(plot_df)))


# plotit<-function(x,y, df){
#   
#   df<-df[df$x>0 & df$y>0,]
#   ggplot(df, aes(x,y)) + geom_point() + 
#     geom_text(aes(label=row.names(df)))
# }
# plotit(CA, CO, df)


