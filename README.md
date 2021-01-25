
<!-- README.md is generated from README.Rmd. Please edit that file -->

# im2pix

<!-- badges: start -->

[![R-CMD-check](https://github.com/TengMCing/im2pix/workflows/R-CMD-check/badge.svg)](https://github.com/TengMCing/im2pix/actions)
<!-- badges: end -->

im2pix is a tool to convert image to pseudo pixel art. It’s a reduced
version

## Installation

You can install the released version of im2pix from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("im2pix")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(im2pix)
library(imager)
#> Loading required package: magrittr
#> 
#> Attaching package: 'imager'
#> The following object is masked from 'package:magrittr':
#> 
#>     add
#> The following objects are masked from 'package:stats':
#> 
#>     convolve, spectrum
#> The following object is masked from 'package:graphics':
#> 
#>     frame
#> The following object is masked from 'package:base':
#> 
#>     save.image
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
plot(sample_im)
```

<img src="man/figures/README-cars-1.png" width="100%" />

``` r
out_pic <- imtopix(sample_im, pal = "contra", blockSize = 8)
plot(out_pic)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

``` r
out_pic <- imtopix(sample_im, pal = "gameboy", blockSize = 8)
plot(out_pic)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
