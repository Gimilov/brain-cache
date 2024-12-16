---
tags:
  - type/definition
  - stats/bayesian_stats
Types: 
Examples:
  - "[[Example of Markov Property in Bayesian Networks]]"
Constructions: 
Generalizations: 
Properties:
  - "[[Markov Property]]"
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-16 15:20
# Definition

The Markov Blanket of a node includes:
- the parents of the node
- the children
- other parents of those children
![][stats-bn-markov-blanket.png]

The Markov Blanked of the node $X_i$ contains all the nodes that, if we know their states (i.e. we have evidence for these nodes), it will isolate the node $X_i$ from the rest of the network (i.e. it will make $X_i$ independent of all the other nodes given its Markov Blanket). Note the inclusion of other parents of its children - it's to avoid "discounting away" type of information flow.

It is the set of nodes that includes all the knowledge needed to do inference on the current node. 

Learning a Markov Blanket is particularly helpful when there is a large number of variables to select from in a dataset. It can also serve as a highly-efficient variable selection method in preparation for other types of modelling, e.g. Regression, Neural Nets, etc.

Technically, the Markov condition is **guaranteed by learning the DAG from the data**. The algorithms will construct a directed graph by catching the conditional independencies and drawing edges between variables that are not conditionally independent. However, if we had reason to believe that there is a **hidden cause** and this was not recorded in the dataset, and consequently not included in the graph, the Markov property will not hold. In that case, we cannot claim it is a causal BN network, although we can still use it as a predictor tool. See examples.

# Conclusion

In a causal Bayesian Networks, the [[Markov Property]] is satisfied given that **all common causes** are represented in the graph (i.e. there are no hidden common causes acting as confounding factors)q.

In our Season example, we can say there is no way for `Rain` to influence `Slippery` except by way of causing `Wet` or not. Thus, we can assume there is no hidden variable connecting `Rain` and `Slippery` . Every independency suggested by **lack of an arrow** between `Rain` and `Slippery` is actually **real in the system**.
![][stats-bn-information-flow-example-3.png]