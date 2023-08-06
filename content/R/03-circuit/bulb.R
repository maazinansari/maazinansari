p = 1:200
i = seq(0.005, 1, by = 0.005)
r = p/200

plot_p_line = function(n) {
    
    P1 = (1 - (1 - r^n) ^ n) ^ n
    P2 = 1 - ((1 - r^n) ^ (n * n))
    # N^3 in series 
    P3 = r ^ (n^3)
    # N^3 in parallel
    P4 = 1 - ((1 - r) ^ (n^3))
    
    
    plot(0:1, 0:1,  asp = 1,
         type = "n", axes = FALSE,
         main = sprintf("N = %s", n))
    lines(x = i, y = P1, lty = 1)
    lines(x = i, y = P2, lty = 2)
    lines(x = i, y = P3, lty = 3, lwd = 2, col = "#377eb8")
    lines(x = i, y = P4, lty = 3, lwd = 2, col = "#d95f02")
    box(col = "grey60")
    # legend(x = 0.55, y = 0.10,
    #        #lty = 3, col = "#d95f02",
    #        legend = "N^3 switches in series",
    #        bty = "n", cex = 0.75)
    # legend(x = 0.0, y = 1.0,
    #        #lty = 3, col = "#d95f02",
    #        legend = "N^3 switches in parallel",
    #        bty = "n", cex = 0.75)
}
png(filename = "~/maazinansari/content/static/03-circuit/plot_p_lines.png", 540, 540)
par(mfrow = c(2,2), cex = 0.8,
    mar = c(0, 0, 1.5, 0), oma = c(4, 4, 4, 4),
    tcl = -0.25, mgp = c(2, 0.6, 0))
N = c(1, 2, 3, 6)
for (j in seq_along(N)) {
    plot_p_line(N[j])
    if (j %in% c(1,3)) axis(side = 2)
    if (j %in% c(3,4)) axis(side = 1)
}
mtext("Solid Line for Series Sheets, Dashes for Parallel Sheets", side = 3, outer = TRUE,
      cex = 1, line = 2.2, col = "grey20")
mtext("Probability, p, an individual switch is closed", side = 1, outer = TRUE,
      cex = 0.8, line = 2.2, col = "grey20")
mtext("Probability bulb glows, P(N, p)", side = 2, outer = TRUE,
      cex = 0.8, line = 2.2, col = "grey20")
dev.off()

n_0 = 3
p_0 = 0.5
N = 1:10
plot_N_bar = function(p) {
    P1 = (1 - (1 - p^N) ^ N) ^ N
    P2 = 1 - ((1 - p^N) ^ (N * N))
    barplot(height = rbind(P1, P2),
            beside = TRUE,
            col = c("#cbd5e8", "#fdcdac"),
            main = paste("p =", p),
            axes = FALSE,
            # xlab = "N",
            # ylab = sprintf("Probability bulb glows, P(N, %s)", p_0),
            ylim = c(0,1), names.arg = N)
}
png(filename = "~/maazinansari/content/static/03-circuit/plot_N_bars.png", 640, 480)
par(mfrow = c(2,3), cex = 0.8,
    mar = c(0, 0, 4.5, 0), oma = c(4, 4, 2, 4),
    tcl = -0.25, mgp = c(2, 0.6, 0))
P = c(0.1, 0.25, 0.4,
      0.5, 0.6, 0.75)
for (j in seq_along(P)) {
    plot_N_bar(P[j])
    if (j == 1) {
        legend("topleft",
               legend = c(expression(P[1]), expression(P[2])),
               fill = c("#cbd5e8", "#fdcdac"),
               bty = "n")
    }
    if (j %in% c(1,4)) axis(side = 2)
}
mtext("N", side = 1, outer = TRUE,
      cex = 0.8, line = 2.2, col = "grey20")
mtext("Probability bulb glows, P(N, p)", side = 2, outer = TRUE,
      cex = 0.8, line = 2.2, col = "grey20")
dev.off()