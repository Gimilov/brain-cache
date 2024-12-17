---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-10-08 20:45
# Definition

1. `Query`, `key`, and `value` are sent through three independent sets of dense projection.
2. This results in three separate vectors
3. Each vector is processed via neural attention
4. Three outputs are concatenated back together into a single output sequence.

[Youtube Short](https://www.youtube.com/shorts/Muvjex0nkes)

>The self-attention mechanism allows the inputs to interact with each other (“self”) and find out who they should pay more attention to (“attention”). The outputs are aggregates of these interactions and attention scores

![](/img/nlp-multihead-attention.png)
Single head here, where the input is passed through these Linear/Dense layers to produce Q, K, and V matrices/vectors.
![](/img/nlp-multihead-attention-1.webp)
Another nice visualization:
![](/img/nlp-multihead-attention-vis.png)
![](/img/nlp-multihead-attention-4.webp.png)
here, however, the concatenation should be horizontal, not vertical and the matrix should be 7x9, not 21x3.

Having independent heads helps the layer **learn different groups of features for each token.** Features **within one group are correlated** with each other but **mostly independent from features in a different group**.

Where have we seen this before? **Deepthwise separable convolutions!**
Multi-head attention is the application of the same idea as depthwise seperable convolutions, but just applied to self-attention
- for depthwise separable convolutions we let subspaces be learned independently

# How exactly data is split across Attention Heads?

The data gets split across the multiple Attention heads so that each can process it independently.

However, the important thing to understand is that this is a **logical split only.** The `Query`, `Key,` and `Value` are not physically split into separate matrices, one for each Attention head. **A single data matrix is used for the `Query`, `Key`, and `Value`,** respectively, with logically separate sections of the matrix for each Attention head. Similarly, there are not separate Linear layers, one for each Attention head. All the Attention heads **share the same Linear layer** but simply operate **on their ‘own’ logical section of the data matrix.**

## **Linear layer weights are logically partitioned per head**

This logical split is done by partitioning the input data as well as the Linear/dense layer weights uniformly across the Attention heads. We can achieve this by choosing the Query Size as below:
$$\text{Query Size = Embedding Size / Number of heads}$$
![](/img/nlp-multihead-attention-2.webp)
In the example of 2 heads (for simplicity), we get $\text{Query Size} = 6/2=3$. Even though the layer weight (and input data) is a single matrix we can **think of** it as ‘stacking together’ the separate layer weights for each head.
![](/img/nlp-multihead-attention-3.webp)
The computations for all Heads can be therefore be achieved via a single matrix operation rather than requiring N separate operations. This makes the computations more efficient and keeps the model simple because fewer Linear layers are required, **while still achieving the power of the independent Attention heads**.
## **Reshaping the Q, K, and V matrices**

The Q, K, and V matrices output by the Linear layers are reshaped to include an explicit Head dimension. Now each ‘slice’ corresponds to a matrix per head.

This matrix is reshaped again by swapping the Head and Sequence dimensions. Although the Batch dimension is not drawn, the dimensions of Q are now (Batch, Head, Sequence, Query size).
![](/img/nlp-multihead-attention-5.webp)
The Q matrix is reshaped to include a Head dimension and then reshaped again by swapping the Head and Sequenced dimensions. (Image by Author)

In the picture below, we can see the complete process of splitting our example Q matrix, after coming out of the Linear layer.

The final stage is for visualization only — although the Q matrix is a single matrix, we can think of it as a logically separate Q matrix per head.
![](/img/nlp-multihead-attention-6.webp)
Q matrix split across the Attention Heads (Image by Author)

## Computing the Attention Score for each head

We now have the 3 matrices, Q, K, and V, split across the heads. These are used to compute the Attention Score.

We will show the computations for a single head using just the last two dimensions (Sequence and Query size) and skip the first two dimensions (Batch and Head). Essentially, we can imagine that the computations we’re looking at are getting ‘repeated’ for each head and for each sample in the batch (although, obviously, they are happening as a single matrix operation, and not as a loop).

The first step is to do a matrix multiplication between Q and K.
![](/img/nlp-multihead-attention-7.webp)
A Mask value is now added to the result. In the Encoder Self-attention, the mask is used to mask out the Padding values so that they don’t participate in the Attention Score.

Different masks are applied in the Decoder Self-attention and in the Decoder Encoder-Attention which we’ll come to a little later in the flow.
![](/img/nlp-multihead-attention-8.webp)
The result is now scaled by dividing by the square root of the Query size, and then a Softmax is applied to it. Another matrix multiplication is performed between the output of the Softmax and the V matrix.
![](/img/nlp-multihead-attention-9.webp)
The complete Attention Score calculation in the Encoder Self-attention is as below:
![](/img/nlp-multihead-attention-10.webp)

## Merge each Head's Attention Scores together

We now have separate Attention Scores for each head, which need to be combined together into a single score. This Merge operation is essentially the reverse of the Split operation.

It is done by simply reshaping the result matrix to eliminate the Head dimension. The steps are:

- Reshape the Attention Score matrix by swapping the Head and Sequence dimensions. In other words, the matrix shape goes from (Batch, Head, Sequence, Query size) to (Batch, Sequence, Head, Query size).
- Collapse the Head dimension by reshaping to (Batch, Sequence, Head * Query size). This effectively concatenates the Attention Score vectors for each head into a single merged Attention Score.

Since Embedding $size =Head * Query size$, the merged Score is (Batch, Sequence, Embedding size). In the picture below, we can see the complete process of merging for the example Score matrix.
![](/img/nlp-multihead-attention-11.webp)

## End-to-end Multi-head Attention
Putting it all together, this is the end-to-end flow of the Multi-head Attention.
![](/img/nlp-multihead-attention-12.webp)


## Additional: Decoder Self-Attention and Masking
The Decoder Self-Attention works just like the Encoder Self-Attention, except that it operates on each word of the target sequence.
![](/img/nlp-multihead-attention-13.webp)
Similarly, the Masking masks out the Padding words in the target sequence.

## Additional: Encoder-Decoder Attention and Masking

The Encoder-Decoder Attention takes its input from two sources. Therefore, unlike the Encoder Self-Attention, which computes the interaction between each input word with other input words, and Decoder Self-Attention which computes the interaction between each target word with other target words, the Encoder-Decoder Attention computes the interaction between each target word with each input word.
![](/img/nlp-multihead-attention-14.webp)
Therefore each cell in the resulting Attention Score corresponds to the interaction between one Q (ie. target sequence word) with all other K (ie. input sequence) words and all V (ie. input sequence) words.

Similarly, the Masking masks out the later words in the target output, as was explained in detail in the [second article](https://towardsdatascience.com/transformers-explained-visually-part-2-how-it-works-step-by-step-b49fa4a64f34) of the series.




# Source
[SOURCE](https://towardsdatascience.com/transformers-explained-visually-part-3-multi-head-attention-deep-dive-1c1ff1024853)
