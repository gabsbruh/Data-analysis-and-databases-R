data {
    int<lower=1> N; // Number of ys
}

parameters {
    array[N] real y; // probabilistic variables y
    real theta; // probabilistic variable theta
}

model {
    // add conditional probability density for the ys
    // given theta to the joint log probability density
    // using the vectorized log probability density
    target += normal_lpdf(y | theta, 1);

    // add the marginal prob density for theta 
    // to the joint log prob density
    target += normal_lpdf(theta | 0, 1);
}