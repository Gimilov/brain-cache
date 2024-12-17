---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-02 18:00
# Definition

Residual Network (ResNet) is a deep learning model used for computer vision applications. It is a [[Convolutional Neural Networks (CNN)]] architecture designed to support hundreds or thousands of convolutional layers. Previous CNN architectures were not able to scale to a large number of layers, which resulted in limited performance. However, when adding more layers, researchers faced the “vanishing gradient” problem.

![](/img/cv-cnn-resnet.webp)

**Residual Networks**, or **ResNets**, learn residual functions with reference to the layer inputs, instead of learning unreferenced functions. Instead of hoping each few stacked layers directly fit a desired underlying mapping, residual nets let these layers fit a residual mapping. They stack [[Residual connections]] on top of each other to form network: e.g. a ResNet-50 has fifty layers using these blocks.

Formally, denoting the desired underlying mapping as $H(x)$ , we let the stacked nonlinear layers fit another mapping of $F(x) := H(x) -x$ . The original mapping is recast into $F(x)+x$ . 

There is empirical evidence that these types of network are easier to optimize, and can gain accuracy from considerably increased depth.
![](/img/cv-cnn-resnet-1.png)
