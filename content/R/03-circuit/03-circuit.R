# N^3 total switches
# N switches in a series
## Probability a series is closed: p^N
## Probability a series is not closed: 1 - p^n (at least one switch is open)

# N such series in parallel to make N sheets
## Probability at least one series in a sheet is closed
## = 1 - Probability none are closed: 1 - (1 - p^n)^n

# N such sheets in series
# Probability all sheets have at least one closed series: (1 - (1 - p^n)^n)^n

# N such sheets in parallel
# Probability at least one sheet has at least one closed series: 1 - ((1 - p^n)^n)^n

# Simulating matrices ----
library(magrittr)
set.seed(20180214)
N_sim = 10000
n_0 = 3
p_0 = 0.5
# one sheet:
make_sheet = function(N = n_0, p =  p_0) {
    m  = matrix(data = rbinom(N^2, size = 1, prob = p),
                nrow = N, ncol = N)
    series_closed = rowSums(m) == N 
    sheet_closed = any(series_closed)
    return(sheet_closed)
}

make_circuit = function(N = n_0, p =  p_0) {
    sheets_closed = logical(N)
    for (i in 1:N) {
        sheets_closed[i] = make_sheet(N, p)
    }
    glow = c(sheets_in_series = all(sheets_closed),
             sheets_in_parallel = any(sheets_closed))
    return(glow)
}


t_0 = Sys.time()
glows = replicate(n = N_sim, expr = make_circuit())
t_1 = Sys.time()

t_bulb = system.time(source("nahin-R/bulb.R"))[["elapsed"]]
time_table_1 = data.frame(time = c(nahin = t_bulb, me = as.numeric(t_1 - t_0)),
                          P1 = c(nahin = P1[p_0 * length(P1)], me = mean(glows["sheets_in_series",])),
                          P2 = c(nahin = P2[p_0 * length(P2)], me = mean(glows["sheets_in_parallel",]))
                          )

# plot simulated probabilities
points(x = rep(p_0, 2), y = rowMeans(glows), pch = 3, col = "red")
legend("topleft",
       legend = sprintf("simulated probabilities for P(%s,%s)", n_0, p_0),
       cex = 0.75,
       pch = 3, col = "red", bty = "n")

# change in P(N,p) as N increases
N = 1:10
P1 = (1 - (1 - p_0^N) ^ N) ^ N
P2 = 1 - ((1 - p_0^N) ^ (N * N))
barplot(height = rbind(P1, P2),
        beside = TRUE,
        col = c("#cbd5e8", "#fdcdac"),
        main = paste("p =", p_0),
        xlab = "N",
        ylab = sprintf("Probability bulb glows, P(N, %s)", p_0),
        ylim = c(0,1),names.arg = N)
legend("topleft",
       legend = c("series sheets", "parallel sheets"),
       fill = c("#cbd5e8", "#fdcdac"),
       bty = "n")
# Markov chain random process ----