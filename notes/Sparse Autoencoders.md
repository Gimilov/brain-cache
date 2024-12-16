---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-30 16:07
# Definition

Autoencoders whose training criterion involves a sparsity penalty $\Omega(h)$ on the hidden layer $h$ in addition to the reconstruction error:
$$
L(x, g(f(x))) + \Omega(h)
$$
where a common choice of the sparsity penalty is $\Omega(h) = \lambda \sum_{m=1}^M |h_m|$ 