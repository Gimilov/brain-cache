---
tags:
  - ml/dl/nlp
  - type/definition
---
Created: 2023-09-08 23:47
# Definition

Text standardization is a basic form of feature engineering that aims to erase encoding differences that you don't want your model to have to deal with.

Two almost identical sentences:
- *"sunset came. i was staring at the Mexico sky. Isnt nature splendid??"*
- *"Sunset came; I stared at the México sky. Isn't nature spledid?"*
If you were to convert them to byte strings, they would end up with very different representations, because *"i"* and *"I"* are two different characters, *"Mexico"* and *"México"* are two different words and so on.

One of the **simplest** and **most widespread** standardization schemes is ***convert to lowercase and remove punctuation characters.*** Then, our two sentences become the same:
- *"sunset came i was staring at the mexico sky isnt nature splendid"*

| Pros          | Cons          |
| ----------- | -----------|
| Your model will require less training data and will generalize better | Standardization may also erase some amount of information | 
|it won't need abundant examples of both "Sunset" and "sunset" to learn that they mean the same thing, and it will be able to make sense of "México" even if it has only seen "mexico" in its training set| if you're writing a model that extracts questions from interview articles, it should definitely treat "?" as a separate token instead of dropping it, because it's a useful signal for this specific task|

#### Links to this note:
- [[From Raw Text To Numbers]]