## ePowerLI
An R package that performs an empirical power analysis for the interaction of 2 normally distributed traits on a multivariate normally distributed outcome in an unbalanced longitudinal study design

## Installation
devtools needs to be installed once if it has not already been installed.
```
install.packages("devtools") # devtools must be installed first
```
Then, the ePowerLI package can be installed using the following in R:
```
devtools::install_github("SharonLutz/ePowerLI")
```

## Input 
For a given number simulations (input=nSim) and time points or visits (input=visits), the number of subjects at each time point (input=n) must be specified. Then, two normally distributed traits (x1 and x2) are generated based on the user inputted mean (input=x1mean and x2mean) and standard deviation (input=x1sd and x2sd). Then, the outcome Y is generated from a multivariate normal distribution (for visits>1) or a normal distribution (for visits=1) where the mean equal to

E\[Y\] = &beta;<sub>1</sub> x1+ &beta;<sub>2</sub> x2 +  &beta;<sub>I</sub>   x1 x2  

where the main effect of x1 on Y (input=beta1) and the main effect of x2 on Y (input=beta2) are entered as a single number and the effect of the interaction (input=betaI) is entered as a vector of values to see how the power changes for various values of betaI. The variance or variance covariance matrix needs to be entered as a matrix (input=Sigma). The significance level (input=alpha) and the seed for the random number generator (input=seed) can be changed.   

Additionally, if the user wants to produce a graph of the results saved to the working directory, then use plot.pdf=T. The name of the plot (input= plot.name) and the main label for the plot can be specified (input= plot.label).

See the manpage for more detail regarding the input of the ePowerLI function.

```
library(ePowerLI)
?ePowerLI # For details on this function
```

## Output 
After the two normally distributed traits (x1 and x2) and the outcome (Y) are generated based on user input, simulations studies are used to assess the empirical power for the interaction. For more than one time point or visit (visits>1), a random intercept model is fit using the lme function in the nlme R package. For one time point or visit (visits=1), a linear regression is fit using the lm function. The power is defined as the number of simulations where the p-value for the interaction was less than the specified value (input=alpha) over the total number of simulation (input=nSim). A matrix of the results are produced and a pdf of the plot is saved to the working directory (input plot.pdf=T).

## Example 1
We want to generate the empirical power to detect the interaction between age and the metabolite 2-hydroxyglutarate on bronchodilator response (BDR) in the CAMP study for 3 time points where the number of subjects at each time point differs. 

For 500 simulations (nSim=500) and 3 time points (visits=3), the vector of the number of subjects at each time point needs to be specified (n=c(560,563,295)). Using the CAMP dataset, we get the mean age (x1mean=c(8.8,12.8,16.8)) and standard deviation (x1sd=c(2.1,2.2,2.9)) for the 3 visits. Using the CAMP dataset for the metabolite 2-hydroxyglutarate, we get the mean (x2mean=c(-0.1,0,0.1)) and standard deviation (x2sd=c(0.5,0.4,0.5)) for the 3 visits.

Then, we fit the random intercept model for the effect of age times 2-hydroxyglutarate on BDR. From this output, we got  beta1=c(-0.002), beta2=c( 0.06), and Sigma=matrix(c(0.1,0.07,0.07,0.07,0.1,0.07,0.07,0.07,0.1),nrow=3,ncol=3,byrow=T). For the interaction (input betaI), the estimate for the interaction was -0.004 so we vary the effect size from -0.004 to -0.02 (betaI=seq(from=-0.004,to=-0.02,length.out=10)) to see how the power changes for different values of betaI.

The following used to run this analysis:

```
library(ePowerLI)

ePowerLI(nSim=500,visits=3,n=c(560,563,295),x1mean=c(8.8,12.8,16.8),
x1sd=c(2.1,2.2,2.9),x2mean=c(-0.1,0,0.1),x2sd=c(0.5,0.4,0.5),
beta1=c(-0.002),beta2=c( 0.06),betaI=seq(from=-0.004,to=-0.02,length.out=10),
Sigma=matrix(c(0.1,0.07,0.07,0.07,0.1,0.07,0.07,0.07,0.1),nrow=3,ncol=3,byrow=T),
alpha=0.05,plot.pdf=T,plot.label="2-hydroxyglutarate",
plot.name=paste("powerCAMP2hydroxyglutarate.pdf",sep=""),seed=1)	 
```

## Output 1
For this example, we get the following plot for the empirical power. As the magnitude of betaI increase, the power increases.

<img src="https://github.com/SharonLutz/ePowerLI/blob/master/powerCAMP2hydroxyglutarate.png" width="400">

## Example 2
We want to generate the empirical power to detect the interaction between age and the metabolite 2-hydroxyglutarate on bronchodilator response (BDR) in the GACRS study for 1 time point. 

For 10,000 simulations (nSim=10000) and 1 time point (visits=1), the number of subjects at the one time point needs to be specified (n=c(320)). Using the GACRS dataset, we get the mean age (x1mean=c(9.1)) and standard deviation (x1sd=c(1.7)) for the 1 visit. Using the GACRS dataset for the metabolite 2-hydroxyglutarate, we get the mean (x2mean=c(0.01)) and standard deviation (x2sd=c(0.5)) for the 1 visit.

Then, we fit the linear regression for the effect of age times 2-hydroxyglutarate on BDR. From this output, we got beta1=c(0.00004), beta2=c( 0.15), and Sigma=matrix(c(0.01),nrow=1,ncol=1,byrow=T). For the interaction (input betaI), the estimate for the interaction was -0.015 so we vary the effect size from -0.015 to -0.03 (betaI=seq(from=-0.015 to=-0.03,length.out=10)) to see how the power changes for different values of betaI.

```
library(ePowerLI)

ePowerLI(nSim=10000,visits=1,n=c(320),x1mean=c(9.1),x1sd=c(1.7), x2mean=c(0.01),x2sd=c(0.5),beta1=c(0.00004),
beta2=c(0.15),betaI=seq(from=-0.015, to=-0.03,length.out=10), Sigma=matrix(c(0.01),nrow=1,ncol=1,byrow=T),alpha=0.05,plot.pdf=T,plot.label=”2-hydroxyglutarate”,plot.name=paste("powerCR2hydroxyglutarate.pdf"),seed=1)		
```

## Output 2
For this example, we get the following plot for the empirical power. As the magnitude of betaI increase, the power increases.

<img src="https://github.com/SharonLutz/ePowerLI/blob/master/ powerCRX2.hydroxyglutarate.png" width="400">


## References
The power analysis used here was implemented in the following manuscript to determine the empirical power to detect the interaction between age and 7 metabolites on BDR in the CAMP and GACRS studies: <br/>

Kelly RS, Sordillo JE, **Lutz SM**, Avila L, Soto-Quiros M, Celedón JC, McGeachie MJ, Dahlin A, Tantisira K, Huang M, Clish CB, Weiss ST, Lasky-Su J, Wu AC. Pharmacometabolomics of Bronchodilator Response in Asthma and the Role of Age-Metabolite Interactions. (Submitted).
