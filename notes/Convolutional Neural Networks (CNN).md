---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-09-30 17:11
# Definition

A general overview of CNN model structure:
![][cv-cnn-structure.png]
While dense layers learn global patterns involving all pixels, Conv2D learn local patterns found in small 2d windows.
![][cv-cnn-breakdown.png]
This gives convnets two interesting properties that we desire:
1. The patterns they learn are translation-invariant
   - pattern learned in the lower-right corner of an image can be recognized anywhere
   - advantage because the visual world is fundamentally translation invariant
2. they can learn spatial hierarchies of patterns
   - a first convolution layer will learn small local patterns such as edges, a second convolutional layer will learn larger patterns made of the features of the first layers, and so on... 
   - the visual world is fundamentally spatially hierarchical

How does CNN achieve this? In the basic CNNs, it is thanks to intertwining of the
- **convolutional layers** - where a layer, via convolution using filters, learns to represent specific features in a hierarchical manner, translation invariant.  For intuition, see [[The convolution operation]]. 
- **pooling** - where after one or more convolution operations, we usually perform [[Pooling for downsampling]] to reduce dimensionality. It identifies the most prominent features within each feature map.
Moreover, we may alter the behaviour of the convolution operation using, among others, the following:
- [[Stride]] - specifies how much we move the convolution filter at each step.
- [[Padding]] - what if I don't want it to shrink in height and width? Then use padding.

Some of architectures based on CNNs are [[VGG16]], [[ResNet]]. [[DenseNet]] etc.

We also contemplate about the modern convnet architectural patterns in [[Modern convnet architectural patterns]]. There, a bunch of essential convnet (though not exclusively) best practices are discussed. Some of them are:
- residual connections
- batch normalization
- separable convolutions
# ReLU

We still use the ReLU activation function. It is applied across each feature map output from a convolution layer. Yes, it simply focus on non-negative values in the feature map.
```
layers.Conv2D(..., activation="relu", ...)
```
![][cv-cnn-relu.png]

# Multiple convolutions and pooling

Early layers will resemble the initial images the most and subsequent layers create abstract images that only make sense mathematically.
![][cv-cnn-abstraction.png]
We can use this tool to play around with visualization: https://adamharley.com/nn_vis/cnn/2d.html

# Flattening

Flattening takes our last multidimensional convolution and flattens it into a vector
![][cv-cnn-flattening.png]

# Visualized

![][cv-cnn-visualized.gif]

# Simple CNN on MNIST
```python
from tensorflow import keras
from tensorflow.keras import layers

inputs = keras.Input(shape=(28, 28, 1))
x = layers.Conv2D(filters=32, kernel_size=3, activation="relu")(inputs)
x = layers.MaxPooling2D(pool_size=2)(x)
x = layers.Conv2D(filters=64, kernel_size=3, activation="relu")(x)
x = layers.MaxPooling2D(pool_size=2)(x)
x = layers.Conv2D(filters=128, kernel_size=3, activation="relu")(x)
x = layers.Flatten()(x)
outputs = layers.Dense(10, activation="softmax")(x)
model = keras.Model(inputs=inputs, outputs=outputs)
```
```
>>> model.summary()
Model: "model"
_________________________________________________________________
Layer (type) Output Shape Param #
=================================================================
input_1 (InputLayer) [(None, 28, 28, 1)] 0
_________________________________________________________________
conv2d (Conv2D) (None, 26, 26, 32) 320
_________________________________________________________________
max_pooling2d (MaxPooling2D) (None, 13, 13, 32) 0
_________________________________________________________________
conv2d_1 (Conv2D) (None, 11, 11, 64) 18496
_________________________________________________________________
max_pooling2d_1 (MaxPooling2 (None, 5, 5, 64) 0
_________________________________________________________________
conv2d_2 (Conv2D) (None, 3, 3, 128) 73856
_________________________________________________________________
flatten (Flatten) (None, 1152) 0
```