---
title: "Test Import"
author: "Maazin Ansari"
date: 12/30/2017
---

# Parameter Estimation


<span class="math display">\[\begin{align*}
\frac{\partial}{\partial \hat{\beta_0}}RSS(\hat{\beta_0},\hat{\beta_1})
&amp; = \frac{\partial}{\partial \hat{\beta_0}}
\sum_{i=1}^n[y_i-(\hat{\beta_0}+\hat{\beta_1}x_i)]^2=0 \\\\

&amp; = \sum_{i=1}^n2(y_i - \hat{\beta_0} - \hat{\beta_1}x_i)(-1) \\\\

-2\sum_{i=1}^ny_i-\hat{\beta_0} -\hat{\beta_1}x_i &amp; = 0 \\\\

\sum_{i=1}^ny_i -n\hat{\beta_0}  -\hat{\beta_1}\sum_{i=1}^nx_i&amp; = 0 \\\\

n\hat{\beta_0} &amp; = \sum_{i=1}^ny_i-\hat{\beta_1}\sum_{i=1}^nx_i \\\\

\hat{\beta_0} &amp; = \bar{y} - \hat{\beta_1}\bar{x}
\end{align*}\]</span>
<div id="r-markdown" class="section level2">
<h2>R Markdown</h2>
<p>This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <a href="http://rmarkdown.rstudio.com" class="uri">http://rmarkdown.rstudio.com</a>.</p>
<p>When you click the <strong>Knit</strong> button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:</p>
<pre class="r"><code>summary(cars)</code></pre>
<pre><code>##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00</code></pre>
</div>
<div id="including-plots" class="section level2">
<h2>Including Plots</h2>
<p>You can also embed plots, for example:</p>
<p><img src="testpage_files/figure-html/pressure-1.png" width="672" /></p>
<p>Note that the <code>echo = FALSE</code> parameter was added to the code chunk to prevent printing of the R code that generated the plot.</p>
</div>
<div id="latex" class="section level2">
<h2>LaTeX</h2>
<p>Minimize: <span class="math inline">\(RSS(\beta_0,\beta_1)=\sum_{i=1}^n[y_i-(\beta_0+\beta_1x_i)]^2\)</span></p>
<p><span class="math inline">\(\hat{\beta}_0\)</span>:</p>
<p>This is a line of text</p>
$$
<span class="math display">\[\begin{align*}
\frac{\partial}{\partial \hat{\beta_0}}RSS(\hat{\beta_0},\hat{\beta_1})
&amp; = \frac{\partial}{\partial \hat{\beta_0}}
\sum_{i=1}^n[y_i-(\hat{\beta_0}+\hat{\beta_1}x_i)]^2=0 \\\\

&amp; = \sum_{i=1}^n2(y_i - \hat{\beta_0} - \hat{\beta_1}x_i)(-1) \\\\

-2\sum_{i=1}^ny_i-\hat{\beta_0} -\hat{\beta_1}x_i &amp; = 0 \\\\

\sum_{i=1}^ny_i -n\hat{\beta_0}  -\hat{\beta_1}\sum_{i=1}^nx_i&amp; = 0 \\\\

n\hat{\beta_0} &amp; = \sum_{i=1}^ny_i-\hat{\beta_1}\sum_{i=1}^nx_i \\\\

\hat{\beta_0} &amp; = \bar{y} - \hat{\beta_1}\bar{x}
\end{align*}\]</span>
<p>$$</p>
<p>Another block:</p>
<p>Y_i = _0 + _1 x_i + e_i</p>
<p>Here the <code>$$</code> don’t show up.</p>
<p>\begin e_i \end</p>
</div>




</div>

<script>

// add bootstrap table styles to pandoc tables
function bootstrapStylePandocTables() {
  $('tr.header').parent('thead').parent('table').addClass('table table-condensed');
}
$(document).ready(function () {
  bootstrapStylePandocTables();
});


</script>

<!-- dynamically load mathjax for compatibility with self-contained -->
<script>
  (function () {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src  = "https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
    document.getElementsByTagName("head")[0].appendChild(script);
  })();
</script>
