---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-16 01:33
# Definition

Gated recurrent units (GRUs) are a gating mechanism in recurrent neural networks, introduced in 2014 by Kyunghyun et al. The GRU is like a [[LSTM (Long Short-Term Memory)]] with a forget gate, but has fewer parameters than LSTM, as it lacks an output gate. GRU's performance on certain tasks of polyphonic music modelling, speech signal modelling and natural language processing was found to be similar to that of LSTM.  GRUs showed that gating is indeed helpful in general, and Bengio's team came to no concrete conclusion on which of the two gating units was better. 

# Architecture
![](/img/nlp-gru.png)
$$vs. Wikipedia's$$
![](/img/nlp-gru-wiki.png)
For Wikipedia's notation:
$$
z_t = \sigma(W_zx_t+U_zh_{t-1}+b_z)
$$
$$
r_t = \sigma(W_rx_t+U_rh_{t-1}+b_r)
$$
$$
\tilde h_t = \phi (W_hx_t + U_h(r_t \odot h_{t-1}) + b_h)
$$
$$
h_t = (1-z_t) \odot h_{t-1}+z_t \odot \tilde h_t
$$
Variables:
$$
x_t \quad \text{: input vector}
$$
$$
h_t \quad \text{: output vector}
$$
$$
\tilde h_t \quad \text{: candidate activation vector}
$$
$$z_t \quad \text{: update gate vector}$$
$$r_t \quad \text{: reset gate vector}$$
$$W,U \text{ and } b \quad \text{: parameter matrices and vector}$$
Activation functions:
$$\sigma \quad \text{: The original is a logistic function (i.e. sigmoid)}$$
$$\phi \quad \text{: The original is a hyperbolic tangent (i.e. tanh)}$$
Alternative activation functions are possible, provided that $\sigma (x) \in [0,1]$

Alternate GRU forms can be created by changing $z_t$ and $r_t$ :
- Type 1, each gate depends only on the previous hidden state and the bias,
  $z_t = \sigma(U_zh_{t-1}+b_z)$,   $r_t = \sigma(U_rh_{t-1} + b_r)$
  ![](/img/nlp-gru-type-1.png)
- Type 2, each gate depends only on the previous hidden state,
  $z_t = \sigma(U_zh_{t-1})$,   $r_t = \sigma(U_rh_{t-1})$
  ![](/img/nlp-gru-type-2.png)
- Type 3, each gate is computed using only the bias,
  $z_t=\sigma(b_z)$,   $r_t=\sigma(b_r)$
  ![](/img/nlp-gru-type-3.png) 



#### Links to this note:
- [[Sequence models in NLP]]
- [[LSTM (Long Short-Term Memory)]]