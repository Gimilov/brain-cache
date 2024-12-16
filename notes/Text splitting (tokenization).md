---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-09 14:12
# Definition

Once your word is standardized, you need to break it up into units to be vectorized (tokens), a step called tokenization. You could do this in three different ways:
- **Word-level tokenization** - Where tokens are space-separated (or punctuation separated) substrings.
- **N-gram** tokenization - Where tokens are groups of N consecutive words. For instance, *"the cat"* or *"he was"* would be 2-gram tokens (also called bigrams)
- **Character-level tokenization** - Where each character is its own token. In practice, this scheme is rarely used, and you only really see it in specialized contexts, like text generation or speech recognition.

In general, we'd always use either word-level on N-gram tokenization.

Since we already mentioned N-grams, let's note that there are two kinds of text-processing models:
- those that care about word order, called **sequence models**,
- and those that treat input words as a set, discarding their original order, called **bag-of-words models**.

N-gram example:

| Sentence | 2-gram | 3-gram |
|-----|-----|-----|
|"the cat sat on the mat"|{"the", "the cat", "cat", "cat sat", "sat", "sat on", "on", "on the", "the mat", "mat"}|{"the", "the cat", "cat", "cat sat", "the cat sat","sat", "sat on", "on", "cat sat on", "on the","sat on the", "the mat", "mat", "on the mat"}|


#### Code example:
The *TextVectorization* layer in Keras can be dropped directly into *tf.data* pipeline or a Keras model.
```python
from tensorflow.keras.layers import TextVectorization
text_vectorization = TextVectorization(
	output_mode="int",
)
# the above configures the layer to return sequences of words encoded as integer indices
# below it's shown how it can be used
datset = [
	"I write, erase, rewrite",
	"Erase again, and then",
	"A poppy blooms."
]
text_vectorization.adapt(dataset)
```

By default, *"convert to lowercase and remove punctuation"* for text standardization, and *"split on whitespace"* for tokenization
```python
>>> text_vectorization.get_vocabulary()
['',
'[UNK]',
'erase',
'write',
'then',
'rewrite',
'poppy',
'i',
'blooms',
'and',
'again',
'a']
```

Above, the first to entries are the mask token (index 0) and the OOV token (index 1). OOV means Out-Off-Vocabulary . Entries are sorted by frequency.

#### Normalization in bag-of-words approach

Sometimes we can improve on bag-of-words-models by taking into account how often a word occurs. Some words are bound to occur more often than others no matter what the text is about. Words like "the", "a", "is", "are" will always dominate your word count histograms, drowning out other words, despite being pretty much useless features in a classification context. 

We could standardize, but vectorized sentences consist almost entirely of of zeroes, which gives us computational speed and helps against overfitting. Standardizing would ruin this. Best practice is to use [[TF-IDF normalization]] . TF-IDF stands for "term frequency, inverse document frequency".

#### Summary

**There are better ways to vectorize the text. It will be mentioned in other notes. For example, Transformers use both word embedding and positional encoding for accurate, context-aware representations for sequence models.** 

#### Links to this note:
- [[From Raw Text To Numbers]]
- [[TF-IDF normalization]]