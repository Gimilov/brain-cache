---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions:
  - "[[K-Means Clustering with Prototypes]]"
  - "[[Learning Vector Quantization with Prototypes]]"
  - "[[Gaussian Mixtures with Prototypes]]"
Generalizations: 
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-27 17:34
# Definition

Our training data consists of $N$ pairs $(x_1, g_1), \dots , (x_n,g_N)$ where $g_i$ is a class label taking values in $\{1,2,\dots,K\}$. Prototype methods represent the training data by a set of points in feature space. These prototypes are typically not examples from the training sample, except in the case of 1-nearest-neighbor classification. 

Each prototype has an associated class label, and classification of a query point $x$ is made to the class of the closest prototype. "Closest" is usually defined by Euclidean distance in the feature space, after each feature has been standardized to have overall mean and variance 1 in the training sample. Euclidean distance is appropriate for quantitative features. 

These methods can be very effective if the prototypes are well positioned to capture the distribution of each class. Irregular class boundaries can be represented, with enough prototypes in the right places in feature space. The main challenge is to figure out how many prototypes to use and where to put them. Methods differ according to the number and way in which prototypes are selected. 

# References
1. ![][ml-resources/elements-of-statistical-learning.pdf#page=478]