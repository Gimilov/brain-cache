---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-02 18:13
# Definition

A **DenseNet** is a type of convolutional neural network that utilises dense connections between layers, through [Dense Blocks](http://www.paperswithcode.com/method/dense-block), where we connect _all layers_ (with matching feature-map sizes) directly with each other. To preserve the feed-forward nature, each layer obtains additional inputs ([[Residual connections]]) from all preceding layers and passes on its own feature-maps to all subsequent layers.
![](/img/cv-cnn-densenet.png)
![](/img/cv-cnn-densenet-1.png)