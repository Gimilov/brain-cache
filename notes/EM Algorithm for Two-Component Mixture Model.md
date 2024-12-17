---
tags:
  - type/definition
  - ml
  - stats
Types: 
Examples: 
Constructions: 
Generalizations:
  - "[[EM Algorithm in General]]"
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-24 20:11
# Definition

## Context
The EM algorithm is a popular tool for simplifying difficult maximum likelihood problems. We first describe it in a context of a simple mixture model.
![](/img/esl-figure-8.5.png)

We can see from the distribution that there is bi-modality in the data, therefore a Gaussian distribution would not be appropriate. Since there seems to be two separate underlying regimes, we model $Y$ as a mixture of two normal distributions:
$$Y_1 \sim N(\mu_1, \sigma_1^2)$$
$$Y_2 \sim N(\mu_2, \sigma_2^2)$$
$$Y = (1-\Delta) \cdot Y_1 + \Delta \cdot Y_2$$
where $\Delta \in \{0,1\}$ with $Pr(\Delta = 1) = \pi$ . This generative representation is explicit: generate a $\Delta \in \{0, 1\}$ with probability $\pi$ , and then depending on the outcome, deliver either $Y_1$ or $Y_2$ .  It is as if we are going to model the $\pi$ itself to know from which distribution a given observation is.

Let $\phi_\theta(x)$ denote the normal density with parameters $\theta = (\mu, \sigma^2)$ . Then the density of $Y$ is:
$$
g_Y(y)=(1-\pi)\phi_{\theta_1}(y)+ \pi\phi_{\theta_2}(y)
$$
Now, suppose we wish to fit this model to the data shown in the figure above by maximum likelihood. The parameters are
$$
\theta = (\pi, \theta_1, \theta_2) = (\pi, \mu_1, \sigma_1^2,\mu_2,\sigma_2^2)
$$
The log likelihood based on the N training cases is
$$
\mathscr{l}(\theta; \mathbf{Z}) = \sum_{i=1}^N log [(1-\pi)\phi_{\theta_1}(y_i)+ \pi\phi_{\theta_2}(y_i)]
$$
Direct maximization of $\mathscr{l}(\theta; \mathbf{Z})$ is quite difficult numerically, because of the sum terms inside the logarithm. There is a simpler approach. Suppose we knew the values of $\Delta_i$'s. Then the log-likelihood would be:
$$
\mathscr{l}_0(\theta; \mathbf{Z}, \mathbf{\Delta}) = \sum_{i=1}^N\bigg[(1- \Delta_i)log \phi_{\theta_1}(y_i) + \Delta_i log \phi_{\theta_2}(y_i)\bigg]
$$
$$ + \sum^N_{i=1}\bigg[(1-\Delta_i)log(1-\pi) + \Delta_ilog\pi\bigg]$$
and the maximum likelihood estimates of $\mu_1$ and $\sigma_1^2$ would be the sample mean and variance for those data with $\Delta_i = 0$ , and similarly those for $\mu_2$ and $\sigma_2^2$ would be the sample mean and variance of the data with $\Delta_i = 1$ . The estimate of $\pi$ would be the proportion of $\Delta_i = 1$ .
Since the values of $\Delta_i$'s are actually unknown, we proceed in an iterative fashion, substituting for each $\Delta_i$ in equation above its expected value:
$$
\gamma_i(\theta) = E(\Delta_i|\theta, \mathbf{Z}) = Pr(\Delta_i=1|\theta, \mathbf{Z})
$$
also called the responsibility of model 2 for observation $i$. We use a procedure called EM algorithm for the special case of Gaussian mixtures. In the **expectation step**, we do a soft assignment of each observation to each model: the current estimates of the parameters are used to assign responsibilities according to the relative density of the training points under each model. In the **maximization step**, these responsibilities are used in weighted maximum-likelihood fits to update the estimates of the parameters.

## EM algorithm
1. Take initial guesses for the parameters $\hat \mu_1$ , $\hat \sigma_1^2$ , $\hat \mu_2$ , $\hat \sigma_2^2$ , $\hat \pi$ (see text)
2. Expectation step: compute the responsibilities
$$
\hat \gamma_i = \frac{\hat \pi \phi_{\hat \theta_2}(y_i)}{(1-\hat \pi)\phi_{\hat \theta_1}(y_i)+\hat\pi\phi_{\hat \theta_2}(y_u)}, i=1,2,\dots, N.
$$
3. Maximization Step: compute the weighted means and variances:
$$
\hat \mu_1=\frac{\sum_{i=1}^N(1-\hat \gamma_i)y_i}{\sum_{i=1}^N(1-\hat\gamma_i)} \qquad \qquad \hat\sigma_1^2=\frac{\sum_{i=1}^N(1-\hat\gamma_1)(y_i-\hat\mu_1)^2}{\sum_{i=1}^N(1-\hat\gamma_1)}
$$
$$
\hat \mu_2=\frac{\sum_{i=1}^N\hat \gamma_iy_i}{\sum_{i=1}^N\hat\gamma_i} \qquad \qquad \hat\sigma_2^2=\frac{\sum_{i=1}^N\hat\gamma_1(y_i-\hat\mu_2)^2}{\sum_{i=1}^N\hat\gamma_i}
$$
and the mixing probability $\hat \pi = \sum_{i=1}^N \hat \gamma_i / N$. 
4. Iterate steps 2 and 3 until convergence

A good way to construct initial guesses for $\hat \mu_1$ and $\hat \mu_2$ is simply to choose two of $y_i$ at random. Both $\hat \sigma_1^2$ and $\hat \sigma_2^2$ can be set equal to the overall sample variance $\sum_{i=1}^N (y_i-\overline y)^2/N$. The mixing proportion $\hat \pi$ can be started at the value of $0.5$. 

Note that the actual maximizer of the likelihood occurs when we put spike of infinite height at any of the data point, that is $\hat \mu_1 = y_i$ for some $i$ and $\hat \sigma_1^2 = 0$ . This gives infinite likelihood, but is not a useful solution. Hence, we are actually looking for a good local maximum of the likelihood, one for which $\hat \sigma_1^2 , \hat \sigma_2^2 > 0$ . To further complicate matters, the re can be more than one local maximum having $\hat \sigma_1^2 , \hat \sigma_2^2 > 0$ . In our example , we ran the EM algorithm with a number of different initial guess for the parameters, all having $\hat \sigma_k^2 > 0.5$ , and chose the run that gave us the highest maximized likelihood. Figure below shows the progress of EM algorithm in maximizing the log-likelihood. The table shows $\hat \pi = \sum_i \hat \gamma/N$ , the maximum likelihood estimate of the proportion of  observations in class $2$ , at selected iterations of the EM procedure.
![](/img/esl-figure-8.6.png)

| Iteration | Proportion |
| :---: | :---: |
| 1 | 0.485 |
| 5 | 0.493 |
| 10 | 0.523 |
| 15 | 0.544 |
| 20 | 0. 546 |

The final maximum likelihood estimates are:
$$
\hat \mu_1 = 4.62, \qquad \qquad \hat \sigma_1^2 = 0.87
$$
$$
\hat \mu_2 = 1.06, \qquad \qquad \hat \sigma_2^2 = 0.77
$$
In the first figure of this note we can actually see the estimated Gaussian mixture density from this procedure, along with the responsibilities.
# References
1.![](/img/ml-resources/elements-of-statistical-learning.pdf#page=291]