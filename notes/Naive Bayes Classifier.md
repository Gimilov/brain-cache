---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[Univariate Kernel Density Classification]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-24 00:44
# Definition

Popular over years. It is especially appropriate when dimension p of the feature space is high, making density estimation unattractive (curse of dimensionality!). The naïve Bayes model assumes that given a class $G = j$ , the features $X_k$ are independent:
$$
f_j(X) = \prod_{k=1}^p f_{jk}(X_k)
$$
It is like to say: "Multiply each feature probabilities of belonging to class $j$".

While this is generally not true, it does simplify the estimation dramatically: 
- the individual class-conditional marginal densities $f_{jk}$ can each be estimated separately using one-dimensional kernel density estimates. **This is in fact generalization of the original naive Bayes procedures, which used univariate Gaussians to represent these marginals.**
- If a component $X_j$ of $X$ is discrete, then an appropriate histogram estimate can be used. This provides a seamless way of mixing variable types in feature vector.

Despite optimistic assumptions, Naive Bayes classifier often outperform far more sophisticated alternatives. The reason relates to the graph below, where although the individual class density estimates may be biased, this bias might not hurt the posterior probabilities as much, especially near the decision regions. In fact **the problem may be able to withstand considerable bias for the savings in variance such a "naive"  assumption earns.**
![](/img/esl-figure-6.15.png)

We can derive a logit transform from a formula above (using class $J$ as the base):
$$
\log{\frac{Pr(G=\mathscr{l}|X)}{Pr(G=J|X)}} = \log{\frac{\pi_\mathscr{l}f_\mathscr{l}(X)}{\pi_Jf_j(X)}}
$$
$$
= \log{\frac{\pi_\mathscr{l}\prod^{p}_{k=1}f_{\mathscr{l}k}(X_k)}{\pi_J\prod_{k=1}^pf_{Jk}(X_k)}} = \log{\frac{\pi_\mathscr{l}}{\pi_J}} + \sum_{k=1}^p\log{\frac{f_{\mathscr{l}k}(X_k)}{f_{Jk}(X_k)}}
$$
$$
= \alpha_\mathscr{l} + \sum_{k=1}^p g_{\mathscr{l}k}(X_k)
$$
This has the form of a [[Generalized Additive Model]] . The models are fit in quite different ways though. The relationship between naive Bayes and generalized additive models is analogous to that between linear discriminant analysis and logistic regression. 
# References
1.![](ml-resources/elements-of-statistical-learning.pdf#page=229]