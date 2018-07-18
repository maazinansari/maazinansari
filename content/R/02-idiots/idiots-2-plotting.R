source("02-idiots1.R")

png("../../static/02-idiots/plot1.png", width = 720)
par(mfrow = c(1,2))
# me
barplot(table(unlist(simulations[2,])),
        main = "Relative frequency of the number of trigger-pulls per duel",
        xlab = "Duration of duels (number of trigger-pulls)",
        ylab = "Number of duels",
        cex.main = 0.75,
        xlim = c(0,60),
        ylim = c(0, 2000),
        col = rep(1:2, length.out = 60))
legend("topright", c("A wins", "B wins"), fill = 1:2)
# nahin
barplot(duration,
        main = "Relative frequency of the number of trigger-pulls per duel",
        xlab = "Duration of duels (number of trigger-pulls)",
        ylab = "Number of duels",
        cex.main = 0.75,
        xlim = c(0,60),
        ylim = c(0, 2000),
        col = rep(1:2, length.out = 60))
legend("topright", c("A wins", "B wins"), fill = 1:2)
axis(side = 1, 1:60)
dev.off()
