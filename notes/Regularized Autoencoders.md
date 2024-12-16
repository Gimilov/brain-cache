---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-30 16:02
# Definition

If the undercomplete autoencoder is given too much capacity, it will fail to learn anything useful. A similar problem occurs if the hidden layer $h$ is allowed the same dimension as $X$, or a greater dimension, in which case the autoencoder is said to be overcomplete.

Another way to learn useful features is by encouraging the autoencoder, through **regularization** of the loss function, to have useful properties besides reconstructing the input, in which case the autoencoder is said to be regularized autoencoder. 
![][dl-regularized-autoencoder-example.png]
# Types 
- [[Sparse Autoencoders]]
- [[Contractive Autoencoders]]
- [[Denoising Autoencoders]]
