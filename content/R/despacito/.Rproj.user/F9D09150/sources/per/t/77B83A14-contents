library(XML)
library(lubridate)
library(dplyr)

# ---- cleaning
# Cleaning ----
despacito_table = readHTMLTable("despacito_table.html")
despacito_df = despacito_table[[1]]
despacito_df[["date"]] = strptime(as.character(despacito_df[["Date"]]), "%b %d, %Y") %>% as.Date
despacito_df[["views"]] = gsub(",", "", despacito_df[["value"]]) %>% as.numeric

# ---- more-cleaning
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

# ---- ignore
# Special days ----

# Saturdays

saturdays = which(despacito_df[["wday"]] == "Saturday")

# Holidays

holidays_str = list(valentines = "Feb 14, 2017",
                    ash.wed = "Mar 1, 2017",
                    easter = "Apr 16, 2017",
                    mem.day = "May 29, 2017",
                    july.4 = "Jul 4, 2017",
                    labor.day = "Sep 4, 2017",
                    thanksgiving = "Nov 23, 2017",
                    xmas = "Dec 25, 2017",
                    nye = "Dec 31, 2017")
holidays = sapply(holidays_str, function(x) which(despacito_df$Date == x))

# View milestones

milestones = c(t_100M = which(despacito_df$cumviews >= 1e8)[1],
               t_1B = which(despacito_df$cumviews >= 1e9)[1],
               t_2B = which(despacito_df$cumviews >= 2e9)[1],
               t_3B = which(despacito_df$cumviews >= 3e9)[1],
               t_4B = which(despacito_df$cumviews >= 4e9)[1])

# Other events
other_events = c(los.40.mx = which(despacito_df$Date == "Feb 11, 2017"),
                 hot.latin.songs = which(despacito_df$Date == "Feb 18, 2017"),
                 beiber = which(despacito_df$Date == "Apr 16, 2017"),
                 hot.100 = which(despacito_df$Date == "May 15, 2017"),
                 latin.grammys = which(despacito_df$Date == "Nov 16, 2017"))

# Plotting ----

# Common parameters

xlim = 
    c("1/1/17", "2/1/18") %>%
    strptime(., "%m/%d/%y") %>% as.Date
xseq = seq.Date(from = xlim[1], to = xlim[2], by = "month")
total_lab = c("0", as.vector(rbind("", paste(1:5, "Billion"))))
wday_col = c(rgb(230, 93, 89, maxColorValue = 255),
             rgb(183, 138, 37, maxColorValue = 255),
             rgb(73, 170, 32, maxColorValue = 255),
             rgb(77, 182, 131, maxColorValue = 255),
             rgb(66, 167, 230, maxColorValue = 255),
             rgb(148, 111, 248, maxColorValue = 255),
             rgb(226, 62, 205, maxColorValue = 255))

# Views per day
plot_vpd = function() {
    plot(views ~ date, data = despacito_df,
         type = "l",
         lwd = 3,
         main = "Views per day",
         ylim = c(0, 30e6),
         xlim = xlim,
         axes = FALSE)
    axis(side = 1, at = xseq, labels = month(xseq, label = TRUE))
    axis(side = 2, at = seq(0, 30e6, 5e6), labels = paste(seq(0, 30, 5), "M", sep = ""), las = 1)
}

# Total views

plot_cvpd = function() {
    par(mar = c(5,6,4,2))
    plot(cumviews ~ date, data = despacito_df,
         type = "l",
         lwd = 3,
         main = "Total Views",
         ylim = c(0, 5e9),
         xlim = xlim,
         axes = FALSE,
         ylab = "")
    axis(side = 1, at = xseq, labels = month(xseq, label = TRUE))
    axis(side = 2, at = seq(0, 5e9, 5e8), labels = total_lab, las = 1)
}

plot_change = function() {
    plot(change ~ date, data = despacito_df,
         type = "h",
         lwd = 3,
         col = wday_col[despacito_df[["wday"]]],
         main = "Change in views per day",
         ylim = c(-6e6, 6e6),
         xlim = xlim,
         axes = FALSE)
    axis(side = 1, at = xseq, labels = month(xseq, label = TRUE))
    axis(side = 2, at = seq(-6e6, 6e6, 2e6), labels = paste(seq(-6, 6, 2), "M", sep = ""), las = 1)
    legend("top",
           legend = levels(despacito_df[["wday"]]),
           fill = wday_col,
           horiz = TRUE,
           cex = 0.75,
           text.width = 30,
           x.intersp = 0.1,
           bty = "n")
}

mark_days = function(days, column = "views", labels = "", col = "blue", type = "l") {
    if (type == "l") {
        segments(x0 = despacito_df[days, "date"],
                 y0 = 1e6,
                 x1 = despacito_df[days, "date"],
                 y1 = despacito_df[days, column],
                 col = col)
        text(x = despacito_df[days, "date"],
             y = 0,
             labels = labels)
    }
    if (type == "p") {
        points(x = despacito_df[days, "date"],
               y = despacito_df[days, column],
               pch = 18,
               col = col)
        text(x = despacito_df[days, "date"],
             y = despacito_df[days + 1e6, column],
             labels = labels)
    }
}

# Forecasting ----