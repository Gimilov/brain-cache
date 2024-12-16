---
tags:
  - ml/dl/cv
  - type/example
---
Created: 2023-10-02 14:42
# Example
For demonstration, we will use VGG16 architecture, which is based on [[Convolutional Neural Networks (CNN)]].
## Instantiate VGG16
First, we will instantiate VGG16:
```python
conv_base = keras.applications.vgg16.VGG16(
    weights="imagenet",
    include_top=False,
    input_shape=(180, 180, 3))
```
- `weights` represents the weights to use. Most pretrained models are built on ImageNet and using these weights tends to do well.
- `include_top` whether to include the fully-connected dense classifier. Typically, we want the classifier to b e specific to our problem.

# conv_base summary
##### Click the arrow to the left to show.
```
>>> conv_base.summary()
Model: "vgg16"
_________________________________________________________________
 Layer (type)                Output Shape              Param #   
=================================================================
 input_2 (InputLayer)        [(None, 180, 180, 3)]     0         
                                                                 
 block1_conv1 (Conv2D)       (None, 180, 180, 64)      1792      
                                                                 
 block1_conv2 (Conv2D)       (None, 180, 180, 64)      36928     
                                                                 
 block1_pool (MaxPooling2D)  (None, 90, 90, 64)        0         
                                                                 
 block2_conv1 (Conv2D)       (None, 90, 90, 128)       73856     
                                                                 
 block2_conv2 (Conv2D)       (None, 90, 90, 128)       147584    
                                                                 
 block2_pool (MaxPooling2D)  (None, 45, 45, 128)       0         
                                                                 
 block3_conv1 (Conv2D)       (None, 45, 45, 256)       295168    
                                                                 
 block3_conv2 (Conv2D)       (None, 45, 45, 256)       590080    
                                                                 
 block3_conv3 (Conv2D)       (None, 45, 45, 256)       590080    
                                                                 
 block3_pool (MaxPooling2D)  (None, 22, 22, 256)       0         
                                                                 
 block4_conv1 (Conv2D)       (None, 22, 22, 512)       1180160   
                                                                 
 block4_conv2 (Conv2D)       (None, 22, 22, 512)       2359808   
                                                                 
 block4_conv3 (Conv2D)       (None, 22, 22, 512)       2359808   
                                                                 
 block4_pool (MaxPooling2D)  (None, 11, 11, 512)       0         
                                                                 
 block5_conv1 (Conv2D)       (None, 11, 11, 512)       2359808   
                                                                 
 block5_conv2 (Conv2D)       (None, 11, 11, 512)       2359808   
                                                                 
 block5_conv3 (Conv2D)       (None, 11, 11, 512)       2359808   
                                                                 
 block5_pool (MaxPooling2D)  (None, 5, 5, 512)         0         
                                                                 
=================================================================
Total params: 14,714,688
Trainable params: 14,714,688
Non-trainable params: 0
_________________________________________________________________
```

# Extract and augment

Extending the pretrained model and running it end-to-end on the inputs. Recall that it is slower and more expensive, but allows us to use data augmentation. This technique is so expensive that you should only attempt it if you have access to GPU: it is absolutely intractable on CPU. 

We are going to perform feature extraction with data augmentation. We achieve this by plugging in the pretrained convolution base into a sequential model but **freeze** the convolution base weights.
```python
conv_base.trainable = False
```
**It is very important to freeze the convnet base**. Freezing a layer or set of layers means preventing their weights from being updated during training. Because the Dense layers on top are randomly initialized, very large weight updates would be propagated through the network, effectively destroying the representations previously learned.
- Unfreeze:
```python
>>> conv_base.trainable = True
>>> print("This is the number of trainable weights "
        "before freezing the conv base:", len(conv_base.trainable_weights))
This is the number of trainable weights before freezing the conv base: 26
```
- Freeze:
```python
>>> conv_base.trainable = False
>>> print("This is the number of trainable weights "
        "before freezing the conv base:", len(conv_base.trainable_weights))
This is the number of trainable weights before freezing the conv base: 0
```
Now, we can create a new model that chains together:
1. A data augmentation stage
2. Our frozen convolutional base
3. A dense classifier
```python
data_augmentation = keras.Sequential(
    [
        layers.RandomFlip("horizontal"),
        layers.RandomRotation(0.1),
        layers.RandomZoom(0.2),
    ]
)

inputs = keras.Input(shape=(180, 180, 3))
x = data_augmentation(inputs)
x = keras.applications.vgg16.preprocess_input(x)
x = conv_base(x)
x = layers.Flatten()(x)
x = layers.Dense(256)(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
model.compile(loss="binary_crossentropy",
              optimizer="rmsprop",
              metrics=["accuracy"])
```
First, data augmentation is specified. Then, we specify the input shape and apply the data augmentation. Next, apply input value scaling and apply pre-trained base, `conv_base`. Flatten and then build the dense classifier with dropout. With this setup, only the weights from the two Dense layers that we added will be trained. This means that all we are training are **four** weight tensors: two per layer (a weight matrix and the bias vector).

Let's train.
```python
callbacks = [
    keras.callbacks.ModelCheckpoint(
        filepath="feature_extraction_with_data_augmentation.keras",
        save_best_only=True,
        monitor="val_loss")
]
history = model.fit(
    train_dataset,
    epochs=50,
    validation_data=validation_dataset,
    callbacks=callbacks)
```
Training for 50 epochs because we use data augmentation. On a GPU it takes 16 minutes.