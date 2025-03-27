parameters {
    real<lower=0> theta; // constrained declaration
}
model {
    // gamma density valid
    theta ~ gamma(1.25, 1.25);
}