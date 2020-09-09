
# Inspired by question from "rie" on Git Gud Science discord server

# TO-DO ########################################################################

# ::: p1
# allow for sampling of units and show how regression slope changes aross samples

library(MASS)

tri.data <- function(n, rho_xc)
  {
  # Generate new data for triangular, three-variable DAG with two paths:
  # X <- C -> Y
  # X -> Y
  
  # n..........number of units
  # rho_xc.....desired correlation between X & C
  
  # define predictors
  c <- rnorm(n)            # C: confounder
  x_e <- rchisq(n, df = 1) # X's error term

  # find proper scaling factor for X's error such that we get rho_xc
  sf_vec <- seq(1, 8, 0.05) # range of possible scaling factors
  rho_vec <- sapply(sf_vec, function(z){
    x <- c + x_e/(z*sd(x_e))
    round(cor(c, x), 2)
  })

  # scaling factor for x_e such that we get cor(x, c) = rho_xc
  sf <- sf_vec[match(rho_xc, rho_vec)]
  
  # create X as sum of c + scaled x_e
  x <- c + x_e/(sf*sd(x_e))
  
  # create Y as weighted sum of x, c, and normal error
  y <- 2*x + 3*c + rnorm(n, sd = 5)
  
  # create data frame of c, x, & y
  data.frame(c, x, y)
}

dat <- tri.data(100, 0.9)

cor(dat)

with(dat, plot(x=x, y=c))
with(dat, plot(x=c, y=y))
with(dat, plot(x=x, y=y))

lm_yx <- lm(y ~ x, dat)
lm_yc <- lm(y ~ c, dat)
lm_ycx <- lm(y ~ x + c, dat)
lm_xc <- lm(x ~ c, dat)

summary(lm_yx)$coef["x", 1:2]
summary(lm_yc)$coef["c", 1:2]
summary(lm_ycx)$coef[c("x", "c"), 1:2]

# compare X vs Y & X | C vs Y
lm_yx_c <- lm(dat$y ~ lm_xc$residuals)
with(dat, plot(x=x, y=y))
points(x=lm_xc$residuals, y= dat$y, col = 'red')
summary(lm_yx_c)
abline(lm_ycx)
abline(lm_yx_c, col = 'red')

