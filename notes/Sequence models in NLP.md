---
tags:
  - ml/dl/nlp
  - type/moc
---
Created: 2023-09-14 00:09
# Map of Content

While there are some applications of classic feed-forward networks in NLP, such as bag-of-words models, current state-of-the-art models rely on sequence models. 

| Feed-forward Network | Recurrent Neural Network |
| --- | --- |
| - No memory | - Iterating through a sequence of elements |
| - Each instance is treated independently | - Maintain a state, containing information relative to what it has seen so far |
| - The entire sequence must be presented in a single instance | - The input is no longer processed in a single step |
| - Each instance so far has been a complete movie review | - The network internally loops over sequence elements |
|  | - One sequence is still a single datapoint; the state of RNN is reset between processing two different, independent sequences (i.e. two different reviews) |


```python
# dense network
output = relu(dot(W, input) + b)

# RNN
output = activation(dot(w, input) + dot(U, state_t) + b)
```
$\uparrow$ new set of parameters U, which adjust the output depending on the previous timestep

A RNN is basically a for-loop that reuses quantities computed during the previous iteration of the loop. That passing of information is called **a hidden state**. It is commonly analogized to "memory".
![][nlp-rnn-1.gif]
![][nlp-rnn-2.gif]
Why tanh not ReLU?
- Exploding gradient issue: Unbounded activations may explode in RNNs. Tanh helps keep the outputs stable and bounded.
![][nlp-rnn-exploding-gradient-2.gif]
![][nlp-rnn-exploding-gradient-1.gif]
RNNs still suffer from the **vanishing gradient problem**: we process a long piece of text, but the most vital information lies in the beginning. The simple RNN cannot learn long-term dependencies - it has no long term memory! Hence, the introduction of [[LSTM (Long Short-Term Memory)]]. 

Another ground-breaking sequence model is a [[Transformer architecture]] that allows the usage of encoder and a decoder (both or separately) to achieve different tasks. However, even with a technique as powerful as transformers, we still may get better results from something as simple as bag-of-words model, as shown in [[Sequence vs. bag-of-words models]].

[[Sequence to Sequence models (seq2seq)]] is a special class of Recurrent Neural Network architectures that we typically use (but not restricted) to solve complex Language problems like Machine Translation, Question Answering, creating Chatbots, Text Summarization, etc
## Basic sequence model in Keras 
```python
inputs = keras.Input(shape(None,), dtype="int64")
embedded = layers.Embedding(input_dim=max_tokens, output_dim=256)(inputs)
x = layers.LSTM(32)(embedded)
x = layers.Dropout(0.5)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = keras.Model(inputs, outputs)
```
$\uparrow$ what does the no. of units mean in LSTM layer?
![][nlp-sequence-model-units.png]
The number of units we specify in a recurrent layer is analogous to feature maps in CNNs.
- Each unit will be a full sequence of RNN cells 
- Each unit will have its own weight matrix
- Results in different features of the sequence to be emphasized 

#### Links to this note:
- [[Natural Language Processing]]
- [[LSTM (Long Short-Term Memory)]]
- [[Bidirectional RNN (LSTM)]]
- [[Gated Recurrent Unit (GRU)]]
- [[Transformer architecture]]
- [[Sequence vs. bag-of-words models]]
- [[Sequence to Sequence models (seq2seq)]]