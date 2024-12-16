---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[Naive Bayes Classifier]]"
Generalizations:
  - "[[Univariate Kernel Density Estimation]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
  - "[[Bayes Theorem]]"
---
Created: 2023-10-23 22:47
# Definition

One can use nonparametric density estimates for classification in a straight-forward fashion using Bayes' theorem. Suppose for $J$ class problem we fit nonparametric density estimates $\hat f_j(X), j=1,\dots,J$ separately in each of the classes, and we also have the estimates of the class priors $\hat \pi_j$ (usually the sample proportions). Then:
$$
\hat {Pr}(G=j|X=x_0) = \frac{\hat \pi_j \hat f_j(x_0)}{\sum^J_{k=1}\hat \pi_k \hat f_k(x_0)}
$$
![][esl-figure-6.14.png]
In the right panel of 6.14, in the region where SBP is high, we have sparse data for both classes, and since Gaussian kernel density estimates use metric kernels, the density estimates are low and of poor quality (high variance) in these regions.

If the classification is the ultimate goal, then learning the separate class densities may be unnecessary and can in fact **be misleading**. Figure below shows an example where the densities are both multimodal, but the posterior ration is quite smooth. 
![][esl-figure-6.15.png]
In learning the separate densities form data, one might decide to settle for a rougher, high variance fit to capture these features, which are irrelevant for the purposes of estimating the posterior probabilities. In fact, if a classification is the ultimate goal, the we need only to estimate the posterior well near the decision boundary (for two classes, this is the set $\{x|Pr(G=1|X=x)=1/2\}$). 
# References
1.![][ml-resources/elements-of-statistical-learning.pdf#page=229]