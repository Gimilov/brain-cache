---
tags:
  - ml/dl
  - type/definition
---
Created: 2023-09-19 15:30
# Definition

In order to find an optimal setting for a given model architecture, we want to first overfit to the data. That way, we can see where the optimum point is before it starts to overfit.

Overfitting happens when our model do not generalize well for the new data. Since neural networks can fit to anything, the training loss may go down indefinitely (given a reasonable learning rate), but the validation/test loss may be miserable. 

In other words, the model learns complex patterns in the training set, focuses on irrelevant features and that patterns fail to work on the new data. 

# Dealing with overfitting
1. INCREASE INPUT 
   - makes it easier to find the optimum and avoid overfitting because the training process gets less noisy
   - makes it less likely that the model overfits to rare observations that are just flukes
![][overfitting-more-data.png]
2. DECREASE CAPACITY
   - If the model has limited memorization resources, it can’t just memorize its training data,
   - to minimize loss, the model is forced to learn _compressed representations_ that have predictive power
   - Find compromise between too much and too little capacity
   - No magical formula to determine the right number of layers or neurons
   - Model building principle: **start low and increase until diminishing returns to validation loss**. Model is too large if it overfits straight away, or validation loss looks choppy.
![][overfitting-decrease-capacity.png]

3. ADDING WEIGHT REGULARIZATION
   - makes the model simpler
   - less specific to training - better approximate the latent manifold of the data
   - mitigate overfitting by putting constraints on the complexity of the model
   - force the weights to only take on small values
   - done by adding a _cost_ of having large weights to the loss function
   - 2 types of cost: [[L1 regularization in Deep Learning]] and [[L2 regularization in Deep Learning]].

4. [[Dropout layer]]
   - Each neuron has a probability to get dropped.