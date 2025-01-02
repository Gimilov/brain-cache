---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-10 16:31
# Definition

Authors of the paper titled "Global Vectors for Word Representation" (Pennington et al.) tried to find a trade-off between matrix factorization and shallow window methods for word embedding. 

#### Matrix Factorization:
Methods that approximate corpus statistics on term-doc or term-term matrices.
- LSA (Latent Semantic Analysis): a count of word frequency in a context
- HAL (Hyperspace Analogue to Language): a count of pair distances in a set window
Problems:
- No differentiation or alternative definitions
- All other language semantics are lost
"Inability to capture contextual data in the word's neighbourhood. Fail to distinguish between any sub- or secondary meaning a word tend to have".

#### Shallow Window:
Methods that make predictions within local context window. Remember word2vec?
- First works using NNs to train vectors
- Word's local context used to learn word representations 
Problems:
- Do not account for co-occurrence statistics. 

#### Global Vectors:
Aim to improve upon all of the above by capturing the context of the word in the embedding through explicitly capturing these co-occurrence probabilities. It is a method to capture global corpus statistics. 
- Contexts captured
- word-word statistics/co-occurrence probabilities 

| | k='solid' | k='gas' | k='water' | k='fashion' |
| ----: | ---- | ---- | ---- | ---- | 
|P(k\|'ice')|1.9E-4|6.6E-5|3.0E-3|1.7E-5|
|P(k\|'steam')|2.2E-5|7.8E-4|2.2E-3|1.8E-5|
|P(k\|'ice') / P(k\|'steam')|8.9E+0|8.5E-2|1.3E+0|9.6E-1|
 
Cost function:
$$
J = \sum_{i,j=1}^{V}f(X_{ij})(w_i^T\hat w_j + b_i +\hat b_j - log X_{ij})^2 
$$
where:
$$f(X_{ij}) \qquad \text{- weighting function}$$
$$w_i^T \hat w_j \qquad \text{- dot product of input/output vectors}$$
$$b_i + \hat b_j  \qquad \text{- bias term}$$
$$X_{ij} \qquad \text{\# of occurences of j in context i}$$

Training details are present in the paper below.
### Paper:
![](ml-resources/global-vectors-for-word-representations.pdf)

#### Links to this note:
- [[Word embedding]]