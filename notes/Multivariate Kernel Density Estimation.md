---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[Mixture Models for Density Estimation]]"
  - "[[Univariate Kernel Density Estimation]]"
Generalizations: 
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-24 15:12
# Definition

The kernel density estimator generalizes in a straightforward manner when our data has multiple variables ($X \in \mathbb{R}^p$) and want to estimate joint densities
$$
\hat f(x_0) = \frac{1}{N \times det(\Lambda)} \sum_{i=1}^N D(\Lambda^{-1}(x_i-x_0))
$$
where $D$ is a kernel function that accepts p-dimensional vector inputs and $\Lambda$ is a $p \times p$ matrix of bandwidths. 

In practice, it is common to specify $D$ as a product of one-dimensional kernel functions and use the same bandwidth for each.
$$
\hat f(x_0) = \frac{1}{N \lambda^p} \sum_{i=1}^N D(\frac{x_{i,1} - x_{0,1}}{\lambda}) \times \dots \times D(\frac{x_{i,p}-x_{0,p}}{\lambda})
$$

The plug-in and cross-validation methods for selecting bandwidth $\lambda$ can be extended to the multivariate case. For the commonly employed product Gaussian kernel function (product of one-dimensional kernel functions), the so-called Scott's plug-in estimate for $j$th component of $X$ is
$$
\lambda_{opt, j} = N^{-1/p+4}s_j,
$$
where $s_j$ is the sample standard deviation of $X_j$ .
![](/img/stats-multivariate-density-estimator.png)
