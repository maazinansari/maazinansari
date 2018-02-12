---
title: Duelling Idiots - Introduction
author: Maazin Ansari
date: 2018-02-12
slug: idiots-1
lang: en
category: Statistics
tags: R, Probability, DI
summary: Getting started with "Duelling Idiots and Other Probability Puzzlers"
output: html_document
---



# Introduction

A few years ago I found a book at a bookstore. The book, *Duelling Idiots and Other Probability Puzzlers* by Paul J. Nahin, is a collection of probability puzzles. I recently started going through these puzzles and decided to document my progress and share my solutions. 

This is the first in a series of posts where I solve the problems from the book. I'll solve them analytically first, then verify them with simulations. Nahin provided MATLAB code for the solutions, so I will also try to rewrite his original MATLAB code in R. My solutions will be added to 
[GitHub](https://github.com/maazinansari/Duelling-Idiots) as I complete them.

These puzzles are a little more advanced than the classic balls-in-the-urn or poker hand problems They require basic knowledge of calculus and advanced understanding of probability and statistics. 

With that said, though, the first problem is a warm-up, so its solution isn't as long or complicated as the others.

# The Embarrasing Question

Researchers are asking subjects an embarrasing Yes/No question. To ensure the subjects don't lie, the team sets up the following surveying procedure:

1. Subject enters a private room with a piece of paper, and flips a fair coin
    + If heads: Write the answer (Yes/No) on the paper
    + If tails: Flip the coin again
        + If heads: Write "Yes" on the paper
        + If tails: Write "No" on the paper
2. The subject turns in a piece of paper with a "Yes" or "No" on it, not knowing the results of the coin flip(s)
3. Once all subjects turn in their papers, the researchers estimate $p$, the proportion who truthfully answered "Yes" to the question. 

The researchers have 6,230 papers with "Yes" written on them, and 3,770 with "No". What is $p$?

The procedure is outlined in the probability tree below:

<img src="../../static/01-embarrasing-question/embarrasing-question.png" title="center" alt="center" width="75%" style="display: block; margin: auto;" />

The tree assumes the coin flips are independent of each other, and are independent of the subjects' response to the question. The black numbers on each branch indicate the conditional probability of the event occuring. The red numbers indicate the joint probability of each of the four outcomes.

We want to solve for $p$, which is $P(\text{Yes} | \text{heads first})$.
We are given $P(\text{Yes}) = \frac{6230}{10000}$ and we know a coin lands on heads with probability 0.5.

$$
\begin{align*}
P(\text{Yes}) &= P(\text{heads first}\cap \text{Yes} ) + P(\text{heads second}) &= 6230/10000 \\
&        = 0.5p + 0.25 &= 6230/10000 \\
\end{align*}
$$
Solving for $p$: 

$p = 0.746$

To verify the solution, here is a simulation of the problem, using the $p=0.746$.


```r
simulate_EQ = function(p = 0.746, N = 10000) {
    pop = sample(c("yes", "no"), size = N, prob = c(p, 1-p), replace = TRUE)
    results = rep("no", N)
    for (i in 1:N) {
        flip1 = rbinom(1, size = 1, p = 0.5) # 1 = heads, 0 = tails
        if (flip1) results[i] = pop[i]
        else {
            flip2 = rbinom(1, size = 1, p = 0.5)
            if (flip2) results[i] = "yes"
        }
    }
    return(results)
}

s = sum(simulate_EQ() == "yes") 
```


```r
print(s)
```

```
## [1] 6228
```

The simulation produces 6228 "Yes"s, very close the original problem's 6230. 
