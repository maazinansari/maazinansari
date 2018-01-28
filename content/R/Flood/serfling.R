serfling_estimate_1 = function(data, k = 9, reps = 10000) {
    n = length(data)

    idx = replicate(reps, sort(sample(n, size = k)))
    logX = matrix(log(data)[idx], k, reps)
    mus = apply(logX, 2, mean)
    sigmas = apply(logX, 2, function(x) mean((x - mean(x))^2))
    
    mu_hat_serf = median(mus)
    sigma_hat_serf = sqrt(median(sigmas))
    
    return(list(mu_hat_serf, sigma_hat_serf))
}