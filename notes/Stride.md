---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-01 01:18
# Definition

Stride specifies how much we move the convolution filter at each step. The most common option is simply 1 (default).
![][cv-stride.gif]

Larger stride means:
- less feature correlation
- less memory required
- less overfitting
...but [[Pooling for downsampling]] is usually better way to do this.