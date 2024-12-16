---
tags:
  - ml/dl/cv
  - type/example
---
Created: 2023-09-30 16:56
# Definition

![][cv-FNN-limits.png]
It allows the combination of every pixel with any other pixel to be potentially relevant. Yet, pixels closer together are usually a lot more related. 
![][cv-translation-invariance.jpg]
As can be seen in the picture above, if we shift the "airplane" by one pixel, then the relationship will have to be relearned from the scratch! Therefore, it proves that fully connected network **is not** translation invariant. In other words, a network trained to recognize an "airplane" at (4,4) will not be able to recognize the exact same airplane at any other position.

We could also augment the data to generate airplanes in every position, but it would require a lot of capacity to learn translated replicas well enough to do well on the validation set. Moreover, there has to be better way - an that way are, for example,  [[Convolutional Neural Networks (CNN)]].