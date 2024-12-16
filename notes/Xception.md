---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-03 00:49
# Definition

The Xception architecture is a high-performing convnet. Below is the overall architecture of Xception (Entry Flow > Middle Flow > Exit Flow).
![][cv-exception.webp]
Let's build a mini Xception-like model.

```python
inputs = keras.Input(shape=(180, 180, 3))
x = data_augmentation(inputs)

x = layers.Rescaling(1./255)(x)
x = layers.Conv2D(filters=32, kernel_size=5, use_bias=False)(x)

for size in [32, 64, 128, 256, 512]:
    residual = x

    x = layers.BatchNormalization()(x)
    x = layers.Activation("relu")(x)
    x = layers.SeparableConv2D(size, 3, padding="same", use_bias=False)(x)

    x = layers.BatchNormalization()(x)
    x = layers.Activation("relu")(x)
    x = layers.SeparableConv2D(size, 3, padding="same", use_bias=False)(x)

    x = layers.MaxPooling2D(3, strides=2, padding="same")(x)

    residual = layers.Conv2D(
        size, 1, strides=2, padding="same", use_bias=False)(residual)
    x = layers.add([x, residual])

x = layers.GlobalAveragePooling2D()(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs=inputs, outputs=outputs)
```
Same data augmentation as before. We rescale as we are used to. RBG colour channels are highly correlated, so the first layer needs to be a regular `Conv2D`. Then, apply a series of conv blocks with increasing depth. Each block contains 2 batch-normalized depthwise separable convolutions and a max pooling layer with a residual connection around.