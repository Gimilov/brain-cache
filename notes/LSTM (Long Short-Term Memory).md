---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-14 01:25
# Definition

Long Short-Term Memory (LSTM) algorithms are a variant of RNNs. They add a way to carry information across many timesteps by **saving information from older loops**. This helps fight the vanishing gradient problem.
![](/img/nlp-rnn-to-lstm.png)
# LSTM visualized:
1. The **forget gate** decides what information should be thrown away or kept.
![](/img/nlp-lstm-1.gif)
2. The **input gate** decides what information we're going to store in the cell state
   - "Which values to update?" (sigmoid)
   - "What would be the new values?" (tanh)
   - "Do the update!" (multiply)
![](/img/nlp-lstm-2.gif)
3. The cell state gets pointwise multiplied by the forget vector. This has a possibility of dropping values in the cell state if it gets multiplied by values near 0. 
![](/img/nlp-lstm-3.gif)
4. Then, we take the output from the input gate and do the pointwise addition which updates the cell state to new values that the neural network finds relevant.
![](/img/nlp-lstm-4.gif)
5. The **output gate** decides what **new information to pass along** as our hidden state.
   - Decide how to filter our current cell state (sigmoid)
   - Regulates our current cell state values (tanh)
   - Filter our cell state
![](/img/nlp-lstm-5.gif)


Intuition, such as above, is helpful to appreciate the architecture of a LSTM cell, but:
- what the cells actually do is determined by the contents of the weights
- and the weights are learned in an end-to-end fashion - starting over with each training round
- this makes it impossible to credit this and that operation with a specific purpose
- the specification of a cell **determines the space where we will search for a good model configuration during training (our hypothesis space)**
- the specification **does not** determine what the cell does - this is determined by the weights
- the same cell with **different weights** can do very different things!

Keep in mind what the LSTM cell is meant to do: allow past information to be injected at a later time, thus fighting the vanishing gradient problem
![](/img/nlp-rnn-lstm-vanishing-gradient-1.gif)

# Wikipedia snippet about LSTM with a forget gate
![](/img/nlp-lstm-wikipedia.png)
$$
f_t = \sigma_g (W_fx_t + U_fh_{t-1}+b_f)
$$
$$
i_t=\sigma_g(W_ix_t+U_ih_{t-1}+b_i)
$$
$$
o_t = \sigma_g (W_ox_t+U_oh_{t-1}+b_o)
$$
$$
\tilde c_t = \sigma_c (W_cx_t+U_ch_{t-1}+b_c)
$$
$$
c_t =f_t \odot c_{t-1}+i_t\odot \tilde c_t 
$$
$$
h_t = o_t \odot \sigma_h (c_t )
$$
where the initial values are $c_o=0$ and $h_0=0$ and the operator $\odot$ denotes the Hadamard product (element-wise product). The subscript t indexes the time step. Moreover:
$$
x_t \in \mathbb{R}^d \quad \text{: input vector to the LSTM unit}
$$
$$
f_t \in (0,1)^h \quad \text{: forget gate's activation vector}
$$
$$
i_t \in (0, 1)^h \quad \text{: input/update gate's activation vector}
$$
$$
o_t \in (0, 1)^h \quad \text{: output gate's activation vector}
$$
$$
h_t \in (-1, 1)^h \quad \text{: hidden state vector also known as output vector of the LSTM unit}
$$
$$
\tilde c_t \in (-1,1)^h \quad \text{: cell input activation vector}
$$
$$
c_t \in \mathbb{R}^h \quad \text{: cell state vector}
$$
$$
W \in \mathbb{R}^{h\times d}, \quad U \in \mathbb{R}^{h\times h}\quad and \quad b \in \mathbb{R}^h 
$$
$$
\quad \text{: weight matrices and bias vector parameters which need to be learned during training}
$$
where the superscripts $d$ and $h$ refer to the number of input features and number of hidden units, respectively. 
Finally, activation functions:
$$
\sigma_g \quad \text{: sigmoid function}
$$
$$
\sigma_c \quad \text{: hyperbolic tangent function}
$$
$$
\sigma_h \quad \text{: hyperbolic tangent function}
$$
Moreover, we could stack LSTMs, thereby creating [[Deep LSTM]]s or even create [[Bidirectional RNN (LSTM)]] that processes sequence in both directions!

#### Links to this note:
- [[Sequence models in NLP]]
- [[Deep LSTM]]
- [[Bidirectional RNN (LSTM)]]
- [[Gated Recurrent Unit (GRU)]]