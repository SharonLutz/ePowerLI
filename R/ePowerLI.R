

############################################################################
# Function 
############################################################################
	
ePowerLI<-function(nSim=500,visits=3,n=c(560,563,295),x1mean=c(8.8,12.8,16.8),x1sd=c(2.1,2.2,2.9), x2mean=c(-0.09,0.02,0.13),x2sd=c(0.4,0.4,0.4),beta1=c(-0.01),beta2=c(0.06),betaI=c(-0.004,-0.01,-0.02),Sigma=matrix(c(0.1,0.07,0.07,0.07,0.1,0.07,0.07,0.07,0.1),nrow=3,ncol=3,byrow=T),alpha=0.05,plot.pdf=T,plot.label="",plot.name="LIplot.pdf",seed=1){

######################################
# Inputs
######################################
# nSim= number of simulations
# visits =number of study visits
# n = a vector of the number of subjects at each visit
# x1mean is the mean of x1 at each visit
# x1sd is the sd of x1 at each visit
# x2mean is the mean of x2 at each visit
# x2sd is the sd of x2 at each visit
# beta1= vector of the main effects for x1 at each visit on the outcome Y
# beta2= vector of the main effects for x2 at each visit on the outcome Y
# betaI =the vector of effect sizes for the interaction of x1 and x2 on the normally distributed outcome for a range of values (usually at least 2)
# Sigma is the variance covariance matrix for the outcome Y
# plot.pdf=T then the function will produce a plot in the working directory

######################################
# Set seed
######################################	
set.seed(seed)

######################################
# Load the needed libraries
######################################
require(nlme) # for lme
require(MASS) # for mvrnorm

######################################
# Error checking
######################################	
tol <- .Machine$double.eps^0.5    
if(abs(visits - round(visits)) > tol){stop("Visits is not an integer")}	
if(abs(nSim - round(nSim)) > tol){stop("The number of simulations nSim is not an integer")}	

if(length(n)!=visits){stop("Length of vector n does not match the number of visits")}
 
if(length(x1mean)!=visits){stop("Length of vector x1mean does not match the number of visits")}
if(length(x1sd)!=visits){stop("Length of vector x1sd does not match the number of visits")}

if(length(x2mean)!=visits){stop("Length of vector x2mean does not match the number of visits")}
if(length(x2sd)!=visits){stop("Length of vector x2sd does not match the number of visits")}

if(length(beta1)!=1){stop("Length of vector beta1 should be 1")}
if(length(beta2)!=1){stop("Length of vector beta2 should be 1")}
  
if(!is.matrix(Sigma)){stop("Sigma needs to be a square matrix")}
if(nrow(Sigma)!=visits){stop("The number of rows of the square matrix Sigma does not match the number of visits")}
if(ncol(Sigma)!=visits){stop("The number of columns of the square matrix Sigma does not match the number of visits")}
#check sigma is positive definite 
# make sure the covariance is less than the max variance 
  
######################################
# Store results
######################################
matR<-matrix(0,nrow=1,ncol=length(betaI))
colnames(matR)<-paste("betaI",betaI,sep="")

######################################
# Loop through the nSim # of simulations
######################################
for(ns in 1:nSim){
	
	np<-50
if(floor(ns/np)==ceiling(ns/np)){print(paste("Simulations",ns,"in",nSim))}

######################################
# Loop through betaI vector
######################################
for(bb in 1:length(betaI)){

######################################		
#LME (visits>1)	
######################################	
if(visits>1){
		
######################################
# Generate the data for LME (visits>1)
######################################
#create a matrix to store the outcome Y
Y<-matrix(NA,nrow=max(n),ncol=visits)
p1<-matrix(NA,nrow=max(n),ncol=visits)
p2<-matrix(NA,nrow=max(n),ncol=visits)

 for(ss in 1:max(n)){
 	#simulate phenotype 1 (x1) for each subject
 	phen1<-rnorm(visits,x1mean,x1sd)
 	p1[ss,]<-phen1
 	
 	#simulate phenotype 2 (x2) for each subject
 	phen2<-rnorm(visits,x2mean,x2sd)
 	p2[ss,]<-phen2
 	
 	#mean of Y 	
 	meanY<-phen1*beta1+phen2*beta2+(phen1*phen2)*betaI[bb]
 	
    # Simulate Y from a multivariate normal distribution
    Y[ss,] <- mvrnorm(1, meanY, Sigma)
    }

# exclude subjects that were not at each visit
for(ee in 1:visits){
	nn<-n[ee]
	ne<-max(n)-nn
	#rows to exclude
	if(ne>0){
	re<-sample(c(1:max(n)),size=ne)
	Y[re,ee]<-NA
	p1[re,ee]<-NA
	p2[re,ee]<-NA
	}
}

######################################
# Format data for LME (visits>1)
######################################

subject<-matrix(rep(c(1:max(n)),each=visits),nrow=max(n)*visits,ncol=1)
Ylong<-matrix(as.vector(t(Y)),nrow=max(n)*visits,ncol=1)
P1long<-matrix(as.vector(t(p1)),nrow=max(n)*visits,ncol=1)
P2long<-matrix(as.vector(t(p2)),nrow=max(n)*visits,ncol=1)

matA<-cbind(subject,Ylong,P1long,P2long)
colnames(matA)<-c("subject","y","x1","x2")
matA<-data.frame(matA)

######################################
# Run model for LME (visits>1)
######################################
#fit random intercept model
randomIntercept<- lme(y ~ x1+x2+x1*x2, random = ~1 |subject, data = matA,na.action=na.omit)

#get p-value for interaction with exposure and age for fixed effects for this model
if(summary(randomIntercept)$tTable[nrow(summary(randomIntercept)$tTable),"p-value"]<alpha){
matR[1,bb]<-matR[1,bb]+1
}

######################################		
#End of LME (visits>1)	
######################################	
}

######################################		
# LM (visits==1)	
######################################	
if(visits==1){
		
######################################
# Generate the data for LME (visits==1)
######################################
#create a matrix to store the outcome Y
x1<-rnorm(n,x1mean,x1sd)
x2<-rnorm(n,x2mean,x2sd)
meanY<-x1*beta1+x2*beta2+(x1*x2)*betaI[bb]
y<-rnorm(n,mean=meanY,sd=sqrt(Sigma))

######################################
# Run model for LM (visits==1)
######################################
#fit linear regression for 1 visit
lm1<- lm(y ~ x1+x2+x1*x2)

#get p-value for interaction with exposure and age for fixed effects for this model
if(summary(lm1)$coef[nrow(summary(lm1)$coef),4]<alpha){	
	matR[1,bb]<-matR[1,bb]+1
}

######################################		
#End of LM (visits==1)	
######################################	
}

######################################
# End the betaI loop (index bb)
######################################
}

######################################
# End the simulations (index ns)
######################################
}

######################################
# Save results
######################################
results<-matR/nSim

######################################
# Plot results
######################################

if(plot.pdf==T){
pdf(plot.name)
plot(betaI,results[1,],xlab=expression(beta),ylab="",main=plot.label,type="b")
dev.off()	
}

######################################
# Print results
######################################
results

######################################
# End the function
######################################

}

######################################









