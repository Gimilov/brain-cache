---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-01 01:13
# Definition

A convolution layer has an input and a filter (aka kernel). The filter is typically 3x3 or 5x5 matrix of weights. Just like a multilayer perceptron (MLP), these weights are initially randomized, updated and optimized with backpropagation. We slide this filter over input and perform as simple computation. The result is a scalar value that goes into a new matrix called **a feature map**. We **slide** the filter and repeat the process to complete our feature map matrix. 
![][cv-cnn-filter.gif]
In this figure, input matrix is in blue, filter is in green and the feature map is in red.

Following the code example in the section below, we are actually going to do this 32 times. The result is a scalar value that goes into a new matrix called a feature map. **Each convolution will use a different filter (different weights)**. Each feature map will learn unique features represented in the image:
![][cv-filter-focus.png]

Again, the convolution operation:
![][cv-convolution-operation.webp]

As a trivia, have a look on how different filters transform the initial image:
![][cv-filter-examples.png]

# Multiple channels

With multiple channels, our filter/kernel becomes a cube
- but the math doesn't get much more complicated
- and the output is still a scalar
- Still, just doing tensor products.
![][cv-convolution-multiple-channels.png]
![][cv-convolution-multiple-channels-1.png]
![][cv-convolution-multiple-channels-2.gif]
