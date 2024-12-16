---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-09-19 15:48
# Definition

Regularization techniques are a set of best practices that actively impede the model’s ability to fit perfectly to the training data, with the goal of making the model perform better during validation. Given some training data and a network architecture, multiple sets of weight values (multiple models) could explain the data. Simpler models are less likely to overfit than complex ones.

**L2 regularization** - cost added is proportional to the **square** of the value of the weight coefficients

More resistant to overfitting even though both models have the same number of parameters.
![][overfitting-l2.png]

# Code example
Keras basic implementation
```python
from tensorflow.keras import regularizers
model = keras.Sequential([
    layers.Dense(16,
                 kernel_regularizer=regularizers.l2(0.002),
                 activation="relu"),
    layers.Dense(16,
                 kernel_regularizer=regularizers.l2(0.002),
                 activation="relu"),
    layers.Dense(1, activation="sigmoid")
])
model.compile(optimizer="rmsprop",
              loss="binary_crossentropy",
              metrics=["accuracy"])
history_l2_reg = model.fit(
    train_data, train_labels,
    epochs=20, batch_size=512, validation_split=0.4)
```
`0.002` means that to every weight in that layer we add `0.002 * weight ** 2
`
Both [[L1 regularization in Deep Learning]] and L2 can be used at the same time:
```python
regularizers.l1_l2(l1=0.001, l2=0.001)
```
The penalty is **only added during** training time `->` loss during training will be higher than during testing

# Summary 
- Typically used for smaller deep learning models
- Large models are so overparameterized that imposing constraints on weight values hasn’t much impact on model capacity and generalization
- In such cases, [[Dropout layer]] is much more effective