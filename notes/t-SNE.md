---
tags:
  - type/definition
  - ml/dl
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[Stochastic Neighbour Embedding (SNE)]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-11-03 22:03
# Definition

t-SNE is a nonlinear dimensionality reduction technique that is particularly well-suited for visualizing high-dimensional data in two or three-dimensional space. It is an improvement of the method called stochastic neighbour embedding (SNE).

Methods like PCA and autoencoders aim to preserve large pairwise distances (global structure); t-SNE aims to preserve small pairwise distances (local structure). t-SNE is able to capture much of the local structure of the high-dimensional data, while also revealing global structure such as the presence of clusters. Unlike other methods like PCA and autoencoders, t-SNE reduces the tendency to crowd points together in the center of the low-dimensional plot, or map. To understand t-SNE, we start from the See: [[Stochastic Neighbour Embedding (SNE)]].
![][dl-tsne.png]

For high-dimensional data that lies on a nonlinear manifold, large pairwise distances may not be reliable. Let us consider the data below, which lies on a nonlinear manifold like a Swiss roll. The Euclidean distance between two observations that are far apart (dashed line) does not accurately reflect their similarity. Taking into account the structure of the data, the distance between two observations that are far apart **along the manifold (solid line)** more accurately reflect their similarity. However, if we focus on observations that are close to each other, the Euclidean distance and the distance along the manifold would be similar. Thus, t-SNE aims to preserve small pairwise distances, considered to be more reliable. 

![][dl-tsne1.png]

# Stochastic Neighbour Embedding:
See more: [[Stochastic Neighbour Embedding (SNE)]]

Underlying idea: convert the Euclidean distances between our high-dimensional data into conditional probabilities that represent similarities, then construct a low-dimensional representation that matches these similarities.


# The crowding problem
The crowding problem: the area of the low-dimensional map available to accommodate distant data is not large enough. If we want to model small distances accurately in the low-dimensional map. distant observations must be placed very far apart in the map, which our cost function does not allow. Example? See the figure below.
![][dl-tsne-3.png]
Instead, we crush together points in the center of the map, which prevents gaps from forming between natural clusters. 
Solution: In the low-dimensional map, we use heavy-tailed t-distribution to compute similarities, allowing distant data points to be modelled by much larger distance in the map.
# Solution: t-SNE
In t-SNE, we use a t-distribution with one degree of freedom (which is the same as Cauchy distribution) as the heavy-tailed distribution in the low-dimensional map.

The t-SNE is symmetric SNE with pairwise similarities in the low-dimensional map given by:
$$ 
q_{ij} = \frac{(1+||y_i - y_j||^2_2)^{-1}}{\sum_{k \neq I}(1+||y_k-y_I||^2_2)^{-1}}
$$
Note from the figure below that by using a heavy-tailed distribution to compute $q_{ij}$ , distant observations with a small $p_{ij}$ will be matched by points in the map that are even further apart. 
![][dl-tsne-4.png]

# Practical considerations
- Number of dimensions of the low-dimensional map: typically two, sometimes three
- The choice of $\sigma_i$ : instead of selecting $\sigma_i$ , one specifies a so-called perplexity through trial and error with a typical value between $5$ and $50$ .
- Parameters related to gradient descent like initial learning rate, etc. (see Van der Maaten & Hinton (2013 for details): also often set through trial end error
- Whether to initially use PCA: t-SNE is very slow and infeasible for large datasets. Thus, it may be helpful to use t-SNE on features from PCA
- Whether initially use an autoencoder: if data lies on a nonlinear manifold and has more than a few dimensions, it may be helpful to use t-SNE on features from and autoencoder (see Van der Maaten & Hinton (2013) for details).

Pros:
- Well-suited for data visualisation by reducing the tendency to crowd points together in the center of the low-dimensional plot
- Captures much of the local structure of high-dimensional data, while also revealing global structure such as the presence of clusters
Cons:
- Computationally slow and infeasible for large datasets
- The solution depends on several optimization parameters that need to be chosen
- Not well-suited for data that lies on a manifold that is highly varying and has more than a few dimensions
- Not clear how t-SNE will perform when the number of dimensions is not reduced to only two or three (because of the heavy tails in the t-distribution)