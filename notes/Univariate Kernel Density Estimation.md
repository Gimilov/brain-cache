---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[Univariate Kernel Density Classification]]"
  - "[[Mixture Models for Density Estimation]]"
Generalizations:
  - "[[Multivariate Kernel Density Estimation]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-23 19:27
# Definition

Suppose we have a random sample $x_1, ..., x_n$ drawn from a probability density $f_X(x)$ , and we wish to estimate $f_X$ at a point $x_0$ . For simplicity we assume for now that $X \in \mathbb{R}$. Arguing as before, a natural local estimate has the form:
$$
\hat f_X(x_0) = \frac{\#x_i \in \mathcal{N}(x_0)}{N\lambda}
$$
where $\mathcal{N}(x_0)$ is a small metric neighbourhood around $x_0$ of width $\lambda$ . This estimate is bumpy and the smooth Parzen estimate is preferred
$$
\hat f_X(x_0) =\frac{1}{N\lambda} \sum^N_{i=1} K_\lambda(x_0,x_i)
$$
because it counts observation close to $x_0$ with weights that decrease with distance from $x_0$ . In this case, a popular choice for $K_\lambda$ is the Gaussian kernel $K_\lambda(x_0,x_i) = \phi(|x-x_0| / \lambda)$ 
![][esl-figure-6.13.png]
Letting $\phi_\lambda$ denote the Gaussian density with mean zero and standard-deviation of $\lambda$ , then the equation above has the form of:
$$
\hat f_X(x) = \frac{1}{N}\sum^N_{i=1} \phi_\lambda(x-x_i)
$$
$$= (\hat F \star \phi_\lambda)(x)$$
The convolution of the sample empirical distribution $\hat F$ with $\phi_\lambda$. The distribution $\hat F(x)$ puts mass $1/N$ at each of the observed $x_i$ and is jumpy; in $\hat f_X(x)$ we have smoothed $\hat F$ by adding independent Gaussian noise to each observation $x_i$ 

The Parzen density estimate is the equivalent of the local average, and improvements have been proposed along the lines of local regression.

Pros:
- Little or no training required; the only parameter that needs to be determined from the data is the bandwidth $\lambda$
Cons:
- For multivariate data $X \in \mathbb{R}^p$ where $p$ is large, problems of sparseness are likely to occur and fewer observations in the vicinity of $x_0$ receive substantial weight by the kernel function (curse of dimensionality).
# References
1. ![][ml-resources/elements-of-statistical-learning.pdf#page=228]