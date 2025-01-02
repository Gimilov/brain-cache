---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[Prototype Methods]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-27 17:53
# Definition

In this technique, prototypes are placed strategically with respect to the decision boundaries in an ad-hoc way. LVQ is an online algorithm - observations are processed one at the time. 

The idea is that the training points **attract** protypes of the correctly class, and **repel** other prototypes. When iterations settle down, prototypes should be close to the training points in their class. 

Figure below shows the result of LVQ, using the K-means solution as starting values. The procedure just described is actually called LVQ1. Modifications (LVQ2, LVQ3, etc.) have been proposed, that can sometimes improve performance. A drawback of learning vector quantization methods is the fact that they are defined by algorithms, rather than optimization of some fixed criteria; this makes it difficult to understand their properties.
![](/img/esl-figure-13.1.png)

# LVQ Algorithm
1. Choose $R$ initial prototypes for each class $m_1(k), m_2(k), \dots, m_R(k), k=1,2,\dots, K$ , for example, by sampling $R$ training points at random from each class. 
2. Sample a training point $x_i$ , randomly (with replacement), and let $(j,k)$ index the closest prototype $m_j(k)$ to $x_i$. 
	a) If $g_i=k$ (i.e., they are in the same class), move the prototype towards the training point: 
	$$ m_j(k) \leftarrow m_j(k) + \epsilon(x_i - m_j(k)), $$
	where $\epsilon$ is the learning rate.
	b) If $g_i \neq k$ (i.e., they are in different classes), move the prototype away from the training point: 
	$$ m_j(k) \leftarrow m_j(k) - \epsilon(x_i - m_j(k)), $$
3. Repeat step 2, decreasing the learning rate $\epsilon$ with each iteration towards zero (so it follows the guidelines for stochastic approximation learning rates).
# References
1.![](ml-resources/elements-of-statistical-learning.pdf#page=481]