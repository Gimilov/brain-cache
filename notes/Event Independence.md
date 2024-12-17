---
tags:
  - stats
  - type/proposition
Proved by: 
References: 
Justifications: 
Specializations: 
Generalizations:
---
Created: 2023-10-14 18:14
## Proposition

$X, Y$ - independent events if
$$
\begin{cases}
P(X\cap Y)=P(X)*P(Y) \quad or \\
P(Y|X)= P(Y)
\end{cases}
$$
$X \in \{x_1, x_2\}$ and $Y \in \{y_1, y_2\}$ are independent r.v if:
$$
\begin{cases}
P(X\cap Y)=P(X)*P(Y) \quad or \\
P(Y|X)= P(Y)
\end{cases}
$$
for all values of $X$ and $Y$ .

If $X,Y$ are independent continuous random variables, then
$$
\begin{cases}
f(x,y) = f(x) * f(y) \quad or \\
f(y|x) = f(y)
\end{cases}
$$

If the two categorical variables are **independent**, in each cell of the contingency table, the joint probability is equal to the product of the corresponding marginal probabilities.
![](/img/stats-independence.png)

Often, it is preferred the characterization of independent variables that does not involve the density of $X$, that is:
$$P(Y|X)=P(Y)$$
$$f(y|x)=f(y)$$
Literally meaning that the marginal probability of $Y$ does not change as a function of $X$.

Moreover, $X$ and $Y$ are **conditionally independent** given $Z$ , if for each value of $Z, X$ and $Y$ are independent.
$$X \perp Y|Z$$

# Example

As illustration, consider some data from a study of health and social characteristics of Danish 70-year-olds. Representative samples were taken in 1967 and again - on a new cohort of 70-year-olds - in 1984. Body mass index (BMI) is a simple measure of obesity, defined as $weight/height^2$ . It is of interest to compare the distribution between males and females, and between the two years of sampling. Hence, we have 3 variables:
- BMI - continuous
- Gender - discrete
- Year - discrete
1. BMI does not change neither by gender nor by year $\to$ var are independent.
$$f_{11}=f_{21}=f_{12}=f_{22}$$ $$ BMI \perp (Gender,Year) $$
$$(Gender) \qquad \qquad (Year) \qquad \qquad (BMI)$$
2. If BMI distribution changes by gender but **does not change by year** given we control for gender. $$f_{11}=f_{12} \quad and \quad f_{21}=f_{22}$$
$$ BMI \perp Year|Gender $$
$$(Gender) \to (Year) \to (BMI)$$
