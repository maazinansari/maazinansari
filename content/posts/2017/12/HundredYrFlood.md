---
title: "Hundred Year Flood"
author: "Maazin Ansari"
date: 12/25/2017
output:
  html_document: default
---

# Parameter Estimation

From Problem 6 in 

Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.

River floods are often measured by their discharges (ft^3/s)
The value $v$ is said to be the value of a 100-year flood if $P(D \geq v) = 0.01$
where D is the discharge of the largest flood in a randomly selected year

HundredYrFlood.csv gives the flood discharges of the largest floods of the
Blackstone River in Woonsocket, RI, in each year from 1929 to 1965.

Assuming that these discharges follow a log-normal distribution, estimate the value of a 100-year flood.

```{r}
floods = read.csv("HundredYrFlood.csv")
plot(floods, type = "h", lwd = 2)
```

Largest flood $D \sim \text{Pois}(\lambda = L)$

$P(D \geq v) = 0.01$ and $P(D <  v) = 0.99$

## Distribution of discharges

```{r}
hist(floods[["discharge"]], nclass = 25, freq = TRUE, xlab = "discharge", main = "")
```

## Log normal distribution

This section shows how I estimate the parameters for the log normal distribution. I am using maximum likelihood estimators.

$$f(x) = \frac{1}{x\sigma\sqrt{2π}} \exp\Big(-\frac{(\ln x - \mu)^2}{2 \sigma^2}\Big)$$

### Maximum likelihood estimates

The paper by Brenda F. Ginos (reference below) shows how to derive $\hat{\mu}$ and $\hat{\sigma}^2$ analytically.

MLE of $\mu$

$$
\hat{\mu}=\frac{\sum_i^n \ln x_i}{n} = \bar{\ln x_i}
$$

```{r}
mu_hat = mean(log(floods$discharge))
```

MLE of $\sigma^2$

$$
\hat{\sigma}^2 = \frac{\sum_i^n (\ln x_i - \hat{\mu})^2}{n}
$$

```{r}
library(magrittr)
sigma_hat = (log(floods$discharge) - mu_hat)^2 %>% mean %>% sqrt
```

### Empirical distribution

```{r}
hist(floods[["discharge"]], nclass = 25, freq = FALSE, xlab = "discharge", main = "")
curve(dlnorm(x, meanlog = mu_hat, sdlog = sigma_hat),
      from = 0, to = 30000,
      ylab = "f(x)",
      add = TRUE)
```

Now that we know the distribution of discharges, we can determine the value $v$ for which $P(D \geq v) = 0.01$

$P(D \geq v) = 0.01$ and $P(D <  v) = 0.99$

```{r}
v = qlnorm(p = 0.99, meanlog = mu_hat, sdlog = sigma_hat)
v
```

```{r}
curve(dlnorm(x, meanlog = mu_hat, sdlog = sigma_hat),
      from = 0, to = 30000,
      ylab = "f(x)")
abline(v = v, col = "blue")
```

Largest flood $D \sim \text{Pois}(\lambda = L)$

# Predictions

The following code is based on [this series of  posts](https://tonyladson.wordpress.com/2015/06/07/the-100-year-flood/) by Tony Ladson. These posts are really easy to follow if you don't have much experience with hydrology, probability, or R.

### Number of 100-year floods in 100 years

```{r}
N = 95
```

`r N` random simulations

```{r}
# Binomial
bFloods = rbinom(n = N, size = 100, prob = 0.01)
# Poisson
pFloods = rpois(n = N, lambda = 100*0.01)
```

```{r, echo = FALSE}
df_binom = rbind(table(bFloods),
                 dbinom(0:max(bFloods), size = 100, prob = 0.01) * N)
df_pois = rbind(table(pFloods),
                dpois(0:max(pFloods), lambda = 100*0.01) * N)

col_sim = rgb(224,236,244, maxColorValue = 255)
col_exp = rgb(254,224,210, maxColorValue = 255)

par(mfrow = c(1,2))
barplot(df_binom,
        main = "Binomial",
        ylim = c(0,N/2),
        beside = TRUE,
        legend = c("Simulated", "Expected"), 
        xlab = "Number of 100 year floods",
        col = c(col_sim, col_exp))
barplot(df_pois,
        main = "Poisson",
        ylim = c(0,N/2),
        beside = TRUE,
        legend = c("Simulated", "Expected"), 
        xlab = "Number of 100 year floods",
        col = c(col_sim, col_exp))
```

### Probability of exactly one 100-year flood in 100 years
```{r}
# Binomial
p_1_binomial = dbinom(x = 1, size = 100, prob = 0.01)
# Poisson
p_1_poisson = dpois(x = 1, lambda = 100*0.01)
```

Binomial         | Poisson
-----------------|----------------
`r p_1_binomial` | `r p_1_poisson`


# References

Ginos, Brenda Faith, "Parameter Estimation for the Lognormal Distribution" (2009). *All Theses and Dissertations*. 1928.
http://scholarsarchive.byu.edu/etd/1928

Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.

Ladson, Tony. "The 100 year flood." *tonyladson | Hydrology, Natural Resources and R*. June 7, 2015. https://tonyladson.wordpress.com/2015/06/07/the-100-year-flood/.
