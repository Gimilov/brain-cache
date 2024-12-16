---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-14 21:00
# Definition

A **Bidirectional** LSTM is a sequence processing model that consists of two LSTMs: one taking the input in a forward direction, and the other in a backwards direction.
- BRNNs increase the amount of information available to the network
- able to catch patterns that may have been overlooked by one-direction RNN
![][nlp-bidirectional-rnn.png]
![][nlp-bidirectional-rnn-1.png]

| *… relying on knowledge of the future seems at first sight to violate causality. How can we base our understanding of what we’ve heard on something that hasn’t been said yet? However, human listeners do exactly that. **Sounds, words, and even whole sentences that at first mean nothing are found to make sense in the light of future context**. What we must remember is the distinction between tasks that are truly online – requiring an output after every input – and those where outputs are only needed at the end of some input segment* ¬ Graves&Schmidhuber|
|---| 

## Bidirectional RNN in Keras
```python
inputs = keras.Input(shape=(None,), dtype="int64")
embedded = layers.Embedding(
    input_dim=max_tokens, output_dim=256, mask_zero=True)(inputs)
x = layers.Bidirectional(layers.LSTM(32))(embedded)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
```

One thing that’s slightly hurting model performance here is that our input sequences are **full of zeros.**
- For example, we set `output_sequence_length=max_length` in `TextVectorization` (with max_length equal to 600)
- sentences **longer than 600 tokens are truncated** to a length of 600 tokens
- sentences **shorter than 600 tokens are padded with zeros at the end** so that they can be concatenated together with other sequences to form contiguous batches.

We are using Bidirectional RNNs:
- The RNN that looks at the tokens in their natural order will spend its last iterations seeing only vectors that encode padding—possibly for several hundreds of iterations if the original sentence was short.
- The information stored in the internal state of the RNN will gradually fade out as it gets exposed to these meaningless inputs.
We need a way to tell the RNN that it should skip these iterations.
- There is an API for that: **Masking**!
- We can get that from the `Embedding` layer - a tensor of ones and zeroes where a given mask indicates whether a given step should be skipped or not
#### Links to this note:
- [[LSTM (Long Short-Term Memory)]]
- [[Sequence models in NLP]]