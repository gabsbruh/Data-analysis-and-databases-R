data {
  int<lower=1> M;
}

generated quantities {
  real<lower=0> lambda = abs(normal_rng(0, 121));
  array[7] int y_sim;

  for (k in 1:7) {
    y_sim[k] = poisson_rng(lambda);
  }
}