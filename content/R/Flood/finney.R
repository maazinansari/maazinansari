# Adjusted (Unbiased) MLE ----
# From Finney 1941 "On the Distribution of a Variate Whose Logarithm is Normally Distributed"

# Bias correction factor ----
.finney_series = function(x, n, degree) {
    if (degree <= 1) {
        g_1 =  ((n - 1) / n) * x
        return(g_1)
    }
    else {
        g_ = .finney_series(x, n, degree-1)
        g = g_ + g_ *   
            (n - 1)^2 / (n * degree) *
            x / (n + 2 * degree - 3)
        return(g)
    }
}

finney_series = function(x, n, degree = 500) {
    return(1 + .finney_series(x, n, degree))
}

g = function(x) finney_series(x, n)

# From Ginos 2009
g_approx = function(t, n = nrow(floods)) { 
    result = exp(t) * (
        1 - t * (t + 1) / n +
            (t^2 * (3 * t^2 + 22 * t + 21) / (6 * n^2))
    )
    return(result)
}

finney_estimate = function(data) {
    x = log(data)
    n = length(data)
    
    S_2 = var(x) # n / (n-1) * sigma_hat^2
    m_hat = exp(mean(x)) * g_approx(S_2/2, n)
    v_hat = exp(2 * mean(x)) * (g_approx(2 * S_2, n) - g_approx((n-2) * S_2 / (n-1), n))
    
    mu_hat_finney = 2 * log(m_hat) - log(v_hat + m_hat^2) / 2
    sigma_hat_finney = sqrt(log(v_hat + m_hat^2) - 2 * log(m_hat))
    
    return(list(mu_hat_finney, sigma_hat_finney))
}