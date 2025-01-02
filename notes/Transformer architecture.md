---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-05 19:36
# Definition

A transformer architecture consist of an encoder and decoder. Both of these relies on the [[Self-attention mechanism]]. A transformer encoder processes the source sequence, while Transformer decoder uses the source sequence to generate translated version.
![](/img/nlp-transformer.png)

|   | Word order awareness | Context awareness (cross-word interactions) |
| :---: | :---: | :---: |
| Bag-of-unigrams | No | No |
| Bag-of-bigrams | Very limited | No |
| RNN | Yes | No |
| Self-attention | No | Yes |
| Transformer | Yes | Yes |

The Transformer is a hybrid approach
- it’s technically **order-agnostic** (get the context from self-attention)
- but **injects order information** in the representations (we do this using [[Positional encoding]])
- we’ll learn position embedding vectors the same way we learn to embed word indices using [[Word embedding]]
- then we’ll add these position embeddings to the word embeddings
- the result is a **position-aware word embedding**

# Transformer Encoder
The `TransformerEncoder` chains together a `MultiHeadAttention` layer with a dense projection. It also adds normalization and residual connection.
![](/img/nlp-transformer-encoder.png)
For example. for text classification we need the encoder only. See [[Transformer encoder for text classification example]].


## References
![](attention-is-all-you-need.pdf)