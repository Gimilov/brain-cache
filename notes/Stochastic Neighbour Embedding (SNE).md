---
tags:
  - type/definition
  - ml/dl
  - stats
Types: 
Examples: 
Constructions:
  - "[[t-SNE]]"
Generalizations: 
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-11-04 20:09
# Definition

Simply said we want to reduce dimensions.

Underlying idea: convert the Euclidean distances between our high-dimensional data into conditional probabilities that represent similarities, then construct a low-dimensional representation that matches these similarities.

Consider some data $X \in \mathbb{R}^p$ ; suppose we have available $n$ observations $x_1,\dots,x_n$ . The similarity of $x_j$ to $x_i$ is the conditional probability $p_{j|i}$ that $x_i$ would pick $x_j$ as its neighbour if neighbours were picked in proportion to the density under a Gaussian centered at $x_i$ and with standard deviation $\sigma_i$ (see illustration below).
$$
p_{j|i} = \frac{exp(-||x_i - x_j||_2^2 / 2\sigma_i^2 )}{\sum_{k \neq i } exp(-||x_i-x_k||_2^2 / 2\sigma ^2_i)}
$$
In a sense, $\sigma_i$ determines the neighbourhoods we are trying to preserve; the method for determining $\sigma_i$ is discussed in Van der Maaten & Hinton (2013). Below is the illustration of how to compute the numerator in the expression for $p_{j|i}$ for some two-dimensional data, i.e. the unscaled similarity between observations. The denominator in $p_{j|i}$ the re-scales these similarities so that they sum to one. 
![](/img/dl-tsne-2.png)
We want to construct low-dimensional counterparts $y_i$ and $y_j$ of the observations $x_i$ and $x_j$ such that the similarity between $y_i$ and $y_j$ match that between $x_i$ and $x_j$. We compute the conditional probability that $y_i$ picks $y_j$ as its neighbour.
$$
q_{j|i} = \frac{exp(-||y_i - y_j||_2^2  )}{\sum_{k \neq i } exp(-||y_i-y_k||_2^2 )}
$$
where the variance of the Gaussian density is set to $1/\sqrt{2}$ for all observations. Note that if the map points $y_i$ and $y_j$ correctly matches the similarity between observations $x_i$ and $x_j$ , the conditional probabilities $p_{j|i}$ and $q_{j|i}$ will be equal.

Note that for each observation $x_i$, we have a lot of different $p_{j|i}$. Let's gather them all in $P_i = \{p_{1|i}, p_{2|i}, \dots, p_{n|i}\}$ which characterizes the conditional distribution that $x_i$ would pick each of the other observations as its neighbour. We can do this for each observation $x_1, x_2, \dots, x_n$ and construct $P_1, P_2, \dots, P_n$ . We can also do the same for each point in the low-dimensional map $y_1, y_2, \dots, y_n$ and construct $Q_1, Q_2, \dots, Q_n$ where $Q_i = \{q_{1|i}, q_{2|i}, \dots, q_{n|i}\}$ is the conditional distribution that $y_i$ would pick each of the other map points as its neighbour. 

SNE aims to find a **low-dimensional representation** that minimizes the mismatch $p_{j|i}$ and $q_{j|i}$ by minimizing a sum of Kullback-Leibler divergence between $P_i$ and $Q_i$.
$$
C= \sum_i KL(P_i||Q_i) = \sum_i \sum_j p_{j|i}\log{\frac{p_{j|i}}{q_{j|i}}}
$$
Because the Kullback-Leibler divergence is not symmetric, different types of error in the pairwise distances in the low-dimensional map are not weighted equally. 
- **Large cost** for using widely separated map points to represent nearby observations, i.e. for using small $q_{j|i}$ to model a large $p_{j|i}$ .
- **Small cost** for using nearby map points to represent widely separated observations
- Thus, the SNE cost function $C$ focuses on retaining local structure.

Unfortunately, SNE is hampered by a cost function that is difficult to optimize and by a problem referred to as the "crowding problem". 

First, we consider a specific symmetric version of SNE, referred to as *Symmetric SNE* , which leads to a cost function that is easier to optimize. Next, we consider using a t-distribution to compute similarities in the low-dimensional space, which also alleviates the crowding problem and leads to [[t-SNE]]. Instead of using the conditional probability $p_{j|i}$ to measure the similarity between $x_i$ and $x_j$ , symmetric SNE and t-SNE use a joint probability $p_{ij} = p_{ji}$ (symmetric). Note that in traditional SNE, the similarity between $x_i$ and $x_j$ measure by $p_{j|i}$ is different from the similarity between $x_j$ and $x_i$ measured by $p_{i|j}$ . In symmetric SNE and t-SNE similarities are symmetric.

# Symmetric SNE
The obvious way to define joint probabilities in the high-dimensional space is
$$
p_{ij} = \frac{exp(-||x_i - x_j||_2^2 / 2\sigma^2 )}{\sum_{k \neq I } exp(-||x_k-x_I||_2^2 / 2\sigma ^2)}
$$
Note: the sum in denominator is now over all possible pairs $x_k$ and $x_I$ , $k \neq I$ 
Problem: for an outlier point $x_i$ , the values of $p_{ij}$ are small, implying the location of its map point $y_i$ will have little effect on the cost function (explained below). We circumvent this problem by instead setting $p_{ij} = (p_{j|i} +p_{i|j})/2$. Pairwise similarities in the low-dimensional map are given by the joint probabilities
$$
q_{ij} = \frac{exp(-||y_i - y_j||_2^2 )}{\sum_{k \neq I } exp(-||y_k-y_I||_2^2 )}
$$
We can gather all the join probabilities (similarities) between the observations in the original, high-dimensional space in $P=\{p_{12}, p_{13}, \dots, p_{(n-1)n}\}$. Similarly, we can gather all join probabilities (similarities) between the map points in $Q = \{q_{12}, q_{13}, \dots, q_{(n-1)n}\}$.
Symmetric SNE aims for a low-dimensional representation that minimizes the mismatch between $p_{ij}$ and $q_{ij}$ by minimizing the Kullback-Leibler divergence between $P$ and $Q$:
$$
C= KL(P||Q) = \sum_i \sum_j p_{ij}\log{\frac{p_{ij}}{q_{ij}}}
$$
The cost function $C$ above is easier to optimize than that used in the traditional SNE, but we still have not solved (or discussed) the crowding problem. See: [[t-SNE]].
