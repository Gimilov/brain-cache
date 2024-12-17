---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-10-02 19:54
# Definition

We know that **normalizing** data before entering into a deep learning model helps the model learn and generalize well to new data, but data normalization should be a concern after every transformation operated by a network. Even if the data entering a layer has a 0 mean and unit variance, we don't know what happens to the data when it comes out of the other end.
- during training it uses the mean and variance of the current batch of data to normalize samples
- during inference it uses an exponential moving average of the batch-wise mean and variance of the data seen during training. 

The positive effects of batch normalization.
- **Faster training**: the distribution of the weights of the network varies much less with this layer (internal covariate shift), higher learning rates can be used. The direction in which we are heading during training is less erratic allowing us to move faster on the direction of the loss.
- **Improves regularization**. Even though the network will see the same examples on each epoch, the normalization of each mini-batch is different, thus changing the values slightly each time. The meaning of the input is the same, but not how it’s presented. The task is slightly more difficult for the network, rather than always seeing same input in the same way
- **Improves accuracy**. These two pros combined often result in better accuracy.
- Some very deep networks can only be trained if they include multiple batch norm layers - it helps with gradient propagation similarly to residual connections
- ResNet50, Inception V3 and [[Xception]] all are designed with liberal uses of batch norm
![](/img/batchnorm2.png)

# Batch normalization in code & explanations
The `BatchNormalization` layer can be used after any layer
```python
x = ...
x = layers.Conv2D(32, 3, use_bias=False)(x)
x = layers.BatchNormalization()(x)
x = layers.Activation("relu")(x)
```
- Because the output of the Conv2D layer gets normalized, the layer doesn’t need its own bias vector.
- the normalization step will take care of centering the layer’s output on zero
- this makes the layer slightly leaner
- place the previous layer’s activation after the batch normalization layer
- no activation in the first line
- activation placed _after_ the `BatchNormalization` layer
- batch norm centers your input on zero, but `relu` uses zero as a pivot for keeping or dropping channels
- if we do normalization _before_ `relu`, we get more out of `relu`

# Wikipedia on batch norm & internal covariate shift

Each layer of a neural network has inputs with a corresponding distribution, which is affected during the training process by the randomness in the parameter initialization and the randomness in the input data. The effect of these sources of randomness on the distribution of the inputs to internal layers during training is described as **internal covariate shift**. Although a clear-cut precise definition seems to be missing, the phenomenon observed in experiments is the change on means and variances of the inputs to internal layers during training.

Batch normalization was initially proposed to mitigate internal covariate shift. During the training stage of networks, as the parameters of the preceding layers change, the distribution of inputs to the current layer changes accordingly, such that the current layer needs to constantly readjust to new distributions. This problem is especially severe for deep networks, because small changes in shallower hidden layers will be amplified as they propagate within the network, resulting in significant shift in deeper hidden layers. Therefore, the method of batch normalization is proposed to reduce these unwanted shifts to speed up training and to produce more reliable models.

Besides reducing internal covariate shift, batch normalization is believed to introduce many other benefits. With this additional operation, the network can use higher learning rate without vanishing or exploding gradients. Furthermore, batch normalization seems to have a regularizing effect such that the network improves its generalization properties, and it is thus unnecessary to use dropout to mitigate overfitting. It has also been observed that the network becomes more robust to different initialization schemes and learning rates while using batch normalization.
![](/img/batchnorm.webp)
![](/img/batchnorm1.webp)
1. Activations
The activations from the previous layer are passed as input to the Batch Norm. There is one activation vector for each feature in the data.
2. Calculate Mean and Variance
For each activation vector separately, calculate the mean and variance of all the values in the mini-batch.
3. Normalize
Calculate the normalized values for each activation feature vector using the corresponding mean and variance. These normalized values now have zero mean and unit variance.
4. Scale and Shift
This step is the huge innovation introduced by Batch Norm that gives it its power. Unlike the input layer, which requires all normalized values to have zero mean and unit variance, Batch Norm allows its values to be shifted (to a different mean) and scaled (to a different variance). It does this by multiplying the normalized values by a factor, gamma, and adding to it a factor, beta. Note that this is an element-wise multiply, not a matrix multiply.

What makes this innovation ingenious is that these factors are not hyperparameters (ie. constants provided by the model designer) but are trainable parameters that are learned by the network. In other words, each Batch Norm layer is able to optimally find the best factors for itself, and can thus shift and scale the normalized values to get the best predictions.

5. Moving Average
In addition, Batch Norm also keeps a running count of the Exponential Moving Average (EMA) of the mean and variance. During training, it simply calculates this EMA but does not do anything with it. At the end of training, it simply saves this value as part of the layer’s state, for use during the Inference phase.

We will return to this point a little later when we talk about Inference. The Moving Average calculation uses a scalar ‘momentum’ denoted by alpha. This is a hyperparameter that is used only for Batch Norm moving averages and should not be confused with the momentum that is used in the Optimizer.

![](/img/batchnorm-inference.webp)
As we discussed above, during Training, Batch Norm starts by calculating the mean and variance for a mini-batch. However, during Inference, we have a single sample, not a mini-batch. How do we obtain the mean and variance in that case?

Here is where the two Moving Average parameters come in — the ones that we calculated during training and saved with the model. We use those saved mean and variance values for the Batch Norm during Inference.

Ideally, during training, we could have calculated and saved the mean and variance for the full data. But that would be very expensive as we would have to keep values for the full dataset in memory during training. Instead, the Moving Average acts as a good proxy for the mean and variance of the data. It is much more efficient because the calculation is incremental — we have to remember only the most recent Moving Average.