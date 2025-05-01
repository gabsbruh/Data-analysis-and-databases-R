// Stan model definition

data {
  int<lower=0> N;      // Number of trials
  int<lower=0> y;      // Number of successes 
}

parameters {
  real<lower=0, upper=1> p; // Probability of allergic reaction
}

model {
    // prior for p
   p ~ beta(2, 8); 
  // Binomial likelihood: we assume the number of allergic reactions follows a binomial distribution
  // N is the number of trials, y is the number of successes (allergic reactions), and p is the probability
  y ~ binomial(N, p);  // Binomial likelihood
}

generated quantities {
  // Generate posterior predictive samples for allergic reactions
  int y_pred = binomial_rng(N, p);  // Predicted number of allergic reactions
}
