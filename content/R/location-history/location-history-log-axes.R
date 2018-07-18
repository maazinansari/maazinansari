source("cleanLocationHistory.R")

# ---- t_diff_s
PTS_df$t_diff_s = PTS_df$time - lag(PTS_df$time)
PTS_df$t_diff_s[1] = 0
PTS_df$t_diff_s = as.double(PTS_df$t_diff_s)

# ---- break

png("../../static/location-history/standard_hist.png", width = 750)
# ---- standard_hist
hist(PTS_df$t_diff_s,
     breaks = 50,
     main = "Histogram of\ntime between observations",
     xlab = "time in seconds")
# ---- break
dev.off()

png("../../static/location-history/log_hist.png", width = 750)
# ---- log_hist
hist(log(PTS_df$t_diff_s),
     breaks = 50,
     main = "Histogram of\nlog(time between observations)",
     xlab = "log(time)")
# ---- break
dev.off()

png("../../static/location-history/time_hist.png", width = 750)
# ---- time_hist
time_hist = function(x, col = 0) {
    h = hist(log(x),
             axes = FALSE,
             main = "Histogram of\nlog(time between observations)",
             xlab = "time between points",
             col = col,
             breaks = 100) 
    axis(side = 1,
         
         # labels at log-transformed points 
         at =  log(c(0.01, 0.1, 1, 10, 60, 120, 600, 3600, 21600)), 
         
         # text of labels is untransformed points
         labels = paste0(c(0.01, 0.1, 1, 10, 60, 120, 600, 3600, 21600), "s"),
         
         cex.axis = 0.75,
         padj = -2,
         hadj = 1,
         las = 1)
    axis(2)
    return(h)
}

h = time_hist(PTS_df$t_diff_s)
# ---- break
dev.off()

mode_l = exp(h$mids[which.max(h$counts)])
mode_u = exp(h$mids[which.max(h$counts) + 1])

png("../../static/location-history/bins.png", width = 750)
#  ---- bins
hcols = rep("#FFFFFF", length(h$mids))
hcols[h$mids < 0] = "#edf8fb"
hcols[h$mids >= 0] = "#bdc9e1"
hcols[h$mids >= log(60)] = "#67a9cf"
hcols[h$mids >= log(60*60)] = "#02818a"
h = time_hist(PTS_df$t_diff_s, col = hcols)
legend("left",
       legend = c("milliseconds", "seconds", "minutes", "hours"),
       fill = c("#edf8fb", "#bdc9e1", "#67a9cf", "#02818a"),
       bty = "n")
# ---- break
dev.off()