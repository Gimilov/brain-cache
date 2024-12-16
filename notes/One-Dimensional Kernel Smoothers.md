---
tags:
  - type/definition
  - stats
  - ml
Types: 
Examples: 
Constructions: 
Generalizations: []
Properties: 
Sufficiencies: 
Equivalences: 
Justifications:
---
Created: 2023-10-22 21:13
# Definition

The point of estimating a kernel smoothed distribution can range from something as plain as data visualisation to even classification. There are differences in how are these estimated based on different kernels and how are the neighbouring points treated.
### KNN average
$$
\hat f(x) = Ave(y_i|x_i \in N_k(x))
$$
An estimate of regression function $E(Y|X=x)$. Here, $N_k(x)$ is the set of $k$ points nearest to $x$ in squared distance. Since it takes $k$ nearest points to $x$ , if we move $x_0$ from left to right, the k-nearest neighbourhood remains constant until a point $x_i$ to the right of $x_0$ becomes closer than the furthest point $x_{i'}$ in the neighbourhood to the left of $x_0$ , at which time $x_i$ replaces $x_{i'}$ . The average changes in a discrete way, leading to a discontinuous $\hat f (x)$ . See the graph in the next section.

The problem of such bumpy curve lies in the boundary points in a given interval, and here it is problematic since we have weights in all points. We can assign weights that die off smoothly with distance from the target point. One solution could be using Nadaraya-Watson kernel-weighted average.

### Nadaraya-Watson kernel-weighted-average.
$$\hat f (x_0) = \frac{\sum^N_{i=1}K_\lambda(x_0,x_i)y_i}{\sum^N_{i=1}K_\lambda(x_0,x_i)}$$
with the Epanechnikov quadratic kernel
$$K_\lambda(x_o,x)=D(\frac{|x - x_0|}{\lambda})$$
with
$$D(t) = 
\begin{cases}
\frac{3}{4}(1-t^2) \qquad if \quad |t| \leq 1; \\
0 \qquad \qquad \quad \quad otherwise
\end{cases}
$$
Fitted function is now continuous, and quite smooth. One can, however, use such adaptive neighbourhoods with kernels but we need to use a more general notation. Let $h_\lambda(x_0)$ be a width function (indexed by $\lambda$) that determines the width of the neighbourhood at $x_0$ . Then, more generally, we have (with $h_\lambda (x_0) = \lambda$ ):
$$K_\lambda(x_o,x)=D(\frac{|x - x_0|}{h_\lambda(x_0)})$$
![][esl-figure-6.1.png]
### Practical considerations
- The smoothing parameter λ, which determines the width of the local neighbourhood, has to be determined. Large λ implies lower variance (averages over more observations) but higher bias (we essentially assume the true function is constant within the window).
- Metric window widths (constant $h_\lambda (x)$) tend to keep the bias of the estimate constant, but the variance is inversely proportional to the local density. Nearest-neighbour window widths exhibit the opposite behaviours, the variance stays constant and the absolute bias varies inversely with local density.
- Issues arise with nearest-neighbours when there are ties in the $x_i$ . With most smoothing techniques one can simply reduce the data set by averaging the $y_i$ at tied values of $X$, and supplementing these new observations at the unique values of $x_i$ with an additional weight $w_i$(which multiples the kernel weight).
- This leaves a more general problem to deal with: observation weights $w_i$ . Operationally we simply multiply them by the kernel weights before computing the weighted average. With nearest neighborhoods, it is now natural to insist on neighborhoods with a total weight content$k$ (relative to $\sum w_i$ ). In the event of overflow (the last observation needed in a neighborhood has a weight $w_j$ which causes the sum of weights to exceed the budget $k$), then fractional parts can be used.
- Boundary issues arise. The metric neighborhoods tend to contain less points on the boundaries, while the nearest-neighborhoods get wider.
- The Epanechnikov kernel has compact support (needed when used with nearest-neighbour window size). Another popular compact is based on the tri-cube function:
$$D(t) = 
\begin{cases}
(1-|t|^3)^3 \qquad if \quad |t| \leq 1; \\
0 \qquad \qquad \quad \quad otherwise
\end{cases}
$$
This is flatter on the top (like the nearest-neighbour box) and its differentiable at the boundary of its support. The Gaussian density function $D(t) = \phi(t)$  is a popular noncompact kernel, with the standard deviation playing the role of the window size. Figure below encompasses the three.
![][esl-figure-6.2.png]





### Local Linear Regression

As seen in the graph below, Locally-weighted averages can be badly-biased on the boundaries of the domain, because of the asymmetry of a kernel in that region.
![][esl-figure-6.3.png]
We can remove this bias exactly to first order by fitting straight lines rather than constants locally. This bias can happen in the interior of the domain as well, if the $X$ values are not equally spaced. We make a first-order correction.

