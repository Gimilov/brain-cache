---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-10-02 17:38
# Definition

If our chain is too deep, the noise starts to overwhelm gradient information, and backpropagation stops working. Your model won't train at all. This is the **vanishing gradients** problem.
![](/img/residual-connections.jpg)
A residual connection presents a dead easy fix: just add the input of a layer or block of layers back to its output.
- The residual connection acts as an **information shortcut** around destructive or noisy blocks (blocks with ReLU, dropout, etc.)
- information can get noiselessly through the network
Residual connections are used in many architectures when models get very deep, such as [[ResNet]] or [[DenseNet]]. 

Adding the input back to the output of the block implies that **the output should have the same shape as the input**. 
- in CNN, if we increase the number of filters or use max pooling, then the shape will change

# Residual connection in computer vision
#### 1. An example of residual block where **the number of filter changes**:
```python
from tensorflow import keras
from tensorflow.keras import layers

inputs = keras.Input(shape=(32, 32, 3))
x = layers.Conv2D(32, 3, activation="relu")(inputs)
residual = x
x = layers.Conv2D(64, 3, activation="relu", padding="same")(x)
residual = layers.Conv2D(64, 1)(residual)
x = layers.add([x, residual])
```
We simply set aside the residual. We use`padding="same"` to avoid downsampling.
![](/img/cv-padding.gif)
The residual here had 32 filters, so we can use a 1x1 Conv2D to project it to the correct shape. No activation - we want to carry information forward, not risk losing it through non-linear transformation.

1x1 convolution looks at each 32 positions and takes the elementwise-product between 32 numbers on the left and the filter. So, if we use 64 different filters, we'll project the 32 feature maps to 64 feature maps. Look at the image below.
![](/img/cv-cnn-residual-connection-layer.png)Afterwards, the block output and the residual have the same shape and can be added.

#### 2. Case where the target block included a max pooling layer
```python
inputs = keras.Input(shape=(32, 32, 3))
x = layers.Conv2D(32, 3, activation="relu")(inputs)
residual = x
x = layers.Conv2D(64, 3, activation="relu", padding="same")(x)
x = layers.MaxPooling2D(2, padding="same")(x)
residual = layers.Conv2D(64, 1, strides=2)(residual)
x = layers.add([x, residual])
```
Residuals are set aside again. Here comes the block of two layers that we create our connection around. We use `padding = "same"` in both layers to avoid downsampling. Again, we use 1x1 convolution so we can add the residual layer, but use `strides = 2` to match the downsampling caused by max pooling. 
![](/img/cv-stride.gif)
#### 3. Example!
A simple convnet structure with a series of blocks:
- two convnet layers and one optional max pooling
- a residual connection around each block
```python 
inputs = keras.Input(shape=(32, 32, 3))
x = layers.Rescaling(1./255)(inputs)

def residual_block(x, filters, pooling=False):
    residual = x
    x = layers.Conv2D(filters, 3, activation="relu", padding="same")(x)
    x = layers.Conv2D(filters, 3, activation="relu", padding="same")(x)
    if pooling:
        x = layers.MaxPooling2D(2, padding="same")(x)
        residual = layers.Conv2D(filters, 1, strides=2)(residual)
    elif filters != residual.shape[-1]:
        residual = layers.Conv2D(filters, 1)(residual)
    x = layers.add([x, residual])
    return x
```
First, we specify the input and use scaling. Then, we create a function `residual_block` that:
- first saves the residual, 
- creates two convnet layers,
- `if pooling` add a pooling layer
- and adapt the residual shape using `strides = 2`,
- `elif filters != residual.shape[-1` : if we don't use max pooling, then just project the residual, but only if the number of channels has changed
- add the layer

Now, we can use this function to build our architecture.
```python
x = residual_block(x, filters=32, pooling=True)
x = residual_block(x, filters=64, pooling=True)
x = residual_block(x, filters=128, pooling=False)
x = layers.GlobalAveragePooling2D()(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs=inputs, outputs=outputs)
model.summary()
```
`GlobalAveragePooling2D()` is an alternative to `flatten()` if you want to downsample further before dense classifier. Each feature map is averaged - so if the conv layer prior to `GlovalAveragePooling2D()` has 128 feature maps, then `GlobalAveragePooling2D()` averages these into 128 neurons.
##### Model summary:
Unravel using an arrow to the left.
```
Model: "model"
__________________________________________________________________________________________________
 Layer (type)                   Output Shape         Param #     Connected to                     
==================================================================================================
 input_3 (InputLayer)           [(None, 32, 32, 3)]  0           []                               
                                                                                                  
 rescaling (Rescaling)          (None, 32, 32, 3)    0           ['input_3[0][0]']                
                                                                                                  
 conv2d_6 (Conv2D)              (None, 32, 32, 32)   896         ['rescaling[0][0]']              
                                                                                                  
 conv2d_7 (Conv2D)              (None, 32, 32, 32)   9248        ['conv2d_6[0][0]']               
                                                                                                  
 max_pooling2d_1 (MaxPooling2D)  (None, 16, 16, 32)  0           ['conv2d_7[0][0]']               
                                                                                                  
 conv2d_8 (Conv2D)              (None, 16, 16, 32)   128         ['rescaling[0][0]']              
                                                                                                  
 add_2 (Add)                    (None, 16, 16, 32)   0           ['max_pooling2d_1[0][0]',        
                                                                  'conv2d_8[0][0]']               
                                                                                                  
 conv2d_9 (Conv2D)              (None, 16, 16, 64)   18496       ['add_2[0][0]']                  
                                                                                                  
 conv2d_10 (Conv2D)             (None, 16, 16, 64)   36928       ['conv2d_9[0][0]']               
                                                                                                  
 max_pooling2d_2 (MaxPooling2D)  (None, 8, 8, 64)    0           ['conv2d_10[0][0]']              
                                                                                                  
 conv2d_11 (Conv2D)             (None, 8, 8, 64)     2112        ['add_2[0][0]']                  
                                                                                                  
 add_3 (Add)                    (None, 8, 8, 64)     0           ['max_pooling2d_2[0][0]',        
                                                                  'conv2d_11[0][0]']              
                                                                                                  
 conv2d_12 (Conv2D)             (None, 8, 8, 128)    73856       ['add_3[0][0]']                  
                                                                                                  
 conv2d_13 (Conv2D)             (None, 8, 8, 128)    147584      ['conv2d_12[0][0]']              
                                                                                                  
 conv2d_14 (Conv2D)             (None, 8, 8, 128)    8320        ['add_3[0][0]']                  
                                                                                                  
 add_4 (Add)                    (None, 8, 8, 128)    0           ['conv2d_13[0][0]',              
                                                                  'conv2d_14[0][0]']              
                                                                                                  
 global_average_pooling2d (Glob  (None, 128)         0           ['add_4[0][0]']                  
 alAveragePooling2D)                                                                              
                                                                                                  
 dense (Dense)                  (None, 1)            129         ['global_average_pooling2d[0][0]'
                                                                 ]                                
                                                                                                  
==================================================================================================
Total params: 297,697
Trainable params: 297,697
Non-trainable params: 0
```