# Start timer
t_0 = Sys.time()

# ---- simulation_1
set.seed(20180207)

# one duel ----
did_fire = function(prob = 1/6) {
    shot = runif(1)
    return(shot <= prob)
}

duel = function(shooters = c("A", "B")) {
    turn = 0
    nshooters = length(shooters)
    
    # repeat until a shot is fired
    while (TRUE) {
        # first shooter is A (2 - 1 mod 2 = 1)
        # second shooter is B (2 - 2 mod 2 = 2)
        turn = turn + 1 # pass gun to next shooter
        shooter = shooters[nshooters - turn %% nshooters]
        
        # pull trigger
        if ( did_fire() ) {
            return(list(shooter, turn))
        }
    }
}

# result is 2 x N matrix. Row 1 is winner. Row 2 is number of turns.
N = 10000
simulations = replicate(N, duel(), simplify = TRUE)

# results ----
# How many times A won
a_1 = mean(simulations[1,] == "A")

# Average number of turns 
average_1 = mean(unlist(simulations[2,]))

# ---- plot
barplot(table(unlist(simulations[2,])),
        main = "Relative frequency of the number of trigger-pulls per duel",
        xlab = "Duration of duels (number of trigger-pulls)",
        ylab = "Number of duels",
        cex.main = 0.75,
        xlim = c(0,60),
        ylim = c(0, 2000),
        col = rep(1:2, length.out = 60))
legend("topright", c("A wins", "B wins"), fill = 1:2)

# Stop timer 
t_1 = Sys.time()

t_idiots1 = system.time(source("idiots1.R"))[["elapsed"]]
time_table_1 = data.frame(prob    = c(nahin = a,         me = a_1,       theoretical = 6/11),
                          average = c(nahin = average,   me = average_1, theoretical = 6),
                          time    = c(nahin = t_idiots1, me = as.numeric(t_1 - t_0), theoretical = NA))

# Part 2 ----
# Start timer
t_0 = Sys.time()

# ---- simulation_2
duel_2 = function(shooters = c("A", "B"), prob = 1/6) {
    p = prob
    turn = 0
    pulls = 0
    nshooters = length(shooters)
    
    # repeat until a shot is fired
    while (TRUE) {
        # first shooter is A (2 - 1 mod 2 = 1)
        # second shooter is B (2 - 2 mod 2 = 2)
        turn = turn + 1 # pass gun to next shooter
        pulls = turn * (turn + 1)/2 # shooter gets same number of pulls  + 1
        shooter = shooters[nshooters - turn %% nshooters]
        
        # pull trigger
        if ( did_fire(prob = p) ) {
            return(list(shooter, turn, pulls))
        }
        else {
            p = p + prob
        }
    }
}

simulations_2 = replicate(N, duel_2(), simplify = TRUE)
# results ----
# How many times A won
a_2 = mean(simulations_2[1,] == "A")
# ---- break
# Average number of turns 
average_2 = mean(unlist(simulations_2[2,]))

# Average number of trigger-pulls
average_pulls_2 = mean(unlist(simulations_2[3,]))

# Stop timer
t_1 = Sys.time()

t_idiots2 = system.time(source("idiots2.R"))[["elapsed"]]
time_table_2 = cbind(prob = c(nahin = Ttl / 6,   me = a_2),
                     time = c(nahin = t_idiots2, me = as.numeric(t_1 - t_0)))
