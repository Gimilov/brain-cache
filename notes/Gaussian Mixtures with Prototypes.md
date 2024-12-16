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
  - "[[Prototype Methods]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-27 21:20
# Definition

The Gaussian mixture model can **also be though of a prototype method**, similar in spirit to K-means and LVQ. Each cluster is described in terms of a Gaussian density, which has a centroid (as in K-means) and a covariance matrix. The comparison becomes crisper if we restrict the component Gaussians to have a scalar covariance matrix. The two steps of the alternating EM algorithm are very similar to the two steps in K-means:
- in the E-step, each observation is assigned a responsibility or weight for each cluster, based on the likelihood of each of the corresponding Gaussians. Observations close to the center of a cluster will most likely get weight $1$ for that cluster, and weight $0$ for every other cluster. Observations half-way between two clusters divide their weight accordingly.
- In the M-step, each observation contributes to the weighted means (and covariances) for every cluster.
As a consequence, the Gaussian mixture model is often referred as a soft clustering method, while K-means is hard.

Similarly, when Gaussian mixture models are used to represent the feature density in each class, it produces smooth posterior probabilities $\hat p(x) = \{\hat p_1(x), \dots, \hat p_K(x)\}$ for classifying $x$. Often this is interpreted as a soft classification, while in fact the classification rule is $\hat G(x) = \arg \max_k \hat p_k(x)$. Figure below compares the result of K-means and Gaussian mixtures on the simulated mixture problem. We see that although the decision boundaries are roughly similar, those for the mixture model are smoother (although the prototypes are in approximately the same positions). We also see that while both procedures devote a blue prototype (incorrectly) to a region in the northwest, the Gaussian mixture classifier can ultimately ignore this region, while K-means cannot. LVQ gave very similar results to K-means on this example and is not shown.
![][esl-figure-13.2.png]


# References
1.![][ml-resources/elements-of-statistical-learning.pdf#page=482]