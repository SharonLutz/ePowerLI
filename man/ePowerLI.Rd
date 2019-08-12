\name{ePowerLI}
\alias{ePowerLI}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
ePowerLI(nSim = 500, visits = 3, n = c(560, 563, 295), x1mean = c(8.8, 12.8, 16.8), x1sd = c(2.1, 2.2, 2.9), x2mean = c(-0.09, 0.02, 0.13), x2sd = c(0.4, 0.4, 0.4), beta1 = c(-0.01), beta2 = c(0.06), betaI = c(-0.004, -0.01, -0.02), Sigma = matrix(c(0.1, 0.07, 0.07, 0.07, 0.1, 0.07, 0.07, 0.07, 0.1), nrow = 3, ncol = 3, byrow = T), alpha = 0.05, plot.pdf = T, plot.label = "", plot.name = "powerLIplot.pdf", seed = 1)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nSim}{
%%     ~~Describe \code{nSim} here~~
}
  \item{visits}{
%%     ~~Describe \code{visits} here~~
}
  \item{n}{
%%     ~~Describe \code{n} here~~
}
  \item{x1mean}{
%%     ~~Describe \code{x1mean} here~~
}
  \item{x1sd}{
%%     ~~Describe \code{x1sd} here~~
}
  \item{x2mean}{
%%     ~~Describe \code{x2mean} here~~
}
  \item{x2sd}{
%%     ~~Describe \code{x2sd} here~~
}
  \item{beta1}{
%%     ~~Describe \code{beta1} here~~
}
  \item{beta2}{
%%     ~~Describe \code{beta2} here~~
}
  \item{betaI}{
%%     ~~Describe \code{betaI} here~~
}
  \item{Sigma}{
%%     ~~Describe \code{Sigma} here~~
}
  \item{alpha}{
%%     ~~Describe \code{alpha} here~~
}
  \item{plot.pdf}{
%%     ~~Describe \code{plot.pdf} here~~
}
  \item{plot.label}{
%%     ~~Describe \code{plot.label} here~~
}
  \item{plot.name}{
%%     ~~Describe \code{plot.name} here~~
}
  \item{seed}{
%%     ~~Describe \code{seed} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (nSim = 500, visits = 3, n = c(560, 563, 295), x1mean = c(8.8, 
    12.8, 16.8), x1sd = c(2.1, 2.2, 2.9), x2mean = c(-0.09, 0.02, 
    0.13), x2sd = c(0.4, 0.4, 0.4), beta1 = c(-0.01), beta2 = c(0.06), 
    betaI = c(-0.004, -0.01, -0.02), Sigma = matrix(c(0.1, 0.07, 
        0.07, 0.07, 0.1, 0.07, 0.07, 0.07, 0.1), nrow = 3, ncol = 3, 
        byrow = T), alpha = 0.05, plot.pdf = T, plot.label = "", 
    plot.name = "powerLIplot.pdf", seed = 1) 
{
    set.seed(seed)
    require(nlme)
    require(MASS)
    tol <- .Machine$double.eps^0.5
    if (abs(visits - round(visits)) > tol) {
        stop("Visits is not an integer")
    }
    if (abs(nSim - round(nSim)) > tol) {
        stop("The number of simulations nSim is not an integer")
    }
    if (length(n) != visits) {
        stop("Length of vector n does not match the number of visits")
    }
    if (length(x1mean) != visits) {
        stop("Length of vector x1mean does not match the number of visits")
    }
    if (length(x1sd) != visits) {
        stop("Length of vector x1sd does not match the number of visits")
    }
    if (length(x2mean) != visits) {
        stop("Length of vector x2mean does not match the number of visits")
    }
    if (length(x2sd) != visits) {
        stop("Length of vector x2sd does not match the number of visits")
    }
    if (length(beta1) != 1) {
        stop("Length of vector beta1 should be 1")
    }
    if (length(beta2) != 1) {
        stop("Length of vector beta2 should be 1")
    }
    if (!is.matrix(Sigma)) {
        stop("Sigma needs to be a square matrix")
    }
    if (nrow(Sigma) != visits) {
        stop("The number of rows of the square matrix Sigma does not match the number of visits")
    }
    if (ncol(Sigma) != visits) {
        stop("The number of columns of the square matrix Sigma does not match the number of visits")
    }
    matR <- matrix(0, nrow = 1, ncol = length(betaI))
    colnames(matR) <- paste("betaI", betaI, sep = "")
    for (ns in 1:nSim) {
        np <- 50
        if (floor(ns/np) == ceiling(ns/np)) {
            print(paste("Simulations", ns, "in", nSim))
        }
        for (bb in 1:length(betaI)) {
            if (visits > 1) {
                Y <- matrix(NA, nrow = max(n), ncol = visits)
                p1 <- matrix(NA, nrow = max(n), ncol = visits)
                p2 <- matrix(NA, nrow = max(n), ncol = visits)
                for (ss in 1:max(n)) {
                  phen1 <- rnorm(visits, x1mean, x1sd)
                  p1[ss, ] <- phen1
                  phen2 <- rnorm(visits, x2mean, x2sd)
                  p2[ss, ] <- phen2
                  meanY <- phen1 * beta1 + phen2 * beta2 + (phen1 * 
                    phen2) * betaI[bb]
                  Y[ss, ] <- mvrnorm(1, meanY, Sigma)
                }
                for (ee in 1:visits) {
                  nn <- n[ee]
                  ne <- max(n) - nn
                  if (ne > 0) {
                    re <- sample(c(1:max(n)), size = ne)
                    Y[re, ee] <- NA
                    p1[re, ee] <- NA
                    p2[re, ee] <- NA
                  }
                }
                subject <- matrix(rep(c(1:max(n)), each = visits), 
                  nrow = max(n) * visits, ncol = 1)
                Ylong <- matrix(as.vector(t(Y)), nrow = max(n) * 
                  visits, ncol = 1)
                P1long <- matrix(as.vector(t(p1)), nrow = max(n) * 
                  visits, ncol = 1)
                P2long <- matrix(as.vector(t(p2)), nrow = max(n) * 
                  visits, ncol = 1)
                matA <- cbind(subject, Ylong, P1long, P2long)
                colnames(matA) <- c("subject", "y", "x1", "x2")
                matA <- data.frame(matA)
                randomIntercept <- lme(y ~ x1 + x2 + x1 * x2, 
                  random = ~1 | subject, data = matA, na.action = na.omit)
                if (summary(randomIntercept)$tTable[nrow(summary(randomIntercept)$tTable), 
                  "p-value"] < alpha) {
                  matR[1, bb] <- matR[1, bb] + 1
                }
            }
            if (visits == 1) {
                x1 <- rnorm(n, x1mean, x1sd)
                x2 <- rnorm(n, x2mean, x2sd)
                meanY <- x1 * beta1 + x2 * beta2 + (x1 * x2) * 
                  betaI[bb]
                y <- rnorm(n, mean = meanY, sd = sqrt(Sigma))
                lm1 <- lm(y ~ x1 + x2 + x1 * x2)
                if (summary(lm1)$coef[nrow(summary(lm1)$coef), 
                  4] < alpha) {
                  matR[1, bb] <- matR[1, bb] + 1
                }
            }
        }
    }
    results <- matR/nSim
    if (plot.pdf == T) {
        pdf(plot.name)
        plot(betaI, results[1, ], xlab = expression(beta), ylab = "Power", 
            main = plot.label, type = "b")
        dev.off()
    }
    results
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
