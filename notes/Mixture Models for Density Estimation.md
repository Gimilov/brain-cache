---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[Mixture Models for Classification]]"
Generalizations:
  - "[[Univariate Kernel Density Estimation]]"
  - "[[Multivariate Kernel Density Estimation]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
  - "[[EM Algorithm in General]]"
---
Created: 2023-10-24 14:11
# Definition

The mixture model is a useful tool for density estimation, and can be viewed as a kind of kernel method. The Gaussian mixture model has the form
$$
f(x)=\sum^M_{m=1} \alpha_m\phi(x; \mu_m, \Sigma_m)
$$
with mixing proportions $\alpha_m$ , $\sum_m \alpha_m = 1$ , and each Gaussian density has a mean of $\mu_m$ and covariance $\Sigma_m$ . In general mixture models can use any component densities in place of Gaussian - it just happens that the Gaussian Mixture Model is by far the most popular. 

The parameters are fit by maximum likelihood, using the EM algorithm. Some special cases arise:
- If the covariance matrices are constrained to be scalar: $\Sigma_m = \sigma_mI$ , then the formula above has the form of radian basis expansion.
- If in addition $\sigma_m = \sigma > 0$ is fixed, and $M \uparrow N$ , then the maximum likelihood estimate for the equation above approaches the [[Univariate Kernel Density Estimation]] (or [[Multivariate Kernel Density Estimation]]) where $\hat \alpha_m = 1/N$ and $\hat \mu_m = x_m$ 

The number of mixture components $M$ can be interpreted as a smoothing parameter similar to the bandwidth $\lambda$ for the kernel density estimator. 

The Gaussian mixture model can be viewed as compromise between strict assumptions of Gaussian distribution and the full flexibility of the kernel density estimator. 

Pros:
- For multivariate data $X \in \mathbb{R}^p$ where $p$ is large, the curse of dimensionality can be alleviated by selecting $M << N$ 
Cons:
- Selecting $M << N$ results in a less flexible model than the kernel density estimator.
# References
1.![][ml-resources/elements-of-statistical-learning.pdf#page=233]