---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-01 01:46
# Definition

After one or more convolution operations, we usually perform pooling to reduce dimensionality. It identifies the most prominent features within each feature map.
![][cv-pooling.jpg]
Why we do pooling? Because:
- it makes the feature dimensions smaller and more manageable
- decreases computation time & controls overfitting
- makes the network invariant to image variance as a small distortion in input will not change the output of pooling - since we take the maximum/average value in a local neighbourhood 
- helps us arrive at an almost scale invariant representation of our image.