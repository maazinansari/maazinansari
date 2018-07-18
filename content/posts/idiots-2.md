---
title: Duelling Idiots
author: Maazin Ansari
date: 2018-03-05
slug: idiots-2
lang: en
category: Statistics
tags: R, Probability, DI
summary: A deadly duel between two idiots. How fair is it?
output: html_document
---



The previous post was just a warmup for the rest of the book. This is the first real puzzle. The code for my solutions and the book's original solution are available on [my GitHub](https://github.com/maazinansari/Duelling-Idiots). 

# The Problem

Two individuals, *A* and *B*, will participate in a duel, which has the following setup:

1. A six-chamber gun is loaded with one bullet. The cylinder is spun so the bullet is essentially randomized. 
2. *A* aims at *B* and pulls the trigger. The gun has a 1/6 chance of firing the bullet. 
3. If the gun does not fire, *B* takes the gun, spins the cylinder, then pulls the trigger at *A*. 
Again, the gun has a 1/6 chance of firing.
4. The duelists take turns spinning the cylinder and pulling the trigger until the bullet is fired.

The problem asks:

1. What is the probability *A* wins the duel?
2. What is the expected length of the duel? That is, how many trigger pulls / turns will the duel last?

# Analytical Solution

On each of *A*'s turns, There is a 1/6 chance *A* wins and a 5/6 chance the duel continues. *A* can only win on an odd-numbered turn (1, 3, 5, ...), and *B* can only win on an even-numbered turn (2, 4, 6, ...). *A* cannot win if *B* wins first. The probability *A* wins is the total probability of winning on any odd-numbered turn. This can be expressed as the infinite sum



\begin{align*}

 P(A) = & \frac{1}{6} + && \text{A wins on turn 1}\\
        & \frac{5}{6}*\frac{5}{6}*\frac{1}{6} + && \text{A misses, B misses, A wins on turn 3}\\
        & \frac{5}{6}*\frac{5}{6}*\frac{5}{6}*\frac{5}{6}*\frac{1}{6} + 
        && \text{A misses, B misses, A misses, B misses, A wins on turn 5}\\\
        & ...
\end{align*}


$$
 P(A) = \sum_{i=0}^{\infty}
 \Big(\frac{5}{6}\Big)^{2i}
 \Big(\frac{1}{6}\Big)
$$

This is a geometric series, so it must converge. Factoring out $\frac{1}{6}$ gives 

$$
\begin{align*}
 P(A) 
 &= \frac{1}{6}\sum_{i=0}^{\infty} \Big(\frac{5}{6}\Big)^{2i} \\
 &= \frac{1}{6}\sum_{i=0}^{\infty} \Big(\Big(\frac{5}{6}\Big)^2\Big)^{i} \\
 &= \frac{1}{6}\sum_{i=0}^{\infty} \Big(\frac{25}{36}\Big)^{i} \\\\
 &= \frac{1}{6}\frac{1}{1-\frac{25}{36}} = \frac{1}{6}\frac{36}{11} \\
 P(A) &= \frac{6}{11} \approx 0.54545
\end{align*}
$$

So, *A* has a slight advantage over *B* in this duel.

The answer to the second question is a lot easier. This duel is a sequence of independent Bernoulli trials ($p=\frac{1}{6}$). So, the number of trials, or turns, until the bullet is fired (a "success") follows a geometric distribution. The expected value of a geometric distribution is 
$\frac{1}{p}=6$.

I used the following code to simulate a duel. 


```r
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
```

The plots below show the frequencies of a duelist winning on a particular turn. 
The one on the left is from my simulation. The one on the right is based on the book's simulation. 

<img src="../../static/02-idiots/plot1.png" title="center" alt="center" style="display: block; margin: auto;" />

I get the same results as the book, albeit a bit slower.


|            |      prob| average|      time|
|:-----------|---------:|-------:|---------:|
|nahin       | 0.5410000|  5.9364| 0.3570000|
|me          | 0.5514000|  5.9644| 0.4325931|
|theoretical | 0.5454545|  6.0000|        NA|

# New Rules

To give *B* a more fair chance the rules are modified. On the first turn *A* pulls the trigger once. The cylinder is spun and *B* pulls the trigger twice. *A* pulls three times, *B* pulls four, and so on until there is a winner. By these rules, the duel will last at most 6 turns.

With these new rules, what is the probability *A* wins the duel?

It's harder to solve this problem analytically. This is where simulations become useful. My simulation below simulates a duel 10,000 times and records the winners. 


```r
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
```

The book's solution is a little more abstract, and it runs much faster. Instead of simulating duels and counting wins, it simulates an infinite sum as the total probability *A* wins, and checks for convergence. Still, our answers are similar: *A* has a 52% chance of winning the duel.


|      |      prob|      time|
|:-----|---------:|---------:|
|nahin | 0.5239191| 0.0140000|
|me    | 0.5267000| 0.1816361|
