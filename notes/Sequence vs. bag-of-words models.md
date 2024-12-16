---
tags:
  - type/example
  - ml/dl/nlp
---
Created: 2023-10-10 18:09
# Example

As mentioned in [[Sequence models in NLP]] and [[Transformer encoder for text classification example]], sometimes something as simple as bag-of-words model may outperform transformers. Why is that?

A small stack of `Dense` layers on top of a bag-of-bigrams was the best performing model for some arbitrary example that we've run in these notes (the data itself is not really relevant)
- when do prefer one over the other for **text classification**?
$$
\frac{\text{Number of samples}}{\text{Mean sample length}} = 
\begin{cases}
	\text{>1500}        & \quad \to \text{Sequence model}\\
	\text{<1500}        & \quad \to \text{Bag-of-bigrams}
\end{cases}
$$
- The ratio of between sample size and avg no. of words pr. sample
- if this ratio is small, bag-of-words is better
- if this ratio is larger than 1,500, sequence model is better

#### Sequence models work best when lots of training data is available and each sample is relatively short
- Example with IMDB: 20,000 training samples and an average word count of 233. The result is less than 1,500 (about 86), which confirms what we have found in practice.
- Classifying tweets that are 40 words on average and we have 50,000 (a ratio of 1,250), we go with a bag-of-words model
- But increase the dataset size to 500,000 tweets (a ratio of 12,500), and we should go with a sequence model

#### Intuition:
- The input of a sequence model represents a richer and more complex space, and thus it takes more data to map out that space
- The shorter a sample is, the less the model can afford to discard any of the information it contains - in particular, word order becomes more important, and discarding it can create ambiguity.
- The sentences “this movie is the bomb” and “this movie was a bomb” have very close unigram representations, which could confuse a bag-of-words model, but a sequence model could tell which one is negative and which one is positive.
- With a longer sample, word statistics would become more reliable and the topic or sentiment would be more apparent from the word histogram alone.
