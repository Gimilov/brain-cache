---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-10-08 17:41
# Definition

Not all input information seen by a model is equally important to the task at hand, so models should "pay model attention" to some features and "pay less attention" to other features. 

Seems familiar? Well, we have encountered this idea before. 
- **Max pooling** in convnets looks at a pool of features in a spatial region and selects just one feature to keep. It's like **"All or nothing"** form of attention.
- **TF-IDF normalization** assigns importance scores to tokens based on how much information different tokens are likely to carry. It's like **a continuous** form of attention.

Attention can be used to make features **context-aware**. Word embeddings have fixed positions (i.e. fixed relationships with every other word), but that's **not** how language works.
###### Example of word meaning discrepancy
The meaning of the word "see":
- "I'll see you soon"
- "I'll see this project to its end"
and of course, "he", "it", "in", etc. are entirely sentence specific.
- and can even change meaning multiple times within a single sentence.


A smart embedding space would provide a different vector representation for a word depending on the other words surrounding it. That's where the attention comes in! 

The self-attention mechanism allows the inputs to interact with each other ("self") and find out who they should pay more attention to ("attention"). The outputs are aggregates of these interactions and attention scores. We may strive for bigger hypothesis space and allow the `query`, `key`, and `value` to be sent through X independent sets of dense projection using [[Multi-head attention]].

# Self-attention in action
> "The train left the station on time."

Consider the word "station".
- What kind of station? Is a radio station? The international Space Station?
- We can use self-attention to figure that out.
![][nlp-self-attention-in-action.png]
The resulting vector is our new representation for the word "station". 
- a representation that includes the surrounding context
- a representation that includes part of the "train" vector, clarifying that it is a "train station"
## Self-attention in action - Keras implementation
Here is our Keras implementation
```python
num_heads = 4
embed_dim = 256
mha_layer = MultiHeadAttention(num_heads=num_heads, key_dim=embed_dim)
outputs = mha_layer(inputs,inputs,inputs)
```
Why four heads in attention? Why pass the inputs three times? Let's explain it in the section below.

## QUERY-KEY-VALUE model
In the example above, the inputs are used three times.
```python
outputs=sum(inputs_C * pairwise_scores(inputs_A, inputs_B))
```
"For each token in `inputs_A`, compute how much the token is related to every token in  `inputs_B` and use these scores to weight a sum of tokens from `input_C`". 

Or, in other words,

"For each token in the `query`, compute how much the token is related to every token in the `key` and use these scores to weight the sum of tokens from `values`".

A transformer-style attention is basically this:
1. You've got a reference sequence that describes something you are looking for: the `query`.
2. You've got a body of knowledge that you're trying to extract the information from: the `values`.
3. Each value is assigned a `key` that describes the `value` in a format that can be readily compared to `query`.
4. You match the `query` to the `keys`.
5. You return the weight sum of `values`.

In case of text classification, `query`, `key`, and `values` are all the same. You're comparing sequence to itself, to enrich each token with the context of the whole sentence.

In case of translation, the `query` would be the target sequence, and the source sequence would play the roles of both `keys` and `values`.



# Visualizing attention
Since we are are making `query`, `key` , and `value` representations out of single input, it is adequate to the example above regarding the text classification.
![][nlp-visualizing-attention-1.webp]
```python
# 4D embeddings for each word
Input 1: [1, 0, 1, 0] # word 1 (the)
Input 2: [0, 2, 0, 2] # word 2 (cat)
Input 3: [1, 1, 1, 1] # word 3 (sat)
```
Now, we need weights. We make up some random weights for `key`, `query`, and `value`. 
```python
# key weights
[[0, 0, 1],
 [1, 1, 0],
 [0, 1, 0],
 [1, 1, 0]]
# query weights
[[1, 0, 1],
 [1, 0, 0],
 [0, 0, 1],
 [0, 1, 1]]
# value weights
[[0, 2, 0],
 [0, 3, 0],
 [1, 0, 3],
 [1, 1, 0]]
```
![][nlp-visualizing-attention-2.gif]
Get the key representation for all inputs. We stack the inputs into a matrix and multiply each weight matrix by one input matrix. A 3x4 matrix multiplies by 4x3 matrix, resulting in 3x3 matrix. 
```python
# Key representation          
               [0, 0, 1]
[1, 0, 1, 0]   [1, 1, 0]   [0, 1, 1]
[0, 2, 0, 2] x [0, 1, 0] = [4, 4, 0]
[1, 1, 1, 1]   [1, 1, 0]   [2, 3, 1]
```
![][nlp-visualizing-attention-3.gif]
```python
# Value representation          
               [0, 2, 0]
[1, 0, 1, 0]   [0, 3, 0]   [1, 2, 3] 
[0, 2, 0, 2] x [1, 0, 3] = [2, 8, 0]
[1, 1, 1, 1]   [1, 1, 0]   [2, 6, 3]
```
![][nlp-visualizing-attention-4.gif]
```python
# Query representation          
               [1, 0, 1]
[1, 0, 1, 0]   [1, 0, 0]   [1, 0, 2]
[0, 2, 0, 2] x [0, 0, 1] = [2, 2, 2]
[1, 1, 1, 1]   [0, 1, 1]   [2, 1, 3]
```
![][nlp-visualizing-attention-5.gif]
Compute attention scores by taking the dot product between input 1's `query` (red) with all `keys` (orange), including itself. 3 `keys` representations $\to$ 3 attention scores.
```python
# We only use the query from Input 1.
            [0, 4, 2]
[1, 0, 2] x [1, 4, 3] = [2, 4, 4]
            [1, 0, 1]
```
![][nlp-visualizing-attention-6.gif]
```python
# Move attention scores through the softmax function
softmax([2, 4, 4]) = [0.0, 0.5, 0.5]
```
![][nlp-visualizing-attention-7.gif]
Multiply scores with values. The softmaxed attention scores for each input (blue) is multiplied by its corresponding `value` (purple). The result is 3 vectors (yellow) with weighted `values`. 
```python
# Multiply scores with values
1: 0.0 * [1, 2, 3] = [0.0, 0.0, 0.0]
2: 0.5 * [2, 8, 0] = [1.0, 4.0, 0.0]
3: 0.5 * [2, 6, 3] = [1.0, 3.0, 1.5]
```
![][nlp-visualizing-attention-8.gif]
Sum weighted values to get Output #1. Take all the weighted `values` (yellow) and sum them element-wise.
```python
  [0.0, 0.0, 0.0]
+ [1.0, 4.0, 0.0]
+ [1.0, 3.0, 1.5]
-----------------
= [2.0, 7.0, 1.5]
```
Output 1 is the new embedding vector for Input #1. It's based on the query representation from Input #1 interacting with all other keys including itself.
![][nlp-visualizing-attention-9.gif]
Now we repeat for Output #2 and Output #3 and BOOM!