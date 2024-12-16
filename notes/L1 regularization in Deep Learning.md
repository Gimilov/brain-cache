---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-09-19 15:43
# Definition

Regularization techniques are a set of best practices that actively impede the model’s ability to fit perfectly to the training data, with the goal of making the model perform better during validation. Given some training data and a network architecture, multiple sets of weight values (multiple models) could explain the data. Simpler models are less likely to overfit than complex ones.

**L1 regularization** - cost added is proportional to the **absolute value** of the weight coefficients

# Code example
Keras basic implementation
```python
from tensorflow.keras import regularizers
regularizers.l1(0.001)
```
`0.001` means that to every weight in that layer we add `0.001 * |weight|

Both L1 and [[L2 regularization in Deep Learning]] can be used at the same time:
```python
regularizers.l1_l2(l1=0.001, l2=0.001)
```
The penalty is **only added during** training time `->` loss during training will be higher than during testing
# Summary 
- Typically used for smaller deep learning models
- Large models are so overparameterized that imposing constraints on weight values hasn’t much impact on model capacity and generalization
- In such cases, [[Dropout layer]] is much more effective