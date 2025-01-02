---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[Mixture Models for Density Estimation]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
  - "[[Bayes Theorem]]"
---
Created: 2023-10-24 14:52
# Definition

Using [[Bayes Theorem]], separate mixture densities in each class lead to flexible models for $Pr(G|X)$.
![](/img/esl-figure-6.17.png)
Using the combined data, we fit a two-component mixture of the form ([[Mixture Models for Density Estimation]]):
$$
f(x)=\sum^M_{m=1} \alpha_m\phi(x; \mu_m, \Sigma_m)
$$
with the (scalars) $\Sigma_1$ and $\Sigma_2$ not constrained to be equal. Fitting was done via the EM algorithm. Please note, that the procedure does not use the knowledge of the CHD labels. The resulting estimates in this case, are:
$$
\hat \mu_1 = 36.4 \qquad \hat \Sigma_1=157.7 \qquad \hat \alpha_1 = 0.7
$$
$$
\hat \mu_2 = 58.0 \qquad \hat \Sigma_2=15.6 \qquad \hat \alpha_2 = 0.3
$$
The component densities are shown in the lower left and middle panels. The lower-right panel shows these component densities (orange and blue) along with the estimated mixture density (green).

The mixture model also provides and estimate of the probability that observation $i$ belongs to component $m$,
$$
\hat r_{im} = \frac{\hat \alpha_m \phi(x_i; \hat \mu_m, \hat \Sigma_m)}{\sum_{k=1}^M\hat \alpha_k \phi(x_i; \hat \mu_k, \hat \Sigma_k}
$$
where $x_i$ is Age in our example. Suppose we threshold each value $\hat r_{i2}$ and hence define $\delta_i = I(\hat r_{i2}>0.5)$. Then, we can compare the classification of each observation by CHD and the mixture model.
$$
\qquad \qquad \qquad  \text{Mixture model}
$$
$$
\qquad \qquad \qquad \quad \hat \delta = 0 \quad \hat \delta = 1
$$
$$CHD \quad No \qquad232 \qquad 70$$
$$\qquad \quad Yes \qquad 76 \qquad 84$$
Although the mixture model did not use the CHD labels, it has done a fair job in discovering the two CHD subpopulations. Linear logistic regression, using CHD as a response, achieves the same error rate (32%) when fit to these data using maximum likelihood.

# References
1. ![](ml-resources/elements-of-statistical-learning.pdf#page=233]