Locally weighted regression solves a separate weighted least squares problem **at each target point** $x_0$:
$$\min_{\substack{\alpha(x_0), \beta(x_0)}} \sum_{i=1}^N K_\lambda(x_0,x_i)[y_i - \alpha(x_0) - \beta(x_0)x_i]^2 $$
The estimate is then;
$$\hat f (x_0) = \hat \alpha (x_0) + \hat \beta (x_0)x_0$$
Notice although we fit an entire linear model to the data in the region, we only use it to evaluate the fit at a single point $x_0$ .

Further, let's define a vector-based function $b(x)^T = (1,x)$ . Let $B$ be the $N \times 2$ regression matrix with $i$th row $b(x_i)^T$ , and $W(x_0)$ the $N \times N$ diagonal matrix with $i$th diagonal element $K_\lambda(x_0,x_i)$ . Then:
$$
\hat f(x_0) = b(x_0)^T (B^TW(x_0)B)^{-1} B^TW(x_0)y = \sum^N_{i=1}l_i(x_0)y_i
$$
![][esl-figure-6.4.png]
Historically, the bias in the Nadaraya–Watson and other local average kernel methods were corrected by modifying the kernel. These modifications were based on theoretical asymptotic mean-square-error considerations, and besides being tedious to implement, are only approximate for finite sample sizes.  Local linear regression automatically modifies the kernel to correct the bias exactly to first order, a phenomenon dubbed as automatic kernel carpentry.

Consider the following expansion for $E \hat f(x_0)$ , using the linearity of local regression and a series expansion of the true function $f$ around $x_0$ .  
$$
E \hat f(x_0) = \sum_{i=1}^{N}l_i(x_0)f(x_i)
$$
$$
= f(x_0)\sum_{i=1}^{N}l_i(x_0)+f'(x_0)\sum_{i=1}^{N}(x_i-x_0) l_i(x_0)
$$
$$
+ \frac{f''(x_0)}{2} \sum_{i=1}^{N}(x_i-x_0)^2 l_i(x_0) + R
$$
where the remainder term $R$ involves third- and higher-order derivatives of
$f$ , and is typically small under suitable smoothness assumption. It can be further shown that for local linear regression $\sum_{i=1}^{N} l_i(x_0) = 1$ and $\sum_{i=1}^{N} (x_i - x_0) l_i(x_0) = 0$. Hence the middle term equals $f(x_0)$ and since the bias is $E \hat f(x_0) - f(x_0)$, we see that it depends only on the quadratic and higher-order terms in the expansion of $f$. 

### Local Polynomial Regression

Actually, we can fit local polynomial fits of any degree $d$. 
$$
\min_{\substack{\alpha(x_0), \beta_j(x_0), j=1,\dots,d}} \sum_{i=1}^N K_\lambda(x_0,x_i) \bigg[y_i - \alpha(x_0) - \sum_{j=1}^d \beta_j(x_0)x_i^j\bigg]^2 
$$
with a solution of 
$$\hat f (x_0) = \hat \alpha(x_0) + \sum_{j=1}^d \hat \beta_j(x_0)x_0^j$$
There is of course a price to be paid for this bias reduction, and that is increased variance. 
$\Bigg[ \text{insert variance and expected values formulas once you are here again actually doing this book with math understanding} \Bigg]$
![][esl-figure-6.5.png]
![][esl-figure-6.6.png]

### Selecting the width of the kernel

In each of the kernels $K_\lambda$ , $\lambda$ is a parameter that controls the width:
- For the Epanechnikov or tri-cube kernel with metric width, $\lambda$ is the radius of the support region.
- For the Gaussian kernel, $\lambda$ is the standard deviation
- $\lambda$ is the number $k$ of nearest neighbours in KNN, often expressed as a fraction of span $k/N$ of the total training sample.

There is a natural bias–variance trade-off as we change the width of the averaging window, which is most explicit for local averages:
- If the window is narrow, $\hat f (x_0)$ is an average of a small number of $y_i$ close to $x_0$ , and its variance will be relatively large - close to that of an individual $y_i$ . The bias will tend to be small, again because each of the $E(y_i) = f(x_i)$ should be close to $f(x_0)$ .
- If the window is wide, the variance of $\hat f (x_0)$ will be small relative to the variance of any $y_i$ , because of the effects of averaging. The bias will be higher, because we are now using observations $x_i$ further from $x_0$ , and there is no guarantee that $f(x_i)$ will be close to $f(x_0)$ 





# References
1. ![][ml-resources/elements-of-statistical-learning.pdf#page=211]