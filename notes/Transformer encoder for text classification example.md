---
tags:
  - type/definition
  - ml/dl/nlp
---
Created: 2023-10-10 13:36
# Example

Load libraries:
```python
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
```
Then, we create a custom class called `TransformerEncoder`. This class inherits from `layers.Layer` class.
```python
class TransformerEncoder(layers.Layer):
    def __init__(self, embed_dim, dense_dim, num_heads, **kwargs):
      # create the Multi-Head Attention and Dense Projection sub-layers

    def call(self, inputs, mask=None):
      # define the forward pass of the Transformer Encoder

    def get_config(self):
      # make it possible to load and save the model
```

Below, we show the details of implementation.
First, the `__init__` method. It defines what the object contains when it is defined. 
```python
class TransformerEncoder(layers.Layer):
    def __init__(self, embed_dim, dense_dim, num_heads, **kwargs):
        super().__init__(**kwargs)
        self.embed_dim = embed_dim
        self.dense_dim = dense_dim
        self.num_heads = num_heads
        self.attention = layers.MultiHeadAttention(
            num_heads=num_heads, key_dim=embed_dim)
        self.dense_proj = keras.Sequential(
            [layers.Dense(dense_dim, activation="relu"),
             layers.Dense(embed_dim),]
        )
        self.layernorm_1 = layers.LayerNormalization()
        self.layernorm_2 = layers.LayerNormalization()
```
- `super().__init__(**kwargs)` is a call to the parent class `layers.Layer`
- It makes sure that any additional arguments are passed to `layers.Layer` using the `**kwargs` syntax
- Our new subclass takes three arguments:
- Size of input token vectors, size of the inner dense layer, and the no. of attention heads
- Create the multi-head attention layer
- `layers.MultiHeadAttention` is a built-in TensorFlow layer
- You know `keras.Sequential`! Here, we create a hidden and an outcome layer
- `dense_dim` controls the number of units in the hidden layer
- The output needs to match the no. of embedding dims
- We initialize two normalization layers
- Normalizing each sequence independently has proven to work better for sequences than `BatchNormalization`

Now, we define how to do a forward pass.
```python
    def call(self, inputs, mask=None):
        if mask is not None:
            mask = mask[:, tf.newaxis, :]
        attention_output = self.attention(
            inputs, inputs, attention_mask=mask)
        proj_input = self.layernorm_1(inputs + attention_output)
        proj_output = self.dense_proj(proj_input)
        return self.layernorm_2(proj_input + proj_output)
```
- `mask` is an optional argument that masks certain elements of the input sequence
- `mask[:, tf.newaxis, :]` effectively adds an extra dimension to the mask tensor to match the required shape for the attention mechanism in the Transformer Encoder.
- First, compute attention
- then, add a residual connection around the attention layer
- and do a layer normalization
- Now, a dense projection
- a finally a final residual connection followed by a layer normalization

The final part is just standard a “TensorFlowian” way of allowing our layer to be saved and loaded.
```python
    def get_config(self):
        config = super().get_config()
        config.update({
            "embed_dim": self.embed_dim,
            "num_heads": self.num_heads,
            "dense_dim": self.dense_dim,
        })
```

LET'S TRAIN.
```python
vocab_size = 20000
embed_dim = 256
num_heads = 2
dense_dim = 32

inputs = keras.Input(shape=(None,), dtype="int64")
x = layers.Embedding(vocab_size, embed_dim)(inputs)
x = TransformerEncoder(embed_dim, dense_dim, num_heads)(x)
x = layers.GlobalMaxPooling1D()(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
model.compile(optimizer="rmsprop",
              loss="binary_crossentropy",
              metrics=["accuracy"])
model.summary()
```
- specify global variables
- embedding
- then the Transformer layer we just made
- Pooling reduces each sentence returned by the transformer to a single vector for classification
- everything else is business as usual

We get 87.5% test accuracy. This is not as good as the bi-directional LSTM and notably less than the bi-gram approach. What are we missing here is injecting order information:
- we’ll learn position embedding vectors the same way we learn to embed word indices
- then we’ll add these position embeddings to the word embeddings
- the result is a **position-aware word embedding**
The implementation of positional embedding that we will use is explained here: [[Positional encoding#Keras Implementation]].
![][nlp-transformer-encoding.png]
Let's try again! Notice that `PositionalEmbedding` does the word embedding as well :)
```python
vocab_size = 20000
sequence_length = 600
embed_dim = 256
num_heads = 2
dense_dim = 32

inputs = keras.Input(shape=(None,), dtype="int64")
x = PositionalEmbedding(sequence_length, vocab_size, embed_dim)(inputs)
x = TransformerEncoder(embed_dim, dense_dim, num_heads)(x)
x = layers.GlobalMaxPooling1D()(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
model.compile(optimizer="rmsprop",
              loss="binary_crossentropy",
              metrics=["accuracy"])
model.summary()
```
- We now supply the sequence length
- and add the `PositionalEmbedding` layer just before `TransformerEncoder`
- We get to **88.3%** test accuracy - a solid improvement, but still worse than bag-of-words model for the same task. The reason is explained in [[Sequence vs. bag-of-words models]].