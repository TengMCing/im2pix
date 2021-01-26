
<!-- README.md is generated from README.Rmd. Please edit that file -->

# im2pix

<!-- badges: start -->

[![R-CMD-check](https://github.com/TengMCing/im2pix/workflows/R-CMD-check/badge.svg)](https://github.com/TengMCing/im2pix/actions)
<!-- badges: end -->

im2pix is a tool to convert image to pseudo pixel art in R. It’s a
reduced version of [Nathan Harper’s Python
script](https://github.com/nathanharper/phixelgator). The author of this
package do not own the copyright of this algorithm.

## Installation

You can install the released version of im2pix from
[GitHub](https://github.com/TengMCing/im2pix) with:

``` r
devtools::install_github("TengMCing/im2pix")
```

## Example

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

The built-in image

``` r
plot(sample_im)
```

<img src="man/figures/README-cars-1.png" width="100%" />

Covert the image to pseudo pixel art using palette “contra”. Increase
the block size will decrease the output resolution.

The `imtopix()` function only accepts `cimg` class object/image which
can be loaded from disk by `imager::load.image(<path_to_image>)` or
created from a matrix-like object by
`imager::as.cimg(<matrix-like_object>)`.

``` r
out_pic <- imtopix(sample_im, pal = "contra", blockSize = 8)
plot(out_pic)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

Using another palette

``` r
out_pic <- imtopix(sample_im, pal = "gameboy", blockSize = 8)
plot(out_pic)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

Available palettes include

``` r
names(pal_collection)
#>  [1] "appleii"       "atari2600"     "commodore64"   "contra"       
#>  [5] "gameboy"       "grayscale"     "hyrule"        "intellivision"
#>  [9] "kungfu"        "mario"         "nes"           "sega"         
#> [13] "tetris"
```
