---
tags:
  - type/definition
  - ml/dl
  - stats
---
Created: 2023-10-29 15:10
# Definition
An autoencoder is a feedforward neural network that is trained to reconstruct its input from a low-dimensional representation by minimizing a reconstruction error like the residual sum of squares used for PCA. Note, that we are not really interested in the reconstructed data per se, but rather in the low-dimensional representation of the data that is learned as a side effect. By training an autoencoder to minimize the reconstruction error, we force the low-dimensional representation to capture important features to the data.

Autoencoders assume that the data lies on a potentially nonlinear manifold, i.e. autoencoders provide a nonlinear approximation to the data. An autoencoder may be viewed as a special case of a feedforward neural network with output equal to the input.

Autoencoder transforms an input (observation) $x$ to an output $r$ (reconstruction), through a low-dimensional layer representation $h$, and consists of two parts:
- ENCODER: used to learn the encoder function $h=f(x)$ that maps the input to a low-dimensional space
- DECODER: used to learn a decoder function $r = g(h) = h(f(x))$ that reconstructs the input from its low-dimensional representation.
Note that the hidden layer representation $h$ describes a code used to represent the input.
![](/img/dl-autoencoder-example.png)
# Loss function
Like any other neural network, we train an autoencoder by minimizing a loss function, i.e. the reconstruction error between $x \in \mathbb{R}^p$ and $r=g(f(x)) \in \mathbb{R}^p$ . 

If the input is binary or normalized to the interval from $0$ to $1$, a common loss function is the cross-entropy:
$$
L(x, g(f(x))) = -\sum_{p=1}^P x_p \log{r_p} + (1-x_p)\log{(1-r_p)}
$$
If the input is continuous, a typical loss function is squared error loss like for PCA:
$$
L(x, g(f(x))) = ||x-g(f(x))||_2^2= \sum_{p=1}^P(x_p-r_p)^2
$$
Like for any other neural network, we may use stochastic gradient (with gradients computed using back-propagation) to minimize the loss function.

# Deep Autoencoders
So far, we have focused on shallow autoencoders, i.e. single layer autoencoders. Like for other neural networks, we often benefit from adding multiple layers after each other to construct deep autoencoders, or stacked autoencoders.
![](/img/dl-deep-autoencoder.png)
We may also benefit from using different types of layers in the autoencoder:
- DENSE LAYER: the fully connected layer considered thus far
- CONVOLUTIONAL LAYER: exploits the spatial dependence in data with grid-like structure like images and requires fewer parameters to estimate than a dense layer.
Recall that the convolutional layer consists of three stages:
1. performs several convolutions in parallel to produce a set of linear activations
2. runs each linear activation through nonlinear activation function
3. uses a pooling function for down-sampling, often max pooling

# Practical considerations
- Do we specify an undercomplete, sparse, contractive or denoising autoencoder?
- Even an undercomplete autoencoder may benefit from common regularization techniques: early stopping, dropout, weight decay, etc.
- The number and types of layers: common choices include:
	- the convolutional layer; also requires the number of filters, spatial extent of filters, stride, amount of zero padding, type of pooling
	- the dense layer; also requires the number of hidden unit in each layer
- The type of activation function: ReLu is a common default
- The type of loss function: squared error loss, cross-entropy, etc.
- The optimizer used for the descent: Adam is a common default; also requires us to specify an initial learning rate and a number of iterations to run (epochs).

Pros:
- suitable for data that lies on potentially nonlinear manifold
- very flexible and customizable approach
Cons:
- can be computationally slow
- derived variables are not uncorrelated
- many hyperparameters to tune and prone to overfitting
- sensitive to outliers
- mainly concerned with preserving large pairwise distances, or global structure; it may not properly preserve small pairwise distances, or local structure
- for data visualization there is a tendency to crowd points together at the center

# Types
- [[Undercomplete Autoencoders]]
- [[Regularized Autoencoders]]




# Reference
https://www.deeplearningbook.org/contents/autoencoders.html