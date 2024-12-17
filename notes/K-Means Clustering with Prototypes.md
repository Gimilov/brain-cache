---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[K-Means Clustering]]"
  - "[[Prototype Methods]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-27 17:44
# Definition

One chooses the desired number of cluster centres, say $R$, and the K-means procedure iteratively moves the centres to minimize the total within cluster variance. To make use of prototypes and use K-means clustering for classification of labelled data, the steps are:
- apply K-means clustering to the training data **in each class separately, using $R$ prototypes per class**.
- assign a class label to each of the $K \times R$ prototypes
- classify a new feature $x$ to the class of the closest prototype

Figure below shows a simulated example with three classes and two features. We used $R=5$ prototypes per class, and show the classification regions and the decision boundary. Notice that a number of the prototypes are near the class boundaries, leading to potential misclassification errors for points near these boundaries. This results from an obvious shortcoming with this method: for each class, the other classes do not have a say in the positioning in the prototypes for that class. A better approach is [[Learning Vector Quantization with Prototypes]] that uses all of the data to position all prototypes. 
![](/img/esl-figure-13.1.png)
# References
1.![](/img/ml-resources/elements-of-statistical-learning.pdf#page=478]