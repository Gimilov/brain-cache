---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-09 17:35
# Definition

Injecting order information:

- we’ll learn position embedding vectors the same way we learn to embed word indices
- then we’ll add these position embeddings to the word embeddings
- the result is a **position-aware word embedding**

# Keras Implementation
```python
class PositionalEmbedding(layers.Layer):
    def __init__(self, sequence_length, input_dim, output_dim, **kwargs):
      # create embeddings for for inputs and positions

    def call(self, inputs):
      # define the forward pass

    def compute_mask(self, inputs, mask=None):
      # returns a mask tensor that is True for all non-zero elements of 
      # the input sequence and False for all zero elements.

    def get_config(self):
      # allows saving and loading
```

```python
class PositionalEmbedding(layers.Layer):
    def __init__(self, sequence_length, input_dim, output_dim, **kwargs):
        super().__init__(**kwargs)
        self.token_embeddings = layers.Embedding(
            input_dim=input_dim, output_dim=output_dim)
        self.position_embeddings = layers.Embedding(
            input_dim=sequence_length, output_dim=output_dim)
        self.sequence_length = sequence_length
        self.input_dim = input_dim
        self.output_dim = output_dim
```
- We provide the length of the sentence to the class
- then two embedding layers: one for tokens and one for positions

```python
class PositionalEmbedding(layers.Layer):
    def __init__(self, sequence_length, input_dim, output_dim, **kwargs):
      # create embeddings for for inputs and positions

    def call(self, inputs):
        length = tf.shape(inputs)[-1]
        positions = tf.range(start=0, limit=length, delta=1)
        embedded_tokens = self.token_embeddings(inputs)
        embedded_positions = self.position_embeddings(positions)
        return embedded_tokens + embedded_positions  
```
- the length of the input sequence is determined using `tf.shape`
- next, a tensor of positions is generated: a sequence starting from `0` ending at `length-1`, incrementing by `1`.
- then we create the token and position embeddings
- and finally add them together

We can see it in action in [[Transformer encoder for text classification example]].


# Links to this note:
- [[From Raw Text To Numbers]]
