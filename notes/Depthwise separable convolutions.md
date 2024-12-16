---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-03 00:07
# Definition

Using `SeparableConv2D` instead of `Conv2D` makes our models
- **Lighter**. Fewer trainable parameters
- **Faster**. Fewer floating-point operations
- **Better**. Perform a few %-points better

Standard convolution applies a 2D filter at each depth level of the input tensor.
![][cv-cnn-standard.png]
Above, we have an input tensor with dimensions 3x8x8 and use 3x3x3 filter. For one slide, we perform 3x3x3=27 multiplications and eventually we are left with 8x8 output.

**Depthwise convolution keeps each channel separate**. 
![][cv-cnn-depthwise.png]
There are 3 stages:
1. Split the input into channels, and split the filter into channels.
2. For each of the channels, convolve the input with the corresponding filter, producing an output tensor (2D).
3. Stack the output tensors back together.
4. Finally, we mix the output channels using a 1x1 convolution
   - We separate the learning of spatial features and the learning of channel-wise features

Assume filter = 3x3, 64 input channels, and 64 output channels.
The number of trainable parameters are:
**Standard convolution**
- 3×3×64x64 = 36,864
**Depthwise convolution**
- 3x3x64 + 64x64 = 4,672
- This efficiency improvement only **increases** as the number of filters or the size of the convolution windows gets larger.

- A convolution assumes that patterns in an image are not tied to a specific location
- depthwise separable convolution assumes **spatial locations** in intermediate activations are **highly correlated**, but **different channel** are **highly independent**
- because this is generally true for image representations learned by neural nets, we get a training and performance boost

Depthwise separable convolutions
- require significantly **fewer parameters**
- involve **fewer computations**
- result in **smaller models**
    - **converge faster**
    - are **less prone to overfitting**
- this makes them really powerful when training small models from scratch on limited data

Depthwise separable convolutions are the basis of the [[Xception]] architecture.