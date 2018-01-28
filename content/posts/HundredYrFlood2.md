---
title: 100-Year Flood Part 2
author: Maazin Ansari
date: 2018-01-12
slug: 100-yr-flood-2
lang: en
category: Statistics
tags: R 
summary: Simulations of flood counts
output: html_document
---






In Part 1, I estimated $v$, the value of the 100-year flood for Blackstone River in Woonsocket, RI. The result using maximum likelihood estimation was 17754 $\text{ft}^3/\text{s}$. What does that mean, and is it accurate? 

# Background

This article is based on [this series of  posts](https://tonyladson.wordpress.com/2015/06/07/the-100-year-flood/) by Tony Ladson. They are really easy to follow if you don't have much experience with hydrology, probability, or R.

The value of the 100-year flood was calculated to be 17754. This can be worded in different ways:

- In a single year, there is a 1% chance the discharge of the largest flood will exceed 17754.
- In a 100-year period, the discharge is *expected* to be (or exceed) 17754 in one of the years.
- A flood with a discharge of at least 17754 $\text{ft}^3/\text{s}$ is *expected* to occur once in a hundred years.

It's not accurate to say the 100-year flood *will* occur once every 100 years. The important word is *expected*. In a 100-year period, it's possible for zero 100-year floods to occur. It's also possible 37 100-year floods occur.

# Number of 100-year floods in 37 years


```r
plot(floods, type = "h", lwd = 2)
title("Largest floods
      of the Blackstone River
      1929-1965", cex = 0.75)
abline(h = v_mle, col = "red")
```

![center](/static/HundredYrFlood2/time-plot2-1.png)


Looking at our original data, the 100-year flood was exceeded once in the 37-year period. How likely is it to have exactly one such flood in a 37-year period? We aren't considering the volume of the flood. That is, we aren't asking how likely it is to have a flood with a discharge of 32900 (the maximum), or what discharge is expected. We are only concerned with how many are expected to occur in a random 37-year period.

## Expectation

The number of 100-year floods $X$ in a $n$-year period follows a binomial distribution:

$$
P(X=k)= {n \choose k}p^k(1-p)^{n-k}
$$

Here $n=37$ (number of years) and $p=0.01$ (Defined in Part 1 as $P(D \geq v)$). The number of floods (or number of years where the 100-year flood occurs) $k$ can be any number from 0 to 37, as the flood can occur 0, 1, 2,..., or 37 times in a 37-year period.

Since $n$ is large (37) and $p$ is small (0.01) we can approximate the binomial distribution with a Poisson distribution.

$$
P(X=k) = \frac{e^{-\lambda}\lambda^k}{k!}
$$

Here the parameter $\lambda$ is approximated with $np = 37\times0.01=0.37$.
With this approximation, $k$ can be larger than 37, but the probabilities will be so small they're essentially 0.


```r
# P(X = 38)
dpois(x = 38, lambda = 1)
```

```
## [1] 7.03372e-46
```

## Simulation

Knowing the log-normal distribution, we can simulate 37 years of flooding to see if it matches our result and what we expect.

### Count simulation

We can simulate the number of 100-year floods occuring in a 37-year period by simulating binomial and Poisson processes 1000 times.


```r
set.seed(2018)
N = 1000
# Binomial
bFloods = rbinom(n = N, size = 37, prob = 0.01)
b_table = table(bFloods)/N ; b_table
```

```
## bFloods
##     0     1     2     3     4 
## 0.697 0.257 0.038 0.007 0.001
```

```r
# Poisson
pFloods = rpois(n = N, lambda = 37*0.01)
p_table = table(pFloods)/N ; p_table
```

```
## pFloods
##     0     1     2     3     4 
## 0.696 0.258 0.039 0.006 0.001
```

### Log-normal simulation

Another way to simulate the number of 100-year floods is to simulate 37-year periods and count how many floods exceed 17754. This involves an extra step compared to the previous method, and I'm only doing it for demonstration.

Let's start with a matrix to store simulations of flood discharges. Each column is a simulation (1000 total) and each row will represent a year of flooding (37 total). 


```r
N = 1000
m = replicate(n = N, expr = rlnorm(n = 37, meanlog = mu_hat, sdlog = sigma_hat)) %>% as.matrix
```

Now, let's count how many 100-year floods occured in the 1000 37-year periods. In other words, for each column (simulation), how many rows (years) exceed 17754? Then we'll make a table to see how frequent the counts are.


```r
sim_counts = apply(X = m, # apply to the matrix m
                   MARGIN = 2, # for each column...
                   FUN = function(x) sum(x > v_mle)) # ...count the number of years > v_mle
sim_table = table(sim_counts)/N; sim_table
```

```
## sim_counts
##     0     1     2     3     4 
## 0.677 0.261 0.050 0.011 0.001
```

The following graph compares the expected probabilities and the simulated probabilities. The red and blue bars show the expected and simulated counts, respectively. The yellow bars show the counts using simulated floods. 

![center](/static/HundredYrFlood2/unnamed-chunk-5-1.png)

In a 37-year period, it's much more likely to have zero 100-year floods than to have one. Still, the probability of exactly one is high, about 26%.

Method                     | Probability of exactly 1 100-year flood in 37 years
---------------------------|-----------------------------------------------------
Expected Binomial Counts   | 0.25767
Simulated Binomial Counts  | 0.257
Expected Poisson  Counts   | 0.25557
Simulated Poisson Counts   | 0.258
Counts of Simulated Floods | 0.261




# References

Ladson, Tony. "The 100 year flood." *tonyladson | Hydrology, Natural Resources and R*. June 7, 2015. https://tonyladson.wordpress.com/2015/06/07/the-100-year-flood/.

https://water.usgs.gov/edu/100yearflood.html

https://water.usgs.gov/edu/100yearflood-basic.html

