---
layout: post
title: "The difference of two folded normal random variables"
---

What is the distribution of $$Z = \vert X\vert - \vert Y\vert$$ when $$X \sim N(\mu_x, \sigma^2)$$ and $$Y \sim N(\mu_y,\sigma^2)$$ are independent Gaussian random variables with the same variance?  

-   [CDF](#cdf)
-   [PDF](#pdf)
-   [Mean and variance](#mean-and-variance)
-   [Verify using simulation](#verify-using-simulation)

CDF
===  
The CDF of $$Z$$ is $$F_Z(t) = \mathbb{P}(Z \le t) = \mathbb{P}(\vert X\vert  - \vert Y\vert  \le t).$$

First assume that $$t > 0$$ and consider the region 
<div>
$$A = \left\{\vert X\vert  - \vert Y\vert  \le t\right\}$$:
</div>

![]({{ site.url }}/images/plot-tpos-1.png)

The probability $$\mathbb{P}(Z \le t)$$ is  
<div>
$$
\mathbb{P}(Z \le t) = \underset{A}{\int\int}f(x,y)\, \mathrm{d}x\mathrm{d}y.
$$
</div>

Since $$X$$ and $$Y$$ have the same variance and are independent, the distribution of $$(X, Y)^\intercal$$ is invariant under an orthogonal transformation $$W$$. In other words,  

$$
\begin{align*}
\mathbb{P}\left(\left[\begin{array}{c}X\\Y\end{array}\right] \in A \right)=\mathbb{P}\left(W\left[\begin{array}{c}X\\Y\end{array} \right]\in WA \right)
\end{align*}  
$$

where $$WA = \left\{Wv : v \in A\right\}$$.

To make the integral $$\mathbb{P}(Z \le t) = \underset{A}{\int\int}f(x,y)\, \mathrm{d}x\mathrm{d}y$$ easier, we can rotate the region $$A$$ so that its "elbows" align with the coordinate axes.  
The triangular cutouts of this region are defined by 45-degree lines: $$y= x - t$$, $$y = - x + t$$, etc. So we want the rotation matrix for a 45-degree, counterclockwise rotation around the origin:  

$$
\begin{align*}
\theta &= \frac{\pi}{4} \text{  (45 degrees)}\\
W &= \left[
\begin{array}{cc}
\cos(\theta) & -\sin(\theta)\\
\sin(\theta) & \cos(\theta)
\end{array}
\right] = \frac{1}{\sqrt{2}}\left[
\begin{array}{cc}
1 & -1\\
1 & 1
\end{array}
\right]
\end{align*}
$$

Applying this rotation matrix, we get the region $$WA$$:

![]({{ site.url }}/images/plot-tpos-rotate-1.png)

The probability of $$WA$$ is easy to compute since we can split the region into disjoint rectangles. Denote $$W\left[\begin{array}{c}X\\Y\end{array}\right] = (\tilde{X}, \tilde{Y})^\intercal$$.

Using independence of $$\tilde{X}$$ and $$\tilde{Y}$$ and the above picture, we have

$$
\begin{align*}
\mathbb{P}(\vert X\vert  - \vert Y\vert  < t) &= \underset{\text{bottom rectangle}}{\mathbb{P}(\tilde{X} > -t/\sqrt{2}, \tilde{Y} < -t/\sqrt{2})}  + \underset{\text{middle rectangle}}{\mathbb{P}(-t/\sqrt{2} < \tilde{Y} < t/\sqrt{2})} + \underset{\text{top rectangle}}{\mathbb{P}(\tilde{X} < t/\sqrt{2},\tilde{Y} > t/\sqrt{2})}\\
&= \left(1-\Phi\left(\frac{-t}{\sqrt{2}\sigma} - \frac{\tilde{\mu}_x}{\sigma}\right)\right)\Phi\left(\frac{-t}{\sqrt{2}\sigma} - \frac{\tilde{\mu}_y}{\sigma}\right) +\\
&\hspace{12pt}\Phi\left(\frac{t}{\sqrt{2}\sigma} - \frac{\tilde{\mu}_y}{\sigma}\right) - \Phi\left(\frac{-t}{\sqrt{2}\sigma} -\frac{\tilde{\mu}_y}{\sigma}\right)+\\
&\hspace{12pt}\Phi\left(\frac{t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_x}{\sigma}\right)\left(1-\Phi\left(\frac{t}{\sqrt{2}\sigma} -\frac{\tilde{\mu}_y}{\sigma}\right)\right) 
\end{align*}
$$

where $$\Phi$$ is the CDF of a $$N(0,1)$$ random variable and 
<div>
$$
\left[\begin{array}{c}\tilde{\mu}_x\\\tilde{\mu}_y\end{array}\right] = W\left[\begin{array}{c}\mu_x\\ \mu_y\end{array}\right] = \frac{1}{\sqrt{2}}\left[\begin{array}{c} \mu_x-\mu_y \\ \mu_x+\mu_y\end{array}\right]
$$
</div>

When $$t <0$$ the regions $$A$$ and $$WA$$ look like this:

![]({{ site.url }}/images/plot-tneg-1.png)

And the probability we want is 

$$
\begin{align*}
\mathbb{P}(\vert X\vert  - \vert Y\vert  \le t) &= \mathbb{P}\left(\tilde{X} < \frac{t}{\sqrt{2}}, \tilde{Y} > \frac{-t}{\sqrt{2}}\right) + \mathbb{P}\left(\tilde{X} > \frac{-t}{\sqrt{2}}, \tilde{Y} < \frac{t}{\sqrt{2}}\right)\\
&=\Phi\left(\frac{t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_x}{\sigma}\right)\left(1-\Phi\left(\frac{-t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_y}{\sigma}\right)\right) \\
&\hspace{18pt} +\left(1-\Phi\left(\frac{-t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_x}{\sigma}\right)\right)\Phi\left(\frac{t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_y}{\sigma}\right)
\end{align*}
$$

(The pictures make it clear that $$\mathbb{P}(\vert X\vert  - \vert Y\vert  \le t) = 1 - \mathbb{P}(\vert X\vert  - \vert Y\vert  \le -t)$$.)


PDF
===

After differentiating, the PDF is

$$
\begin{align*}
t > 0: f_Z(t) &= \frac{1}{\sqrt{2}\sigma}\left[\Phi(c_y^-)\phi(c_x^-)-(1-\Phi(c_x^-))\phi(c_y^-)+(1-\Phi(c_y^+))\phi(c_x^+)-\Phi(c_x^+)\phi(c_y^+)+\phi(c_y^-)+\phi(c_y^+)\right]\\[6pt]
t<0: f_Z(t) &= \frac{1}{\sqrt{2}\sigma}\left[\Phi(c_y^+)\phi(c_x^-)+\Phi(c_x^+)\phi(c_y^-)+(1-\Phi(c_y^-))\phi(c_x^+)+(1-\Phi(c_x^-))\phi(c_y^+)\right]
\end{align*}
$$

where $$\phi$$ is the standard normal PDF and 
$$
\begin{align*}
c_x^- &= \frac{-t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_x}{\sigma}&
c_y^- &= \frac{-t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_Y}{\sigma}\\
c_x^+ &= \frac{t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_x}{\sigma} & 
c_y^+ &= \frac{t}{\sqrt{2}\sigma}-\frac{\tilde{\mu}_Y}{\sigma}
\end{align*}
$$


Mean and variance
=================

The mean and variance can be calculated based on the mean of $$\vert X\vert$$ and $$\vert Y\vert$$ individually (refer to the folded normal distribution <a href="https://en.wikipedia.org/wiki/Folded_normal_distribution" target="_blank">wiki page</a>).


$$
\mathbb{E}(\vert Y\vert  - \vert X\vert ) = \sigma \sqrt{\frac{2}{\pi}}\left(e^{-\mu_y^2/2\sigma^2}-e^{-\mu_x^2/2\sigma^2}\right) + \mu_y(1-2\Phi(-\mu_y/\sigma)) - \mu_x(1-2\Phi(-\mu_x/\sigma))
$$


$$
\mathrm{Var}(\vert Y\vert -\vert X\vert )= \left[\mathbb{E}(\vert Y\vert )\right]^2 + \sigma^2 - \mu_y^2 +\left[\mathbb{E}(\vert X\vert )\right]^2 + \sigma^2 - \mu_x^2 
$$

Verify using simulation
=======================

Here is an `R` implementation of the CDF and PDF for $$Z = \vert X\vert  - \vert Y\vert$$.


``` r
cdf_absdiff <- function(tval, mu_x, mu_y, sigma) {
  mu_x_tilde <- (1 / sqrt(2)) * (mu_x - mu_y) # rotated mu_x
  mu_y_tilde <- (1 / sqrt(2)) * (mu_x + mu_y) # rotated mu_y
  cxmin <- -tval / (sigma * sqrt(2)) - mu_x_tilde / sigma
  cymin <- -tval / (sigma * sqrt(2)) - mu_y_tilde / sigma
  cyplus <- tval / (sigma * sqrt(2)) - mu_y_tilde / sigma
  cxplus <- tval / (sigma * sqrt(2)) - mu_x_tilde / sigma
  ret <- ifelse(
    tval > 0,
    (1 - pnorm(cxmin)) * pnorm(cymin) + pnorm(cxplus) * (1 - pnorm(cyplus)) +
      pnorm(cyplus) - pnorm(cymin),
    pnorm(cxplus) * (1 - pnorm(cymin)) + (1 - pnorm(cxmin)) * pnorm(cyplus)
  )
  return(ret)
}

pdf_absdiff <- function(tval, mu_x, mu_y, sigma) {
  mu_x_tilde <- (1 / sqrt(2)) * (mu_x - mu_y) # rotated mu_x
  mu_y_tilde <- (1 / sqrt(2)) * (mu_x + mu_y) # rotated mu_y
  cxmin <- -tval / (sigma * sqrt(2)) - mu_x_tilde / sigma
  cymin <- -tval / (sigma * sqrt(2)) - mu_y_tilde / sigma
  cyplus <- tval / (sigma * sqrt(2)) - mu_y_tilde / sigma
  cxplus <- tval / (sigma * sqrt(2)) - mu_x_tilde / sigma
  
  ret <- ifelse(
    tval > 0,
    (1 / (sigma * sqrt(2))) * (
      pnorm(cymin) * dnorm(cxmin) - (1 - pnorm(cxmin)) * dnorm(cymin) +
        (1 - pnorm(cyplus)) * dnorm(cxplus) - 
        pnorm(cxplus) * dnorm(cyplus) +
        dnorm(cymin) + dnorm(cyplus)
    ),
    (1 / (sigma * sqrt(2))) * (
      pnorm(cyplus) * dnorm(cxmin) + pnorm(cxplus) * dnorm(cymin) + 
        (1 - pnorm(cymin)) * dnorm(cxplus) +
        (1 - pnorm(cxmin)) * dnorm(cyplus)
    )
  )
  return(ret)
}

mean_absnorm <- function(mu_x, sigma){
  return(sigma * sqrt(2/pi) * exp(-mu_x^2/(2*sigma^2)) + mu_x * (1 - 2 * pnorm(-mu_x/sigma)))
}
mean_absdiff <- function(mu_x, mu_y, sigma){
  return(mean_absnorm(mu_x, sigma) - mean_absnorm(mu_y, sigma))
}
var_absdiff <- function(mu_x, mu_y, sigma){
  m_absx <- mean_absnorm(mu_x, sigma)
  m_absy <- mean_absnorm(mu_y, sigma)
  return(m_absy^2 + m_absx^2 + 2*sigma^2 - mu_x^2 - mu_y^2)
}
```

The PDF and CDF calculated above agree with the empirical distribution of $$Z$$:

``` r
library(tidyverse)
sigma <- 2
mu_x <- 1.5
mu_y <- 5
set.seed(111)
N <- 50000
X <- rnorm(N, mean=mu_x, sd=sigma)
Y <- rnorm(N, mean=mu_y, sd=sigma)
Z <- abs(X) - abs(Y)
Z_ecdf <- ecdf(Z)
tseq <- seq(mean(Z) - 4 * sd(Z), mean(Z) + 4 * sd(Z), length.out=300)
mytheme <- theme(panel.background = element_rect(fill=NA,color='grey'),
                 panel.grid = element_line(color='lightgrey',linetype='dashed'),
                 legend.key = element_rect(fill=NA))
tibble(t = tseq,
       Z_empirical = Z_ecdf(tseq),
       Z_theory = cdf_absdiff(tseq,mu_x, mu_y, sigma)) %>%
  gather(Z_empirical, Z_theory, key='type', value='cdf') %>%
  ggplot(aes(x=t, y=cdf, color=type)) + geom_line() +
  mytheme + ylab("Pr(Z < t)") +
  scale_color_manual(values = c('Z_theory' = 'darkblue',
                                'Z_empirical' = 'orange'),
                     name='', labels=c('Theoretical CDF','Empirical CDF'))
```

![]({{ site.url }}/images/cdf-check-1.png)


``` r
ggplot(tibble(Z=Z), aes(x=Z, y=..density..)) + 
  geom_histogram(fill='white', color='black', bins = 100) +
  geom_line(aes(x=t,y=pdf),
            color = 'red',
            data = tibble(t = tseq, 
	    	          pdf = pdf_absdiff(tseq, mu_x, 
			      			  mu_y, sigma))) +
  mytheme 
```

![]({{ site.url }}/images/pdf-check-1.png)

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    extensions: [
      "MathMenu.js",
      "tex2jax.js"
    ],
    tex2jax: {
     processEnvironments: true
    },
    TeX: {
      extensions: [
        "AMSmath.js",
        "AMSsymbols.js",
        "noErrors.js",
        "noUndefined.js",
      ]
    }
  });
</script>

<script type="text/javascript" async
  src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>