---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[K-Means Clustering with Prototypes]]"
Generalizations:
  - "[[K-Shape Clustering]]"
  - "[[Spectral Clustering]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-24 16:30
# Definition

Simple, elegant approach for partitioning dataset into K distinct, non-overlapping clusters. First, we need to specify the desired number of clusters $K$ . 
![](/img/isl-figure-12.7.png)

Let $C_1, \dots, C_k$ denote sets containing the indices of the observations in each cluster. These sets satisfy two properties:
1. $C_1 \cup C_2 \cup \cdots \cup C_k = \{1, \dots, n\}$ . In other words, each observation belongs to at least one of the $K$ clusters
2. $C_k \cap C_{k'} = \emptyset$ for all $k \neq k'$ . In other words, the clusters are non-overlapping: no observation belongs to more than one cluster.

The idea behind K-means clustering is that a good clustering is one for which the within-cluster variation is as small as possible. The within-cluster variation for cluster $C_k$ is a measure $W(C_k)$ of the amount by which the observations within cluster differ from each other. Hence we want to solve the problem:
$$
\min_{\substack{C_1,\dots,C_k}} \left\{ \sum_{k=1}^K W(C_k) \right\}
$$
Before we solve, let's define within-cluster variation. By far, the most common choice involves squared Euclidean distance:
$$
W(C_k) = \frac{1}{|C_k|}\sum_{i,i' \in C_k} \sum_{j=1}^p(x_{ij} - x_{i'j})^2
$$
where $|C_k|$ denote the number of observations in the $k$th cluster. Therefore, we have:
$$
\min_{\substack{C_1,\dots,C_k}} \left\{  \sum_{k=1}^K \frac{1}{|C_k|}\sum_{i,i' \in C_k} \sum_{j=1}^p(x_{ij} - x_{i'j})^2  \right\}
$$
It is very difficult to solve it precisely, since there are almost $K^n$ ways to partition $n$ observations into $K$ clusters. Fortunately, a very simple algorithm can be shown to provide local optimum - a pretty good solution- to the K-means optimization problem. It's shown below. 
### Algorithm: K-Means Clustering
1. Randomly assign a number from $1$ to $K$, to each of the observations. These serve as initial cluster assignments for the observations
2. Iterate until the cluster assignment stop changing:
	a. For each of the K clusters, compute the cluster centroid . The kth cluster centroid is the vector of the $p$ feature means for the observations in the $k$th cluster.
	b. Assign each observation to the cluster whose centroid is the closest (where closest is defined using Euclidean distance).


The algorithm above is guaranteed to decrease the value of the objective at each step. To understand why, the following identity is illuminating:
$$
 \frac{1}{|C_k|}\sum_{i,i' \in C_k} \sum_{j=1}^p(x_{ij} - x_{i'j})^2 = 2\sum_{i \in C_k} \sum^p_{j=1} (x_{ij} - \overline x_{kj})^2 
$$
where $\overline x_{kj} = \frac{1}{|C_k|} \sum_{i \in C_k} x_{ij}$ is the mean for the feature $j$ in a cluster $C_k$. The factor of 2 is here because the square difference has to be doubled if it's the mean vs each observation separate. Next figure shows the progression of the algorithm defined above.
![](/img/isl-figure-12.8.png)
Since the algorithm finds the local optima, we should run the analysis using different initializations and select the one with the lowest objective.
![](/img/isl-figure-12.9.png)
