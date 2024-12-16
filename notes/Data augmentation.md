---
tags:
  - ml/dl/cv
  - type/definition
---
Created: 2023-10-01 16:57
# Definition

Data augmentation takes the approach of generating more training data from existing training samples by augmenting the samples via a number of random transformations that yield believable-looking images. The goal is that, at training time, your model will never see the exact same picture twice. This helps expose the model to more aspects of the data so it can generalize better.

# Example in TF
Define a data augmentation stage.:
```python
data_augmentation = keras.Sequential(
    [
        layers.RandomFlip("horizontal"),
        layers.RandomRotation(0.1),
        layers.RandomZoom(0.2),
    ]
)
```

We got some flips, rotations and zooms
- Now, the model will never see the same picture twice during training 
- just like [[Dropout layer]], augmentation layers are inactive during inference (when we call predict() or evaluate()
- Even though we are generating new images, the inputs are still heavily intercorrelated
- We can’t produce new information, only remix existing information