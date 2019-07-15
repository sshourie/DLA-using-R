# DLA-using-R
Diffusion Limited Aggregation with central point acting as the prime aggregator

Introduce new particles at the boundary of M*M square matrix and initiate a random walk until the particle encounters another particle, thus building an aggregated structure of N particles.
Each particle is introduced only after the prior particle is stuck, i.e, there aren't multiple particles "walking" at a time.
