source("despacito.R")

# Views per day
png("../../static/despacito/views-per-day.png", width = 720)
plot_vpd()
mark_days(milestones, labels = names(milestones))
dev.off()

png("../../static/despacito/vpd-holiday.png", width = 720)
plot_vpd()
mark_days(holidays, labels = seq_along(holidays), col = "darkorange")
legend("topright", legend = paste(seq_along(holidays), " ", names(holidays)), bty = "n")
dev.off()

png("../../static/despacito/vpd-saturday.png", width = 720)
plot_vpd()
mark_days(saturdays, labels = "", type = "p")
dev.off()

png("../../static/despacito/vpd-charts.png", width = 720)
plot_vpd()
mark_days(other_events, labels = seq_along(other_events), type = "l", col = "purple")
legend("topright", legend = paste(seq_along(other_events), " ", names(other_events)), bty = "n")
dev.off()

png("../../static/despacito/change-vpd.png", width = 720)
plot_change()
dev.off()

# Cumulative views
png("../../static/despacito/total.png", width = 720)
plot_cvpd()
abline(h = seq(0, 5e9, 1e9), lty = 3, col = "lightgray")
mark_days(milestones, column = "cumviews", labels = "")
dev.off()

# Average views per weekday
avg_views_per_day  =  despacito_df %>%
    group_by(wday) %>%
    summarize(avgviews = mean(views))
png("../../static/despacito/avg-wkday.png", width = 720)
boxplot(views ~ wday,
        data = despacito_df,
        main = "Views per day of week",
        ylim = c(0, 30e6),
        yaxt = "n",
        col = wday_col,
        frame.plot = FALSE)
axis(side = 2, at = seq(0, 30e6, 5e6), labels = paste(seq(0, 30, 5), "M", sep = ""), las = 1)
points(avg_views_per_day$avgviews, col="white", pch = 3)
dev.off()

# Average views per month
avg_views_per_month  =  despacito_df %>%
    group_by(year, month) %>%
    summarize(avgviews = mean(views))
png("../../static/despacito/avg-month.png", width = 720)
barplot(height = avg_views_per_month$avgviews,
        names.arg = avg_views_per_month$month,
        main = "Average views per month",
        ylim = c(0, 25e6),
        yaxt = "n")
axis(side = 2, at = seq(0, 25e6, 5e6), labels = paste(seq(0, 25, 5), "M", sep = ""), las = 1)
dev.off()

# Total views per month
sum_views_per_month  =  despacito_df %>%
    group_by(year, month) %>%
    summarize(sumviews = sum(views))
png("../../static/despacito/total-month.png", width = 720)
barplot(height = sum_views_per_month$sumviews,
        names.arg = sum_views_per_month$month,
        main = "Total views per month",
        ylim = c(0, 7e8),
        yaxt = "n")
axis(side = 2, at = seq(0, 7e8, 1e8), labels = paste(seq(0, 70, 10), "M", sep = ""), las = 1)
dev.off()

png("../../static/despacito/predict.png", width = 720)
plot_vpd() + lines(x = despacito_df[["date"]], y = predict(view_mod), type = "l", col = "red")
dev.off()
