---
title       : Lissajous Curves
subtitle    : 
author      : R. Handsfield
job         : 
framework   : html5slides        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Slide 1

<p>A Lissajous curve is a way to compare trigonometric sine functions. The curve is used in signal processing, audio engineering, and many other disciplines.</p>

</p>The basic sine function $Y = sin(t)$ looks like this:</p>
<img src="assets/fig/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto;" />

--- 

## Slide 2



<p>If we multiply the variable $t$ by some number, we can either stretch out or compress the graph.</p>
![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2-1.png) ![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2-2.png) 
<p>We say that these two graphs have different <i>periods</i> or <i>frequencies</i>. Plotting one of these sines on the X-axis, and the other on the Y-axis, creates the Lissajous curve and makes it easy to compare pairs of sine functions with different frequency relationships.</p>

---

## Slide 3

The Lissajous curve for the previous two sine functions $Y=sin(3*t)$ and $X=sin(0.5*t)$
![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-1.png) ![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-2.png) 

looks like this:

<img src="assets/fig/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />


---

## Slide 4

The Lissajous curve for a differnt pair of sine functions $Y=sin(4*t)$ and $X=sin(2*t)$
![plot of chunk unnamed-chunk-5](assets/fig/unnamed-chunk-5-1.png) ![plot of chunk unnamed-chunk-5](assets/fig/unnamed-chunk-5-2.png) 

looks like this:

<img src="assets/fig/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />


A <a href=https://en.wikipedia.org/wiki/Lissajous_curve>Lissajous curve</a> describes the relationship between two oscillators vibrating simultaneously. Equations for a Lissajous curve can take the simplified form:

<pre><h5>X = sin(A*t)          Y = sin(B*t)</h5></pre>

---

## Slide 5

plot(
				x=sin(t*A()), 
				y=sin(t*B()), 
				xlab=paste('X = sin(', A(), ' * t )'),
				ylab=paste('Y = sin(', B(), ' * t )'),
				col='red', type='l', lwd=3, 
				main='Lissajous Curve  (Y vs X)'
			)




