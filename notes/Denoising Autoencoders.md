---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-30 16:10
# Definition

Rather than adding a penalty $\Omega$ to the reconstruction error, we may corrupt the input and train the autoencoder to undo this corruption:
$$
L(x,g(f(\tilde x))),
$$
where $\tilde x$ is a copy of $x$ that has been corrupted by some form of noise. 