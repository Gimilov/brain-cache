---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-09 18:00
# Definition
#### Introduction and goal of the paper
Introduced in a paper Efficient Estimation of Word Representation in Vector Space (Mikolov, Chen, Corrado, Dean, 2013). In there, authors point out that simple techniques are at their limits in many tasks. Straight-out, they point out that the progress of ML enabled us to train more complex models on much larger data sets, and that it usually outperforms simple models. **Neural network based language models significantly outperform N-gram models**.

*"The main goal of this paper is to introduce techniques that can be used for learning high-quality word vectors from huge data sets with billions of words, and with millions of words in the vocabulary"*.

#### Model Architectures
Many models were proposed for estimating continuous representations of words, such as LSA (Latent Semantic Analysis) and LDA (Latent Dirichlet Allocation). In this paper, authors focus on distributed representations of words learned by NN, as it was previously shown that they perform significantly better than LSA for preserving linear regularities among words while LDA becomes computationally very expensive on large data sets.

For model comparisons, they define a computational complexity that will later be used as a part of their process of maximisation accuracy while minimizing the computational complexity.
$$
O=E*T*Q
$$
$$E=\text{no. of training epochs, }
$$
$$
T=\text{no. of words in training set, } 
$$
$$
Q=\text{defined further for each model architecture}
$$
All models are trained using stochastic gradient descent and backpropagation.

In the end, two methods emerge:
1. Continuous Bag-of-Words Model
   - where current word is predicted based on the context
   - objective function:
     $$J_\Theta = \frac{1}{T}\sum_{t=1}^{T}logp(w_t|w_{t-n},...,w_{t-1},w_{t+1},...,w_{t+n})$$
   - $Q = N*D+D*log_2(V)$ 
![][nlp-continuous-bow-model-word2vec.png]
$\text{in picture above and below C=no. of words in context}$
$\text{V=vocabulary size, N=hidden layer size}$

2. Continuous Skip-gram Model
   - where surrounding words are predicted given the current word
   - objective function:
	   $$ J_\Theta = \frac{1}{T} \sum_{t=1}^{T}{\sum_{-n\leq j\leq n\neq0}}logp(w_{j+1}|w_t) $$
   - $Q=C*(D+D*log_2(V))$ 
![][nlp-skipgram-model-word2vec.png]

Comparison figure from the paper:
![] [nlp-cbow-skipgram-word2vec.png]

#### How the embedding is obtained:
![][nlp-word2vec-getting-embedding.png]

#### Paper:
![Efficient Estimation of Word Representation in Vector Space][/ml-resources/efficient-estimation-of-word-representations-in-vector-space-word2vec.pdf]

#### Links to this note:
- [[Word embedding]]