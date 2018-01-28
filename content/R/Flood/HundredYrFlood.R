library(magrittr)
library(fishmethods)
set.seed(20180106)
## ---- read
floods = read.csv("HundredYrFlood.csv")
n = nrow(floods)

## ---- break-1

# Maximum Likelihood Estimators ----
## ---- mu-hat
mu_hat = mean(log(floods[["discharge"]]))
## ---- sigma-hat
sigma_hat = (log(floods[["discharge"]]) - mu_hat)^2 %>% mean %>% sqrt

## ---- break-2

# Method of Moments Estimators ----
## ---- sigma-tilde
sigma_tilde = ((floods[["discharge"]]^2 %>% sum %>% log) -
    2 * (floods[["discharge"]] %>% sum %>% log) +
    log(nrow(floods))) %>%
    sqrt

## ---- mu-tilde
mu_tilde = (floods[["discharge"]] %>% sum %>% log) -
            log(nrow(floods)) - 
            (sigma_tilde)^2 / 2

## ---- break-3

# Serfling Robust Estimators ----
## ---- serfling
source("serfling.R")

serfling_estimates = serfling_estimate_1(floods[["discharge"]])
mu_hat_serf = serfling_estimates[[1]]
sigma_hat_serf = serfling_estimates[[2]]

## ---- break-4
    
# Finney Efficient Estimators ----
## ---- finney
source("finney.R")

finney_estimates = finney_estimate_1(floods[["discharge"]])
mu_hat_finney = finney_estimates[[1]]
sigma_hat_finney = finney_estimates[[2]]

## ---- break-5

# Estimating v ----
## ---- v-mle
v_mle = qlnorm(p = 0.99, meanlog = mu_hat, sdlog = sigma_hat)

## ---- v-mom
v_mom = qlnorm(p = 0.99, meanlog = mu_tilde, sdlog = sigma_tilde)

## ---- v-serf
v_serf = qlnorm(p = 0.99, meanlog = mu_hat_serf, sdlog = sigma_tilde)

## ---- v-finney
v_finney = qlnorm(p = 0.99, meanlog = mu_hat_finney, sdlog = sigma_hat_finney)

## ---- plot-functions

## ---- time-plot-v
time_plot_v = function(data, v = NULL, col = 1, lwd = 2, title = "") {
    plot(data, type = "h", lwd = 2, ylim = c(0, 35000))
    title(title, cex = 0.75)
    abline(h = v, col = col, lty = 3, lwd = lwd)
}

## ---- lnorm-plot-v
lnorm_plot_v = function(mu, sigma, v = NULL,
                        col = 1, lty = 1, lwd = 1, add = FALSE) {
    curve(dlnorm(x, meanlog = mu, sdlog = sigma),
          from = 0, to = 35000,
          ylim = c(0, 3e-4),
          ylab = "f(D)",
          xlab = "D",
          main = "Distribution of discharge",
          col = col,
          lty = lty,
          add = add)
    abline(v = v, col = col, lty = 3, lwd = lwd)
}

