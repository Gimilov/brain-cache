---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-30 16:10
# Definition

Autoencoders that are encouraged to learn a function that does not change much when $x$ changes slightly, by adding a penalty $\Omega(h,x)$ on the derivatives of the encoder.
$$
L(x, g(f(x))) + \Omega(h,x)
$$
$$
\Omega(h,x) = \lambda \sum_i || \nabla_x h_i||^2 
$$