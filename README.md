## ePowerLI
Power analysis

## Installation
```
install.packages("devtools") # devtools must be installed first

devtools::install_github("SharonLutz/ePowerLI")
```

## Input
For n subjects, the number of SNPs X inputted by the user (input: nSNP) are generated from binomial distributions with minor allele frequency specified by the user (input: MAF). The environmental factor Z is generated from a normal distribution with mean and variance inputted by the user. The outcome Y is generated from a normal distribution with mean as follows:

E\[Y\] = &beta;<sub>0</sub> + &beta;<sub>z</sub> Z + &sum;<sub>j</sub>  &beta;<sub>x</sub> X<sub>j</sub> + &beta;<sub>I</sub>   &sum;<sub>j</sub> X<sub>j</sub>  Z  

for j=1,...,k where k= the number of SNPs.    

See the manpage for more detail regarding the input of the gxeRC function.

```
library(ePowerLI)
?ePowerLI # For details on this function
```

## Example
For 5,000 subjects, 3 SNPs X with MAF of 0.05, 0.01, and 0.005, respectively, and a normally distributed environmental factor Z, we generated the power for the SNP by environment interaction on the outcome Y for each SNP independently and for the joint interaction using the following commands.

```
library(ePowerLI)
ePowerLI(nSim=50,visits=3,n=c(560,563,295),x1mean=c(8.8,12.8,16.8),
x1sd=c(2.1,2.2,2.9),x2mean=c(-0.1,0,0.1),x2sd=c(0.5,0.4,0.5),
beta1=c(-0.002),beta2=c( 0.06),betaI=seq(from=-0.004,to=-0.02,length.out=10),
Sigma=matrix(c(0.1,0.07,0.07,0.07,0.1,0.07,0.07,0.07,0.1),nrow=3,ncol=3,byrow=T),
alpha=0.05,plot.pdf=T,plot.label="2-hydroxyglutarate",
plot.name=paste("powerCAMP2hydroxyglutarate.pdf",sep=""),seed=1)	
```

## Output
For this example, we get the following matrix and corresponding plot which output the type 1 error rate (row 1 of the matrix) and the power (row 2 and 3 of the matrix) to detect the SNP by environment interaction on the outcome. We can see from the plot below that we have the most power in this scenario when the SNP by environment interaction is tested for all 3 SNPs instead of for each SNP individually.

```
      lmX1  lmX2  lmX3 lmAll
[1,] 0.016 0.015 0.020 0.052
[2,] 0.095 0.030 0.017 0.154
[3,] 0.439 0.091 0.045 0.578
```
<img src="https://github.com/SharonLutz/gxeRC/blob/master/gxeRC.png" width="600">

## References
The power analysis used here was implemented in the following manuscript: <br/>

