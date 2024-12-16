---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-09 17:31
# Definition

Wouldn't it be great if instead of hard-code the words, we would train them instead? This way, we are making them more context aware, since we know which words tend to appear more in a given context? While it still lacks the information about the positions in the sentence, it greatly adds to our knowledge. We'll talk about positional encoding in a different note.

![][nlp-onehot-vs-embedding.png]

Word embeddings attempt to map human language onto a geometric space. The geometric relationship between word vectors (i.e. their distance and direction from each other) should reflect the semantic relationship between the words.

![][nlp-word-embeddings-geometric-space.png]
![][nlp-word-embedding-geometric-space-2.png]

There are two ways to obtain word embeddings:
1. Learn from the training data:
   - learn embeddings jointly with the main task,
   - start with random word vectors and then learn the word vectors like we learn the weights of an NN
2. Use pre-trained word embeddings:
   - when we have to little data, we can load **pre-computed embedding vectors**,
   - like using pre-trained convnets - not enough data available to truly learn powerful features, but we expect the features that we need to be fairly generic.

There are two very popular methods for word embedding:
1. [[word2vec]]
2. [[GloVe]]

Moreover, to truly unleash the power of word embedding, we shall combine them with sequence models!

#### Links to this note:
- [[From Raw Text To Numbers]]
