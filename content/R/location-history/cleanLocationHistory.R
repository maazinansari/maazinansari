# Based on: http://emelineliu.com/2016/10/21/LocationHistory/

library(jsonlite)
library(lubridate)
library(dplyr)

# location data ----
x = fromJSON("~/Downloads/Takeout 3/Location History/Location History.json")
PTS_df = x$locations
n = nrow(PTS_df)

PTS_df$lat = PTS_df$latitudeE7 / 1e7
PTS_df$lon = PTS_df$longitudeE7 / 1e7
PTS_df$time = as.POSIXct(as.numeric(PTS_df[["timestampMs"]])/1000,
                               origin = "1970-01-01", tz = "America/Chicago")

PTS_df$month = as.factor(month(PTS_df$time))
PTS_df$day = as.factor(weekdays(PTS_df$time))
PTS_df$hour = as.factor(hour(PTS_df$time))

# sort by time, drop columns
dropcols = c("timestampMs", "latitudeE7", "longitudeE7")
PTS_df = PTS_df %>% 
    arrange(time) %>%
    select(-one_of(dropcols))