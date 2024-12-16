---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-30 15:57
# Definition

To force an autoencoder to learn useful properties of the data, it is usually restricted in ways that allow only for approximate reconstruction of the input. The most common restriction is to constrain the hidden layer $h$ to have a smaller dimension than $X$, in which case the autoencoder is said to be undercomplete.

The undercomplete representation is a low-dimensional representation of the data where semantically close concepts (inputs) tend to be close in distance. The learning process is described by simply minimizing a loss function:
$$
L(x,g(f(x))),
$$
where $L$ is a loss function penalizing $g(f(x))$ from being dissimilar from $x$ 

If the decoder is restricted to be linear and $L$ is squared error loss, the autoencoder will learn the principal component representation of PCA. Generally, undercomplete autoencoders are a nonlinear generalization of PCA. 
