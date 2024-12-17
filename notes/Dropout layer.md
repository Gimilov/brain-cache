---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-09-19 15:18
# Definition

Shortly speaking, during each run, each neuron has a probability to get dropped. This forces more nodes to identify and relay the signal in the data. Therefore, it helps minimize the model from latching onto happenstance patterns (noise) that are not significant.

# Code example
Keras basic implementation.
```python
model = keras.Sequential([
    layers.Dense(16, activation="relu"),
    layers.Dropout(0.5),
    layers.Dense(16, activation="relu"),
    layers.Dropout(0.5),
    layers.Dense(1, activation="sigmoid")
])
```
Dropout is applied to the layer before it.

- Clear improvement
- In case of IMDB movies we get lower loss than L2 regularization
![](/img/dropout.png)
