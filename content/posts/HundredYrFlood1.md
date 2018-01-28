---
title: 100-Year Flood Part 1
author: Maazin Ansari
date: 2018-01-12
slug: 100-yr-flood-1
lang: en
category: Statistics
tags: R
summary: A demonstration of parameter estimation of a lognormal distribution
output: html_document
---



In this two-part post, I play around with some data in R to show the statistics behind parameter estimation and the 100-year flood. This is mostly me following along with posts from other blogs to get familiar with R, RMarkdown, and blogging. 

In this first part, I'll show how the hundred year flood is calculated from data. In Part 2, I'll go into more detail on the 100-year flood, do some simulations, and verify our solution in Part 1.

# Parameter Estimation

The data I use here comes from Problem 6[^2] in 

Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.

> River floods are often measured by their discharges $(\text{ft}^3/\text{s})$
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

<img src="/static/HundredYrFlood1/time-plot-1-1.png" title="center" alt="center" style="display: block; margin: auto;" />

## Distribution of discharges

The problem tells us to assume discharge follows a log-normal distribution. So, $D \sim \text{Lognormal}(\mu, \sigma)$. Two notable properties of the log-normal distribution are that it takes positive values and it is positively skewed. Looking at the histogram of discharges, we can see both are true: discharges cannot be less than 0 and high-discharge floods are much less frequent than low-discharge floods.


```r
hist(floods[["discharge"]], nclass = 25, freq = TRUE, xlab = "discharge", main = "")
```

<img src="/static/HundredYrFlood1/hist-1-1.png" title="center" alt="center" style="display: block; margin: auto;" />

The next step is to determine which log-normal distribution this data comes from. In other words, what are the parameters for this distribution?

## Log-normal distribution

$$f(x) = \frac{1}{x\sigma\sqrt{2π}} \exp\Big(-\frac{(\ln x - \mu)^2}{2 \sigma^2}\Big)$$

The log-normal distribution is similar to the normal distribution in that it has two parameters, $\mu$ and $\sigma$. We need to estimate both.

The following sections show how to estimate the parameters for the log-normal distribution, using four different methods I found in a paper on log-normal parameter estimation[^1].

### Maximum Likelihood Estimates

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
```

### Method of Moments Estimates

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
```

### Serfling Robust Estimates and Finney Efficient Estimates

The next two methods are a little more complex.

The Serfling method computes a sample statistic for all $n\choose k$ permutations of the data, then selects the median as the estimate. 

I made slight modifications to the algorithm for the sake of computation speed. First, I only use 10,000 permutations. Serfling and Ginos limit the number of permutations to 10^7^, but I found even that was too high for R. Second, I did not intentionally use unique permutations. Instead I drew random samples of $k=9$ from the data. I didn't check if all 10,000 were unique. Maybe later I'll make a post investigating how much accuracy my method compromises for speed.


```r
source("serfling.R")

serfling_estimates = serfling_estimate_1(floods[["discharge"]])
mu_hat_serf = serfling_estimates[[1]]
sigma_hat_serf = serfling_estimates[[2]]
```


The Finney method uses adjusted versions of the sample mean and variance to estimate $\mu$ and $\sigma$.


```r
source("finney.R")

finney_estimates = finney_estimate_1(floods[["discharge"]])
mu_hat_finney = finney_estimates[[1]]
sigma_hat_finney = finney_estimates[[2]]
```


## Estimated distributions

Since we now have parameters, we have distributions. We can plot the four probability density functions with the histogram to see how well they fit with the data.

![center](/static/HundredYrFlood1/hist-2-1.png)

Note that the Finney efficient estimates are very similar to the maximum likelihood estimates. 


|         |       Mu|     Sigma|
|:--------|--------:|---------:|
|MLE      | 8.594057| 0.5116531|
|MOM      | 8.593508| 0.5118573|
|Serfling | 8.505484| 0.7142709|
|Finney   | 8.586239| 0.4270907|

Now we can determine the value $v$ for which $P(D \geq v) = 0.01$ or equivalently $P(D <  v) = 0.99$


```r
v_mle = qlnorm(p = 0.99, meanlog = mu_hat, sdlog = sigma_hat)
```


```r
v_mom = qlnorm(p = 0.99, meanlog = mu_tilde, sdlog = sigma_tilde)
```


```r
v_serf = qlnorm(p = 0.99, meanlog = mu_hat_serf, sdlog = sigma_tilde)
```


```r
v_finney = qlnorm(p = 0.99, meanlog = mu_hat_finney, sdlog = sigma_hat_finney)
```


|         |        v|
|:--------|--------:|
|MLE      | 17753.54|
|MOM      | 26033.18|
|Serfling | 28222.70|
|Finney   | 17752.23|

From the data, we see that in only one year, 1955, was the value exceeded.

<img src="/static/HundredYrFlood1/lnorm-plots-1.png" title="center" alt="center" style="display: block; margin: auto;" />

In the next post, I'll look at how likely this is: to have one such flood in a 37-year period.

# References

[^1]: Ginos, Brenda Faith, "Parameter Estimation for the Lognormal Distribution" (2009). *All Theses and Dissertations*. 1928. http://scholarsarchive.byu.edu/etd/1928

[^2]: Ross, Sheldon M. “Chapter 7: Parameter Estimation.” *Introduction to Probability and Statistics for Engineers and Scientists*, 5th ed., Elsevier, AP, 2014, pp. 285–286.
