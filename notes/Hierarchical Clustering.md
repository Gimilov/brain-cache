---
tags:
  - type/definition
  - stats
  - ml
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
Created: 2023-10-24 18:16
# Definition

One potential disadvantage of K-means clustering is that it requires us to pre-specify the number of clusters K. Hierarchical clustering is an alternative approach which does not require that we commit to a particular choice of K. We describe bottom-up or agglomerative clustering. This is the most common type of hierarchical clustering, and refers to the fact that a dendrogram (generally depicted as an upside-down tree) is built from the leaves and combining clusters up to the trunk.

## Interpreting dendrogram
There are $2^{n-1}$ possible re-orderings of the dendrogram, since at each of the $n-1$ points where the fusion can occur, we can swap the position of fused branches without affecting the meaning of the dendrogram. 

We draw conclusions about the similarity of two observations based on the location on the vertical axis where branches containing these two observations are first fused.
![](/img/isl-figure-12-10.11.12.png)

## The hierarchical clustering algorithm
1. Begin with $n$ observations and a measure (such as Euclidean distance) of all the $\left( \begin{array} nn \\ 2 \end{array} \right)= n(n-1)/2$   pairwise dissimilarities. Treat each observation as its own cluster.
2. For $i =n, n-1, \dots, 2$ :
	a) Examine all pairwise inter-cluster dissimilarities among the $i$ clusters and identify the pair of clusters that are least dissimilar (that is, most similar). Fuse these two clusters. The dissimilarity between these two clusters indicates the height in the dendrogram at which the fusion should be placed.
	b) Compute the new pairwise inter-cluster dissimilarities among the i-1 remaining clusters.
![](/img/isl-figure-12.13.png)

We need to address one issue. Look, for example, at the graph above (upper right, to be specific). How did we determine that $\{5, 7\}$ should be fused with cluster $\{8\}$? We have a concept of dissimilarity between observations (Euclidean, for example), but how do we define dissimilarity between two clusters if they have multiple observations in it? We develop a notion of "linkage", which defines the dissimilarity between two groups of observations. 

### Linkage
The four most common types of linkage are: complete, average, single, and centroid.
- Complete: Maximal intercluster dissimilarity. Compute all pairwise dissimilarities between the observations in a cluster $A$ and the observations in cluster $B$, and record the largest of these dissimilarities.
- Single: Minimal intercluster dissimilarity. Compute all pairwise dissimilarities between the observations in cluster $A$ and observations in cluster $B$ and record the smallest of these dissimilarities. Single linkage can result in extended, trailing clusters in which single observations are fused one at the time.
- Average: Mean intercluster dissimilarity, Compute all pairwise dissimilarities between the observations in cluster $A$ and the observations in cluster$B$ and record the average of these dissimilarities.
- Centroid: Dissimilarity between the centroid for a cluster $A$ ( a mean vector of length $p$) and the centroid for cluster $B$. Centroid linkage can result in undesirable inversions.


Average and complete linkage are generally preferred over single linkage, as they tend to yield more balanced dendrograms. Centroid linkage is often used in genomics, but suffers from a major drawback in that an inversion can occur, whereby inversion two clusters are fused at a height below either of the individual clusters in the dendrogram. This can lead to difficulties in visualization as well as in interpretation of the dendrogram.
![](/img/isl-figure-12.14.png)


### Choice of Dissimilarity Measure
Thus far, we have used Euclidean distance as the dissimilarity measure, but sometimes other dissimilarity measures might be preferred.
![](/img/isl-figure-12.15.png)
For instance, consider an online retailer interested in clustering shoppers based on their past shopping histories. The goal is to identify subgroups of similar shoppers, so that shoppers within each subgroup can be shown items and advertisements that are particularly likely to interest them. Suppose the data takes the form of a matrix where the rows are the shoppers and the columns are the items available for purchase; the elements of the data matrix indicate the number of times a given shopper has purchased a given item (i.e. a $0$ if the shopper has never purchased this item, a $1$ if the shopper has purchased it once, etc.) What type of dissimilarity measure should be used to cluster the shoppers? If Euclidean distance is used, then shoppers who have bought very few items overall (i.e. infrequent users of the online shopping site) will be clustered together. This may not be desirable. On the other hand, if correlation-based distance is used, then shoppers with similar preferences (e.g. shoppers who have bought items A and B but never items C or D) will be clustered together, even if some shoppers with these preferences are higher-volume shoppers than others. Therefore, for this application, correlation-based distance may be a better choice.

Another concern is to consider whether or not the variable should be scaled to have standard deviation equal to 1 before the dissimilarity between the observations is computed.
![](/img/isl-figure-12.16.png)
