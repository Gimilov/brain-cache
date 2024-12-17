---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[K-Means Clustering]]"
Generalizations: 
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-28 17:40
# Definition

K-shape is a shape-based algorithm that generalizes K-means for sequential data like time series (e.g. stock prices, speech, audio, video, handwriting, etc.). Sequential data are naturally organized in sequences that contain information about timing, which should be accounted for by the clustering algorithm. K-shape modifies K-means by using a different dissimilarity measure based on so-called cross-correlations and a different method for computing centroids. Moreover, in contrast to K-medoids, the centroids computed by K-shape do not need to be one of the original observations.

### Shape similarity
A key issue when comparing two sequences is how to handle the variety of distortions that are characteristic of sequences. The figure displays some ECG sequences from a dataset with patients that exhibit patterns that belong in two distinct groups. 
![](/img/stats-k-shape.png)
Shape-based clustering aim to generate a partition where sequences exhibiting similar patterns are placed in the same cluster based on their shape similarity, regardless of differences in scaling (amplitude) and shifting (phase).

### Cross-correlation and shape-based distance
Cross-correlation is a shift-invariant measure of similarity between two sequences. Scaling invariance is achieved by initial standardization of the data (to ensure a mean of zero and standard deviation of one).

For two sequences $x = (x_1, \dots, x_m)$  and $y=(y_1,\dots, y_m)$ , cross correlation keeps $y$ static and slides $x$ over $y$ to compute their inner product for each shift $s$ of $x$ . We denote a shift as follows:
$$
x_{(s)}= 
\begin{cases} 
\overbrace{0, \dots, 0}^{|s|}, x_1, x_2, \dots, x_{m-s}, \quad\qquad s \geq 0 \\
x_{1-s}, \dots, x_{m-1}, x_m, \underbrace{0,\dots, 0}_{|s|}, \qquad s<0 
\end{cases}
$$
#### Example: shifts of x
![](/img/stats-k-shape-example.png)


When all possible shifts of $x$ are considered, we produce the cross-correlation sequence by computing the inner product between every possible shift of $x$ over $y$. 
$$
CC_w(x,y) \qquad w \in \{1,2,\dots, 2m-1\}
$$
where $C_w(x,y)$ is the inner product between $x_{(w-m)}$ and $y$. Not that in large values of the inner product $C_w(x,y)$ indicate that $x_{(w-m)}$ and $y$ are similar, in the sense that large/small values (in absolute sense) of $x_{(w-m)}$ and $y$ tend to occur at the same positions, e.g. points in time (and vice versa).
#### Example: the cross-correlation sequence
![](/img/stats-k-shape-example-1.png)

The maximum value of $CC_w(x,y)$ across $w$ informs us about the similarity between $x$ and $y$ when accounting for differences in shifting.  The dissimilarity measure used by K-shape is called shape-based distance (SBD), and is computed from a normalized version of the maximum value of $CC_w(x,y)$. 
$$
SBD(x,y)=1- \max_{\substack{w}}\bigg( \frac{CC_w(x,y)}{c} \bigg)
$$where $c$ is a normalizing constant that is defined in Paparrizos & Gravano (2016).
SBD takes values between $0$ and $2$, regardless of any initial data normalization. No that while $CC_w(x,y)$ is a measure of similarity, SBD is a dissimilarity measure, with 0 indicating no dissimilarity (perfect similarity).

### Centroid computation
K-shape is a centroid-based clustering method that relies on the notion of average sequence. The naive approach to extracting an average sequence is to compute each coordinate of the average sequence as the mean of the corresponding coordinates of all sequences. K-means relies on this naive approach for computing centroids. 

K-shape formulates centroid computation as an optimization problem where the objective is to find the maximizer of the squared cross-correlation to all other sequences.
![](/img/stats-k-shape-example-2.png)
#### K-shape clustering algorithm
1. Fix an initial set of clusters (randomly or based on prior knowledge)
2. Iterate on the following two steps until cluster assignments no longer change
	(a). For a given set of clusters, cluster centroids are computed by finding the maximizer of the squared cross-correlations to all other sequences
	(b). For a given set of cluster centroids, assign each observation to the cluster of the closest centroid, relying on the shape-based distance (SBD) measure.
![](/img/stats-k-shape-example-3.png)


### Practical considerations
To be able to use K-steps in practice, we must select the number of clusters and an initialization (as always). It is common practice to initialize the K-shape algorithm by randomly assigning time series across clusters. The number of clusters $K$ can be chosen by the Elbow method (as always), using the shape-based distance(SBD) measure when calculating the within-cluster dissimilarity (plot the within-cluster dissimilarity $W_K$ as the function of $K$ and look for a kink).

Pros:
- Appropriate for sequential data
- Computationally fast even when $X \in \mathbb{R}^p$ is high-dimensional ($p$ is large; alternative dissimilarity measures for sequential data like dynamic time warping are slow)
Cons:
- not easily comprehensible or implementable
- normalized cross-correlation does not offer invariance to translation, uniform scaling, occlusion, or complexity (see Paparrizos & Gravano (2016) for details)