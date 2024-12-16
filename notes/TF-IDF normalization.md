---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-09 16:00
# Definition

TF-IDF stands for "Term Frequency, Inverse Document Frequency". It aims to give less attention to the useless-for-classification words like "a", "the" etc. Terms that appear in almost every document (like "the" or "a") aren't particularly informative while terms that appear in only small of all texts (like "Herzog") are very distinctive, and thus important.

TF-IDF is a metric that fuses two ideas: 
- weights a given term by taking "term frequency" - how many times the term appears in the current document,
- dividing it by a measure of "document frequency" - which estimates how often the term comes up across the dataset.

$$
w_{x,y} = tf_{x,y}\;*log(\frac{N}{df_x})
$$
$$
\text{TF-IDF - "Term x within document y"}
$$
$$
tf_{x,y}=\text{frequency of x in y}
$$
$$
df_y=\text{number of documents containing x}
$$
$$
\text{N=total number of documents}
$$

#### Python/Keras example
```python
text_vectorization = TextVectorization(
	ngrams=2,
	max_tokens=20000,
	output_mode="tf_idf"
)
```
For many text-classification datasets, it would be typical to see one-percentage-point increase when using TF-IDF compared to plain binary encoding.

#### Links to this note:
[[Text splitting (tokenization)]]