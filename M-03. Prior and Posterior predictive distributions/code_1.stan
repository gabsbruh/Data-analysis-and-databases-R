generated quantities {
  int<lower=0> N = 50; // number of patients in trial
  real<lower=0, upper=1> p; // probability of allergic reaction
  int<lower=0, upper=N> y; // simulated number of allergic reactions

  p = beta_rng(2, 8); // prior: belief based on previous vaccine (mean = 0.2)
  y = binomial_rng(N, p); // simulate outcome based on prior
}

