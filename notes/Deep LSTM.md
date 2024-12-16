---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-14 20:31
# Definition

Deep LSTMs were introduced by Graves et al. in their application of LSTMs to speech recognition, beating a benchmark on a challenging standard problem:

| *RNNs are inherently deep in time, since their hidden state is a function of all previous hidden states. The question that inspired this paper was whether RNNs could also benefit from depth in space; that is from stacking multiple recurrent hidden layers on top of each other, just as feedforward layers are stacked in conventional deep networks.*|
|-|

```python
inputs = keras.Input(shape=(None,), dtype="int64")
embedded = layers.Embedding(input_dim=max_tokens, output_dim=256)(inputs)
x = layers.LSTM(32, return_sequences=True)(embedded)
x = layers.LSTM(32, return_sequences=True)(x)
x = layers.LSTM(32)(x)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
```
$\uparrow$ remember to set $return_sequences=True$ to let each step return the full sequence.

#### Single LSTM vs Nested/Stacked LSTM
![][nlp-single-lstm.png]
$$vs.$$
![][nlp-nested-lstm.png]

#### Links to this note:
- [[LSTM (Long Short-Term Memory)]]