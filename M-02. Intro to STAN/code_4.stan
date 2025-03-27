parameters {
    real theta; // unconstrained
}
model {
    // gamma density valid
    theta ~ gamma(1.25, 1.25);
}