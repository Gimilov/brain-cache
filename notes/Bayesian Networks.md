---
tags:
  - stats/bayesian_stats
  - type/moc
Context:
  - "[[Bayesian Statistics]]"
Excursions: 
Abstractions:
---
Created: 2023-10-14 17:39
# Map of Content

Bayesian networks could be used differently.
- A class of graphical models that allow a concise representation of the probabilistic dependencies  between a given set of random variables $X=\{X_1, X_2, ...,X_p\}$ as a directed acyclic graph ([[DAG for Bayesian Networks]]) (Nagarajan et al. 2013)
- A form of multivariate analysis that uses graphs to represent a model as a network of interactions between variables. 
- BN is a stochastic data-mining technique that applies knowledge from computer science, probability theory, information theory, logic, machine learning and statistics to obtain information for the construction of decision support systems.

Some other names for Bayesian Networks are Directed Graphs or Causal Networks. As name suggests, BNs are based on [[Bayes Theorem]].


# Characteristics of Bayesian Networks

1. The structure/DAG where $nodes=variables$ and $arcs=links=relationships$ .
2. The strength of these relationships is defined by the Conditional Probability Tables attached to each node.
![](/img/stats-bn.png)
![](/img/stats-bn-1.png)
Based on some exemplary data:
![](/img/stats-bn-2.png)

# Inference

When making inference, the analyst uses the **BN** to update the posterior probability in the light of new evidence.
Although not so evident at this point, this is one of the **essence of BN**: In the light of new evidence and conditioning on multiple variables, the use of BN facilitates the estimation of conditional probabilities in big networks
##### Quick example of conditional probabilities estimation and inference
Objective:
- A financial institution wants to build a BN to predict fraudulent use of a credit card by its customers
Previous knowledge:
- A credit card thief is more likely to buy gas and jewellery
- A middle age women is more likely to purchase jewellery

- Build the structure
- Define prior probabilities of the root nodes (Fraud, Age, Sex) and conditional probabilities of the children nodes (Gas, Jewellery) for every combination of the states of its parents
![](/img/stats-bn-inference.png)
![](/img/stats-bn-inference-1.png)







# Algorithms for classification
### 1. Naïve Bayes
Used to predict class membership probabilities based on the common aspects of each subject data (similar to logistic regression and discriminant analysis).
![](/img/stats-bn-naive-bayes.png)
### 2. Tree Augmented Naïve Bayes (TAN)
![](/img/stats-bn-tan.png)

# Algorithms focused on causality discovery
### 3. Constrained-based algorithms
To identify the causal structures in the observational data, when causes are present in the data.
- Data $\to$  Conditional Independence tests $\to$  DAG faithful to CI tests
- Faithfulness $=$ all and only the conditional independencies found in $P$ are entailed by DAG
- Several algorithms:
	- PC (Spirtes et al., 2001): the first practical application of the inductive causation (IC) algorithm by Verma and Pearl (1991)
	- Grow-Shrink (gs) (Margaritis, 2003)
	- Incremental Association (iamb) (Tsamardinos et al., 2003)
	- Fast Incremental Association (fast.iamb) (Yaramakala and Margaritis, 2005)
	- Interleaved Incremental Association (inter.iamb) (Tsamardinos et al., 2003)

**Causality Inference**
- Reliance on bivariate associations may be very misleading
- It is necessary to take a multivariate approach by including all relevant variables in the analysis so as to study both marginal and conditional associations.
- this is the basis of graphical modelling and Bayesian Networks.

For further analysis, we need to be able to identify [[Event Independence]]. Challenges of constrained-based algorithms are:
- these algorithms **require sufficient data** to learn conditional independencies with certainty
- the **errors** in conditional independence test can introduce biases (e.g. which is the best level of significance? 1%? 5? 10%?)
# Algorithms focused on prediction
### 4. Score-based algorithms
General heuristic optimization techniques useful for prediction.
- All possible DAGs are given the same probability of occurrence
- Given the data, the DAG with the highest network score is chosen
- **Several scores**:
	- Bayesian Information Criterion (BIC)
	- Akaike Information Criterion (AIC)
	- Bayesian Dirichlet Equivalent (BDe)
- **Several algorithms**:
	- Greedy search algorithms - Hill Climbing (hc) (Bouckaert, 1995)
	- Genetic algorithms (Larrananga et al., 1997)
	- Simulated annealing (Bouckaert, 1995)
	- A review of score algorithms can be found in Russel & Norvig (2009)






# How the information flows?

There are 3 principles or type of connections. Following these principles, it is possible to decide for any pair of variables whether they are independent given the evidence entered in the network.
### 1. Serial Connection
![](/img/stats-bn-serial-connection.png)
### 2. Discounting (Explaining away)
![](/img/stats-bn-explaining-away.png)
### 3. Divergent (Common cause)
![](/img/stats-bn-divergent.png)
### D-Separation concept
D-separation is a criterion for deciding whether a set X of variables is independent of another set Y, given one controls for a third set Z, using the three principles above.
### Examples
Examples can be explored here: [[Examples of BN information flows]].
Other example of [[Markov Blanket for Bayesian Networks]] and [[Markov Property]] can be explored here: [[Example of Markov Property in Bayesian Networks]]



# Summary of BN

- Internally, BN are represented as a DAG and a set of marginal and conditional probabilities
- We prefer using the conditional probabilities to joint probabilities because they are significantly less numerous
- Joint probabilities values increase exponentially with the number of variables
- Conditional probabilities values increase linearly with the number of variables
- Theorem 3.1: the joint distribution values can be easily computed from the conditional probabilities.
- Representing the joint probability distribution of the variables in the net, as a product of local probability distributions (either marginal, for root nodes, or conditional for nodes with parents),according to the arcs present in the graph makes BN a very efficient way to define the joint probability of multiple variables.

Applications of Bayesian Networks can be seen in [[Applications of Bayesian Networks]].