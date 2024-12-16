---
tags:
  - type/theorem
  - stats/bayesian_stats
Proved by:
  - "[[Bayes Theorem]]"
  - "[[Markov Property]]"
References: 
Justifications: 
Specializations: 
Generalizations:
---
Created: 2023-10-16 16:05
# Theorem

Owing to the [[Markov Property]] (and [[Bayes Theorem]]), the representation of the **joint probability** of a set of random variables (global distribution) can be expressed as a **product of the conditional distributions** of each variable given its parents in $G$ (graph), whenever these conditional distributions exist.
$$ P(X)= \prod^{p}_{i=1}P(X_i|\Pi_{X_i}) $$
, where $X = \{X_i\},\quad i=1:n, \quad \Pi_{X_i} = \{\text{parents of } X_i\}$  

# Example

![][stats-bn-product-of-conditional-distributions-example.png]
