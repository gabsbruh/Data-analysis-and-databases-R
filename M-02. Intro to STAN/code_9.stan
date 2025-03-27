data {
    int<lower=1> N; // Number of ys
}

parameters {
    array[N] real y; // prob variables y
    real theta; // prob variable theta
}

model {
    // add conditional prob density for the ys
    // given theta to the joint log prob density
    // with incremental contributions in a loop
    for (n in 1:N)
        target += normal_lpdf(y[n] | theta, 1);

    // add marginal prob density for theta
    // to the joint log prob density
    target += normal_lpdf (theta | 0, 1);
}