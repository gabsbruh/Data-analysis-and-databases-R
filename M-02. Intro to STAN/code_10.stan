data {
    int<lower=1> N; // Number of ys, supplied by interface
}

parameters {
    array[N] real y; // prob variables y
    real theta; // prob variable theta
}

model {
    // add conditional probability density for the ys
    // given theta to the joint log prob density
    y ~ normal(theta, 1);

    // add marginal prob density for theta
    // to the joint log prob density using
    // eqiovalent sampling statement
    theta ~ normal(0, 1);
}
generated quantities {
    real mean_y = mean(y);
}
