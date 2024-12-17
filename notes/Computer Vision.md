---
tags:
  - ml/dl/cv
  - type/moc
---
Created: 2023-09-30 16:35
# Map of Content

Similarly to NLP, computers perceive images differently than we do, since a computer cannot see an image, but, for example, as set of pixels of different values. 

There are desirable characteristics that we would want our model to achieve:
1. Translation invariance - patterns are location-independent. We need NN to be robust to image variance
![](/img/cv-invariance.png)
2. Spatial hierarchical - patterns are identified by small, local patterns to progressively larger, global patters.
![](/img/cv-spatial-hierarchical.png)

We first should contemplate about why the fully connected NN alone is not able to achieve these characteristics ([[The limits of fully connected layers for computer vision]]). Afterwards, we proceed to introduction of CNNs ([[Convolutional Neural Networks (CNN)]]) to start off our journey in computer vision. Moreover, we look at ways to fight overfitting for computer vision (for example, [[Data augmentation]]).

Sometimes, when no more data is available at hand, one may consider [[Transfer learning]] for the problem at hand. 




