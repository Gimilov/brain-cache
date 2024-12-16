---
tags:
  - stats/bayesian_stats
  - type/theorem
Proved by: 
References:
  - "[[Product of the conditional distributions in Bayesian Networks]]"
Justifications: 
Specializations: 
Generalizations:
---
Created: 2023-10-14 18:11
# Theorem

A rule proposed by Thomas Bayes's theorem to update probabilities in the light of new evidence.
# Proof of Bayes Rule for events
$$ P(A|B)=P(A)*\frac{P(B|A)}{P(B)} $$
$$p(A|B) = \frac{p(A\cap B)}{p(B)} \qquad\qquad p(B|A)=\frac{p(A\cap B)}{p(A)}$$
Both equations include $p(A\cap B)$ , so we compare them.
$$p(A|B) \times p(B) = p(B|A)\times p(A)$$
what gives us the final result of:
$$p(A|B)=p(A) \times \frac{p(B|A)}{p(B)}$$

# Terminology
$$p(A|B)=p(A) \times \frac{p(B|A)}{p(B)}$$
A - effect
- $P(A)$ is the prior (unconditional probability), without taking into account any information about $B$ .
- $P(A|B)$ is the posterior (conditional probability of $A$, given $B$ ). It takes into account information about $B$. 

B - plausible cause or predictor
- $P(B)$ is the marginal probability of the $B$.
- $P(B|A)$ is the likelihood (conditional probability of $B$, given $A$ ). Why "likelihood"? It is not technically likelihood, but it is proportional to it, and as far as applying the Bayesian methodology is concerned, the distinction is not concerned. Hence why it is often referred to as the likelihood. Technically, the likelihood is a function of $A$ for a fixed data $B$ , say $L(A|B)$. However the likelihood is proportional to the sampling distribution, so $L(A|B) \propto p(B|A)$ .

# Proof of Bayes Rule for continuous RV

For two continuous random variables _X_ and _Y_, Bayes' theorem may be analogously derived from the definition of conditional density:
$$
f_{X|Y=y}(x)=\frac{f_{X,Y}(x,y)}{f_Y(y)}
$$
$$
f_{Y|X=x}(x)=\frac{f_{X,Y}(x,y)}{f_X(x)}
$$
Therefore,
$$
f_{X|Y=y}(x)=\frac{f_{Y|X=x}(y)f_X(x)}{f_Y(y)}
$$