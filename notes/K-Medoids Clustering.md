---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[Spectral Clustering]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-27 21:56
# Definition

We saw that K-means is only usable for quantitative data and is sensitive to outliers because of the use of the Euclidean distance measure. K-medoids removes these restrictions at the cost of increased computation time by replacing the Euclidean distance measure with an arbitrary dissimilarity measure.

The algorithm can be generalized for use with arbitrary dissimilarities $D(x_i, x_{i'})$ by replacing step 2(a) with an optimization with respect to the centers $m_1, \dots, m_K$ . In the most common form of K-medoids , cluster centers are restricted to be one of the observations assigned to that center, often referred as medoid (see algorithm below).

# K-medoids clustering algorithm
1. Fix an initial set of clusters $C_1, \dots, C_K$ (randomly or based on prior knowledge).
2. Iterate on the following two steps until cluster assignments no longer change:
	(a). For a given set of clusters $C_1, \dots, C_K$ , find the observation within each cluster minimizing the total distance to all other observations in that cluster, then, set the cluster center equal to the value of that observation $m_k = x_{i^*_k}, k= 1,\dots,K$ 
	(b). For a given set of cluster centers $m_1,\dots, m_K$ assign each observation to the cluster whose center is currently the closest.

NB: distances may be computed using an arbitrary dissimilarity measure $D(x_i, x_{i'})$ 

Pros:
- Robust to outliers (because of non-Euclidean distance measure)
- Usable for non-quantitative data (because of non-Euclidean distance measure)
- Useful when it is difficult to compute means like for images
Cons:
- Computationally slow (because of non-Euclidean distance measure)
- Not easily comprehensible or implementable