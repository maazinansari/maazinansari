---
title: "100-Year Flood Part 1"
author: "Maazin Ansari"
date: 2017-01-07
output:
  html_document: default
---


In this two-part post, I play around with some data in R to show the statistics behind the 100-year flood. This is mostly me following along with posts from other blogs to get familiar with R, RMarkdown, and blogging. 

In this first part, I'll show how the hundred year flood is calculated from data. In Part 2, I'll go into more detail on the 100-year flood, do some simulations, and verify our solution in Part 1.

# Parameter Estimation

The data I use here comes from Problem 6 in 

Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.

> River floods are often measured by their discharges ($\text{ft}^3/\text{s}$)
The value $v$ is said to be the value of a 100-year flood if $P(D \geq v) = 0.01$
where $D$ is the discharge of the largest flood in a randomly selected year.  

> The table below gives the flood discharges of the largest floods of the Blackstone River in Woonsocket, RI, in each year from 1929 to 1965.  

> Assuming that these discharges follow a log-normal distribution, estimate the value of a 100-year flood.


| year | discharge |
|:----:|:---------:|
| 1929 |   4750    |
| 1930 |   1970    |
| 1931 |   8220    |
| 1932 |   4530    |
| 1933 |   5780    |
| 1934 |   6560    |
| 1935 |   7500    |
| 1936 |   15000   |
| 1937 |   6340    |
| 1938 |   15100   |
| 1939 |   3840    |
| 1940 |   5860    |
| 1941 |   4480    |
| 1942 |   5330    |
| 1943 |   5310    |
| 1944 |   3830    |
| 1945 |   3410    |
| 1946 |   3830    |
| 1947 |   3150    |
| 1948 |   5810    |
| 1949 |   2030    |
| 1950 |   3620    |
| 1951 |   4920    |
| 1952 |   4090    |
| 1953 |   5570    |
| 1954 |   9400    |
| 1955 |   32900   |
| 1956 |   8710    |
| 1957 |   3850    |
| 1958 |   4970    |
| 1959 |   5398    |
| 1960 |   4780    |
| 1961 |   4020    |
| 1962 |   5790    |
| 1963 |   4510    |
| 1964 |   5520    |
| 1965 |   5300    |

The plot below displays the above table as a graph. The average discharge of the largest flood during this period is around 6,000 $\text{ft}^3/\text{s}$. There was an unusually large flood in 1955, with well over 30,000 $\text{ft}^3/\text{s}$ of discharge.


```r
plot(floods, type = "h", lwd = 2,
     main = "Largest floods of the Blackstone River")
```

<img src="/static/HundredYrFlood1/time-plot-1.png" title="center" alt="center" style="display: block; margin: auto;" />

## Distribution of discharges

The problem tells us to assume discharge follows a log-normal distribution. So, $D \sim \text{Lognormal}(\mu, \sigma)$. Two notable properties of the log-normal distribution are that it takes positive values and it is positively skewed. Looking at the histogram of discharges, we can see both are true: discharges cannot be less than 0 and high-discharge floods are much less frequent than low-discharge floods.


```r
hist(floods[["discharge"]], nclass = 25, freq = TRUE, xlab = "discharge", main = "")
```

<img src="/static/HundredYrFlood1/hist-1-1.png" title="center" alt="center" style="display: block; margin: auto;" />

The next step is to determine which log-normal distribution this data comes from. In other words, what are the parameters for this distribution.

## Log-normal distribution

$$f(x) = \frac{1}{x\sigma\sqrt{2π}} \exp\Big(-\frac{(\ln x - \mu)^2}{2 \sigma^2}\Big)$$

The log-normal distribution is similar to the normal distribution in that it has two parameters, $\mu$ and $\sigma$. We need to estimate both.

The following sections show how to estimate the parameters for the log-normal distribution, using two different methods.

## Maximum Likelihood Estimates

$$
\hat{\mu}=\frac{\sum \ln x_i}{n} = \overline{\ln x_i}
$$


```r
mu_hat = mean(log(floods[["discharge"]]))
```

$$
\hat{\sigma}^2 = \frac{\sum_i^n (\ln x_i - \hat{\mu})^2}{n}
$$


```r
sigma_hat = (log(floods[["discharge"]]) - mu_hat)^2 %>% mean %>% sqrt

# Adjusted MLE ----
source("finney.R")
```

## Method of Moments Estimates

$$
\tilde{\sigma}^2= \ln{\sum_{i=1}^nx_i^2} - 2\ln{\sum_{i=1}^nx_i}+\ln(n)
$$


```r
sigma_tilde = ((floods[["discharge"]]^2 %>% sum %>% log) -
    2 * (floods[["discharge"]] %>% sum %>% log) +
    log(nrow(floods))) %>%
    sqrt
```

$$
\tilde{\mu}= {\ln \sum_{i=1}^n x_i}-\ln(n)-\frac{\tilde{\sigma}^2}{2}
$$


```r
mu_tilde = (floods[["discharge"]] %>% sum %>% log) -
            log(nrow(floods)) - 
            (sigma_tilde)^2 / 2

# P(D >= v) = 0.01
```

## Estimated distributions

Since we now have parameters, we have a distribution. We can plot the probability density functions with the histogram to see how well it fits.


```r
hist(floods[["discharge"]], nclass = 25, freq = FALSE, xlab = "discharge", main = "")
lnorm_plot_v(mu = mu_hat, sigma = sigma_hat, col = "red", add = TRUE)
lnorm_plot_v(mu = mu_tilde, sigma = sigma_tilde, col = "blue", add = TRUE)
```

![center](/static/HundredYrFlood1/hist-2-1.png)

Now we can determine the value $v$ for which $P(D \geq v) = 0.01$

$P(D \geq v) = 0.01$ and $P(D <  v) = 0.99$


```r
v_mle = qlnorm(p = 0.99, meanlog = mu_hat, sdlog = sigma_hat)
```


```r
v_mom = qlnorm(p = 0.99, meanlog = mu_tilde, sdlog = sigma_tilde)

# Plot functions ----
```

So, the value of the hundred year flood is 17753 $\text{ft}^3/\text{s}$ according to maximum likelihood estimation and 26033 $\text{ft}^3/\text{s}$ accordint to method of moments estimation. From the data, we see that in only one year, 1955, was the value exceeded.

<img src="/static/HundredYrFlood1/lnorm-plots-1.png" title="center" alt="center" style="display: block; margin: auto;" />

# References

Ginos, Brenda Faith, "Parameter Estimation for the Lognormal Distribution" (2009). *All Theses and Dissertations*. 1928. http://scholarsarchive.byu.edu/etd/1928

Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.
