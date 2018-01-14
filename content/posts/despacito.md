---
title: One Year of Despacito
author: Maazin Ansari
date: 2018-01-13
slug: despacito-1
lang: en
category: Statistics
tags: R, YouTube, visualization
summary: A quick and dirty analysis of music video views
output: html_document
---



Luis Fonsi's *Despacito* ft. Daddy Yankee was the song of 2017. Released in early January, the song became an instant hit in Latin America. After Justin Bieber got involved, it dominated charts around the world.

The music video for the original Spanish-language version was published on YouTube on January 12, 2017, one year ago today. In just 97 days, the video received one billion views. Views kept coming in, and by August 4- just 7 months after its release- the video became the first video in YouTube history to break 3 billion. 

In this post I will analyze how the music video grew so fast. I will identify weekly trends and moments where the view count grew rapidly. Currently, I don't have much experience with time series, so this analysis will be mostly visual. 

Data, scripts, and additional plots are available on [my GitHub](https://github.com/maazinansari/maazinansari/tree/master/content/R/despacito).


# Getting the data

YouTube provides video statistics for some of its videos. I'm not sure what determines whether a video has statistics enabled, but it seems most music videos have them. Here's what the daily view graph looks like for Despacito:

<img src="../../static/despacito/yt-viz.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />

We can get the data we need directly from the HTML used to create this table.

It's important to note video statistics are only available in the previous YouTube format. For some reason, YouTube removed the video statistics in their new layout.

<img src="../../static/despacito/oldtube.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" /><img src="../../static/despacito/newtube.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />


Once you're at the page and you have opened the video statistics, right-click somewhere around the chart and inspect element. You won't be able to right-click the actual graphic itself, but the axis labels should work. Look for `stats-chart-gviz` in the HTML. Click the arrows until you find the `<table>` tag. Right-click and select Copy > Copy element and paste it into a text editor and save it as an .html file.

<img src="../../static/despacito/html-elements.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />

# Cleaning the data

Now our data is saved as an HTML table. We need to get the dates and values from it to make our own graphs. We'll need the `XML` package for this. Specifically, we use the `readHTMLTable()` function to read the data as a dataframe. Then, we create new `date` and `views` columns that contain the date and number of views in appropriate formats. 


```r
# Cleaning ----
# This script only works for data taken from the English language YouTube site.
despacito_table = readHTMLTable("despacito_table.html")
despacito_df = despacito_table[[1]]
despacito_df[["date"]] = strptime(as.character(despacito_df[["Date"]]), "%b %d, %Y") %>% as.Date
despacito_df[["views"]] = gsub(",", "", despacito_df[["value"]]) %>% as.numeric
```

Let's add more columns to make analysis and plotting easier later on.


```r
# Cumulative views
despacito_df[["cumviews"]] = cumsum(despacito_df[["views"]])

# Change in views from previous day
change = despacito_df[["views"]] - c(despacito_df[1, "views"], despacito_df[-nrow(despacito_df), "views"])
despacito_df[["change"]] = change

# Add year, month, day of week
despacito_df[["year"]] = year(despacito_df[["date"]])
despacito_df[["month"]] = month(despacito_df[["date"]], label = TRUE)
despacito_df[["wday"]] = factor(weekdays(despacito_df[["date"]]),
                           levels= c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
```

# Analysis

Now that we have cleaned data, we can make some plots.

<img src="../../static/despacito/views-per-day.png" title="center" alt="center" style="display: block; margin: auto;" /><img src="../../static/despacito/total.png" title="center" alt="center" style="display: block; margin: auto;" />


These plots are the same as the ones YouTube generates, with certain view milestones marked. From this we can see some interesting patterns:

- Weekly spikes on Fridays and Saturdays
- Drop in views per day in February that spikes again in March
- Drop in views per day in mid-April
- Views per day continued growing through the summer, then dropped after August, then again in December.

When I first saw this plot, I assumed the drop in views in February was due to people limiting music during Lent. But when I marked major holidays on the plot, the correlation wasn't there.

<img src="../../static/despacito/vpd-holiday.png" title="center" alt="center" style="display: block; margin: auto;" />

Still, this plot shows coincidences with other holidays. Views dropped and steadied during Holy Week (April 9 - 15). The video was also popular on Christmas Eve and New Year's Eve, though not so much the rest of December.

The rise in the video's popularity could follow when the song was popular elsewhere. The song first topped Mexico's Los 40 on February 11. In the US, the song sat at number 1 on Billboard's Hot Latin Songs for the week of February 18. 

<img src="../../static/despacito/vpd-charts.png" title="center" alt="center" style="display: block; margin: auto;" />

I suspected the song to have received a boost when the Justin Bieber remix came out on April 16. Views did spike after that date, but it's hard to tell if it's from the remix, or from the end of Lent.

On May 15, the song hit number 1 on Billboard's Hot 100, where it would sit for several weeks through the summer. Again, there isn't a significant increase in views around that time. 

After the video hit an unprecedented 3 billion views, its popularity dropped. Perhaps as kids were going back to school, there were fewer people playing it than in the summer. Even when the song won 4 awards at the Latin Grammys in November, daily views followed the same pattern.

I'm interested in explaining the days that don't follow the trend. To better identify anomalies, I made a bar plot that colors the days of the week.

<img src="../../static/despacito/change-vpd.png" title="center" alt="center" style="display: block; margin: auto;" />

This plot better shows that daily views increase on Friday and Saturday, then drop Sunday and Monday. There are some notable exceptions. The only Saturday where views dropped was February 1. The only Friday where views dropped was April 14- Good Friday. 

There are also some unusual days where views spiked. First, there was a spike on Wednesday March 8, 2017. I cannot find anything that could explain why views spiked so much on that Wednesday. My hunch is that YouTube's suggestion algorithm effectively hid the video from February 1 to March 8, so people did not find it through their suggested videos.

The other major spikes were the Sundays of Christmas Eve and New Year's Eve. 

# Predicting future views

Now for a crude attempt at predicting views in the future. A main effects model with factors $\alpha$ and $\beta$ has the form  

$$
y_{ijk} = \mu +\alpha_i+\beta_j+e_{ijk}
$$

where $\mu$ is the overall mean, $\alpha_i$ and $\beta_j$ are the main effects of the factors, and $e_{ijk}$ is the error. For the music video views, I am assuming the number of views on a certain day depends on only the month and day of the week. 

$$
\text{views}_{ijk} = \mu +\text{month}_i+\text{wday}_j+e_{ijk}
$$
This is easy to do in R.


```r
view_mod = lm(views ~ factor(month, ordered = FALSE) + wday, data = despacito_df)
summary(view_mod)[["coefficients"]]
```

```
##                                     Estimate Std. Error    t value
## (Intercept)                        6101017.5   368686.2 16.5479942
## factor(month, ordered = FALSE)Feb   504094.8   437943.9  1.1510488
## factor(month, ordered = FALSE)Mar  4354379.6   427075.1 10.1958162
## factor(month, ordered = FALSE)Apr  7317787.7   430508.1 16.9980251
## factor(month, ordered = FALSE)May  9987258.8   426805.1 23.4000478
## factor(month, ordered = FALSE)Jun 11658600.7   430508.3 27.0810138
## factor(month, ordered = FALSE)Jul 13765615.4   426940.1 32.2425001
## factor(month, ordered = FALSE)Aug 11478848.1   426940.1 26.8863215
## factor(month, ordered = FALSE)Sep  5599158.5   430508.3 13.0059252
## factor(month, ordered = FALSE)Oct  2287510.1   426805.1  5.3596133
## factor(month, ordered = FALSE)Nov   704704.9   430508.1  1.6369144
## factor(month, ordered = FALSE)Dec -1384111.2   427075.1 -3.2409078
## wdayTuesday                          74460.1   326885.8  0.2277863
## wdayWednesday                       278608.4   327092.7  0.8517719
## wdayThursday                        659271.2   327196.1  2.0149112
## wdayFriday                         2110548.1   327196.1  6.4504076
## wdaySaturday                       3672752.2   327094.4 11.2284172
## wdaySunday                         1415449.2   326990.9  4.3287110
##                                        Pr(>|t|)
## (Intercept)                        1.009681e-45
## factor(month, ordered = FALSE)Feb  2.505070e-01
## factor(month, ordered = FALSE)Mar  1.614956e-21
## factor(month, ordered = FALSE)Apr  1.548200e-47
## factor(month, ordered = FALSE)May  2.839371e-73
## factor(month, ordered = FALSE)Jun  1.723188e-87
## factor(month, ordered = FALSE)Jul 2.831538e-106
## factor(month, ordered = FALSE)Aug  9.381737e-87
## factor(month, ordered = FALSE)Sep  9.256291e-32
## factor(month, ordered = FALSE)Oct  1.526429e-07
## factor(month, ordered = FALSE)Nov  1.025575e-01
## factor(month, ordered = FALSE)Dec  1.307217e-03
## wdayTuesday                        8.199470e-01
## wdayWednesday                      3.949298e-01
## wdayThursday                       4.468707e-02
## wdayFriday                         3.759610e-10
## wdaySaturday                       3.726519e-25
## wdaySunday                         1.966222e-05
```

The summary shows the coefficients of the model. The `(Intercept)` is the baseline to which all other coefficients are compared. Here the baseline is January and Monday. So, the estimated coefficient for February can be interpreted as "504094.8 more views in February than in January."

*Sidenote: My interpretation here might be wrong. I tried verifying the values with other methods, and couldn't replicate the results. Also, I would've liked for the summary to reflect the form of the main effects model above, (i.e. without the intercept). Using `- 1` gets rid of the intercept and includes January, but not Monday. If anyone has any suggestions for me, please feel free to reach out.*



Regardless of its interpretation, the model does a decent job at predicting. Take a look at the fitted values (in red) compared to the true values.

<img src="../../static/despacito/predict.png" title="center" alt="center" style="display: block; margin: auto;" />

Now if we want to predict when the video will reach 5, 6, or 7 billion views, we'll first need to create a data frame of predictors that contains the month and day of future dates. 


```r
future_days = seq.Date(ymd("2018-01-13"), ymd("2020-01-01"), by = "day")
future_df = data.frame(month = month(future_days, label = TRUE),
                       wday = wday(future_days, label = TRUE, abbr = FALSE))
```


Next, we predict the number of views on each of those days, assuming views follow the same pattern in the future as in 2017. 


```r
future_views = predict(view_mod, newdata = future_df)
```

Then, we'll take the cumulative sum to see the total views on each date. 


```r
future_total = cumsum(future_views) + despacito_df[nrow(despacito_df), "cumviews"] # Adding current total
```

Finally, we can see the dates where certain view milestones will occur.


```r
future_milestones = c(t_5b = future_days[which(future_total >= 5e9)][1],
                      t_6b = future_days[which(future_total >= 6e9)][1],
                      t_7b = future_days[which(future_total >= 7e9)][1],
                      t_8b = future_days[which(future_total >= 8e9)][1],
                      t_9b = future_days[which(future_total >= 9e9)][1],
                      t_10b = future_days[which(future_total >= 1e10)][1])
print(future_milestones)
```

```
##         t_5b         t_6b         t_7b         t_8b         t_9b 
## "2018-02-24" "2018-05-10" "2018-07-04" "2018-08-23" "2018-11-19" 
##        t_10b 
## "2019-03-25"
```

With this model, the music video for *Despacito* will reach 5 billion views on February 24, 2018 and 10 billion on March 25, 2019. I don't expect this model to perform very well beyond a few months. The data I used was from the first year of the song, when it was new and its popularity was at its peak. It has already completed its reign over charts around the world. 2018 may have hotter songs and music videos, and this video will be a relic of the past. Still, I'll be back in March to check how well these predictions held up. 

# References

https://www.youtube.com/watch?v=kJQP7kiw5Fk

https://en.wikipedia.org/wiki/Despacito

https://www.billboard.com/articles/columns/chart-beat/7793159/luis-fonsi-daddy-yankee-despacito-justin-bieber-number-one

http://los40.com.mx/lista40/2017/6

