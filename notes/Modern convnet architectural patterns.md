---
tags:
  - ml/dl/cv
  - type/moc
---
Created: 2023-10-02 17:27
# Map of Content

Here, we cover some of the most essential convnet (not only for) best practices. Here's a list.
1. residual connections
2. batch normalization
3. separable convolutions

Popular convnet architectures are structured into groups of layers called blocks. For example, [[VGG16]] is structured into repeated `"conv, conv, max pooling"` blocks. In general, most convnets often feature **pyramid-like** structures. 
- the number of filters grows with layer depth, while the size of the feature maps shrinks accordingly
- the same pattern appears in the blocks of the VGG16 model

# 1. Residual connections
Read more: [[Residual connections]]

If our chain is too deep, the noise starts to overwhelm gradient information, and backpropagation stops working. Your model won't train at all. This is the **vanishing gradients** problem.

# 2. Batch normalization
Read more: [[Batch normalization]]

We know that **normalizing** data before entering into a deep learning model helps the model learn and generalize well to new data, but data normalization should be a concern after every transformation operated by a network. Even if the data entering a layer has a 0 mean and unit variance, we don't know what happens to the data when it comes out of the other end.
- during training it uses the mean and variance of the current batch of data to normalize samples
- during inference it uses an exponential moving average of the batch-wise mean and variance of the data seen during training. 

# 3. Depthwise separable convolutions
Read more: [[Depthwise separable convolutions]]

Using `SeparableConv2D` instead of `Conv2D` makes our models
- **Lighter**. Fewer trainable parameters
- **Faster**. Fewer floating-point operations
- **Better**. Perform a few %-points better