---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[K-Means Clustering]]"
  - "[[K-Medoids Clustering]]"
  - "[[Hierarchical Clustering]]"
Generalizations: 
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-28 19:27
# Definition

Traditional clustering methods like K-means use a spherical or elliptical metric to group data points. Hence they will not work well when clusters are non-convex, such as the concentric circles in the top left panel of figure below.

The starting point is a $N \times N$ matrix of pairwise similarities $s_{ii'} \geq 0$ between all observation pairs. We represent the observations in an undirected similarity graph $G = (V, E)$ . The $N$ vertices $v_i$ represent the observations, and pairs of vertices are connected by an edge if their similarity is positive (or exceeds some threshold). The edges are weighted by $s_{ii'}$ . Clustering is now rephrased as a graph-partition problem, where we identify connected components with clusters. We wish to partition the graph, such that edges between different groups have low weight, and within group have high weight. The idea in spectral clustering is to construct similarity graphs that represent local neighbourhood relationships between observations.

To make things more concrete, consider a set of $N$ points $x_i \in \mathbb{R}^p$ , and let $d_{ii'}$ be the Euclidean distance between $x_i$ and $x_{i'}$ . We will use as similarity matrix the radial-kernel gram matrix; that is, $s_{ii'} = exp(-d^2_{ii'}/c)$, where $c>0$ is a scale parameter.

There are many ways to define similarity matrix and its associated similarity graph that reflect local behaviour. The most popular is the mutual K-nearest neighbour graph. 

Define $\mathcal{N}_K$ to be the symmetric set of nearby pairs of points; specifically a pair $(i, i^{'})$
is in $\mathcal{N}_K$ if point $i$ is among the K-nearest neighbours of $i^{'}$, or vice versa. The we connect all symmetric nearest neighbours, give them edge weight $w_{ii'} = s_{ii'}$; otherwise the edge weight is zero. Equivalently we set to zero all the pairwise similarities not in $\mathcal{N}_K$, and draw the graph for this modified similarity matrix. 

Alternatively, a fully connected graph includes all pairwise edges with weights $w_{ij'} = s_{ij'}$, and the local behaviour is controlled by the scale parameter $c$.

The matrix of edge weights $W = \{w_{ij}\}$ from a similarity graph is called the adjacency matrix. The degree of vertex $i$ is $g_i = \sum_{i'} w_{ii'}$, the sum of the weights of the edges connected to it. Let $G$ be a diagonal matrix with diagonal elements $g_i$.

Finally, the graph Laplacian is defined by
$$L=G−W$$
This is called the unnormalized graph Laplacian; a number of normalized versions have been proposed—these standardize the Laplacian with respect to the node degrees $g_i$, for example, $\tilde{L} = I - G^{-1}W$.

Spectral clustering finds the $m$ eigenvectors $Z_{N \times m}$ corresponding to the $m$ smallest eigenvalues of $L$ (ignoring the trivial constant eigenvector). Using a standard method like K-means, we then cluster the rows of $Z$ to yield a clustering of the original data points.

### Example
An example is presented in figure below. The top left panel shows 450 simulated data points in three circular clusters indicated by the colours. K-means clustering would clearly have difficulty identifying the outer clusters. We applied spectral clustering using a 10-nearest neighbour similarity graph, and display the eigenvector corresponding to the second and third smallest eigenvalue of the graph Laplacian in the lower left. The 15 smallest eigenvalues are shown in the top right panel. The two eigenvectors shown have identified the three clusters, and a scatterplot of the rows of the eigenvector matrix $Y$ in the bottom right clearly separates the clusters. A procedure such as K-means clustering applied to these transformed points would easily identify the three groups.
![](/img/stats-cluster-spectral.png)
### Why does spectral clustering work?
Why does spectral clustering work? For any vector $f$ we have
$$
f^T L f = \sum_{i=1}^{N} g_i f_i^2 - \sum_{i=1}^{N} \sum_{i'=1}^{N} f_i f_{i'} w_{ii'}
= \frac{1}{2} \sum_{i=1}^{N} \sum_{i'=1}^{N} w_{ii'} (f_i - f_{i'})^2.​
$$
Formula suggests that a small value of $f^T L f$ will be achieved if pairs of points with large adjacencies have coordinates $f_i$ and $f_j$ close together. Since $1^T L 1 = 0$ for any graph, the constant vector is a trivial eigenvector with eigenvalue zero. Not so obvious is the fact that if the graph is connected, it is the only zero eigenvector. Generalizing this argument, it is easy to show that for a graph with $m$ connected components, The nodes can be reordered so that $L$ is block diagonal with a block for each connected component. Then $L$ has $m$ eigenvectors of eigenvalue zero, and the eigenspace of eigenvalue zero is spanned by the indicator vectors of the connected components. In practice one has strong and weak connections, so zero eigenvalues are approximated by small eigenvalues.

Spectral clustering is an interesting approach for finding non-convex clusters. When a normalized graph Laplacian is used, there is another way to view this method. Defining $P = G^{-1}W$, we consider a random walk on the graph with transition probability matrix $P$. Then spectral clustering yields groups of nodes such that the random walk seldom transitions from one group to another.

There are a number of issues that one must deal with in applying spectral clustering in practice. We must choose the type of similarity graph—e.g., fully connected or nearest neighbours, and associated parameters such as the number of nearest neighbours $k$ or the scale parameter of the kernel $c$. We must also choose the number of eigenvectors to extract from $L$ and finally, as with all clustering methods, the number of clusters. In the toy example of figure below we obtained good results for $k \in [5, 200]$, the value 200 corresponding to a fully connected graph. With $k < 5$ the results deteriorated. Looking at the top-right panel of Figure below we see no strong separation between the smallest three eigenvalues and the rest. Hence it is not clear how many eigenvectors to select.
![](/img/esl-figure-14.29.png)

# References
1.![](/img/ml-resources/elements-of-statistical-learning.pdf#page=563]