#' im2pix: A package for converting image to pseudo pixel art
#'
#' The im2pix package provides one important functions:
#' imtopix
#'
#' @docType package
#' @name im2pix
NULL


#' Convert Image to Pseudo Pixel Art
#'
#' Convert image to pseudo pixel art by reducing the resolution of the image and
#' matching the colour with a colour palette.
#'
#' @section Copyright Notice:
#' This algorithm is a reduced version of a python script written by
#' Nathan Harper. The intention of this package is to provide an R
#' API of this algorithm. The author of this R package do not own
#' the copyright of this algorithm. Please check the initial source of this
#' algorithm \url{https://github.com/nathanharper/phixelgator} and Nathan
#' Harper's Github page \url{https://github.com/nathanharper} for more details.
#'
#' @section Performance Issue:
#' R takes noticeable time to run this algorithm. If you would like to save your
#' time, please use Nathan Harper's original script written in Python
#' \url{https://github.com/nathanharper/phixelgator}.
#'
#' @param im an image; a cimg object, normally loaded by
#' \code{imager::load.image()}.
#' @param blockSize numeric; the size of single pixel or block.
#' @param pal character; colour palette used in matching.
#'
#' @examples
#' # im <- sample_im
#' # imtopix(im, pal = "appleii")
#'
#' @export
imtopix <- function(im,
                    blockSize = 8,
                    pal = c("appleii",
                            "atari2600",
                            "commodore64",
                            "contra",
                            "gameboy",
                            "grayscale",
                            "hyrule",
                            "intellivision",
                            "kungfu",
                            "mario",
                            "nes",
                            "sega",
                            "tetris")
                    ) {

  if (!imager::is.cimg(im)) stop("Only accept cimg object.")
  if (blockSize <= 0) stop("Only accept positive block size.")
  if (length(pal) > 1) pal <- "appleii"

  width <- dim(im)[1]
  height <- dim(im)[2]

  x_start <- seq(1, width, blockSize)
  x_start <- x_start[x_start <= width]
  x_end <- x_start + blockSize - 1
  x_end[x_end > width] <- width


  y_start <- seq(1, height, blockSize)
  y_start <- y_start[y_start <= height]
  y_end <- y_start + blockSize - 1
  y_end[y_end > height] <- height

  # check if there is a 4th channel
  # spilt into two parts to optimize code
  if (dim(im)[4] != 4) {

    finmat <- matrix(rep(0, 3 * length(x_start) * length(y_start)), ncol = 3)

    # for each block
    for (i in 1:length(x_start)) {
      for (j in 1:length(y_start)) {

        # extract block
        subim <- im[x_start[i]:x_end[i],
                        y_start[j]:y_end[j],
                        1,
                        1:3,
                        drop = FALSE]

        # mean channel
        ch1 <- mean(subim[,,,1])
        ch2 <- mean(subim[,,,2])
        ch3 <- mean(subim[,,,3])

        # find closest color
        rescol <- get_closest_color(c(ch1, ch2, ch3), pal)

        # store the color
        finmat[(i - 1) * length(y_start) + j,] <- rescol
      }
    }

    # define each channel
    finim1 <- array(rep(0, width * height), dim = c(width, height))
    finim2 <- array(rep(0, width * height), dim = c(width, height))
    finim3 <- array(rep(0, width * height), dim = c(width, height))

    # TODO: optimize this part
    for (i in 1:length(x_start)) {
      for (j in 1:length(y_start)) {

        index <- (i - 1) * length(y_start) + j
        c_x <- x_start[i]:x_end[i]
        c_y <- y_start[j]:y_end[j]

        # assign to each channel
        finim1[c_x, c_y] <- finmat[index, 1]
        finim2[c_x, c_y] <- finmat[index, 2]
        finim3[c_x, c_y] <- finmat[index, 3]

      }
    }

    # back to cimg
    dim(finim1) <- c(width, height, 1, 1)
    dim(finim2) <- c(width, height, 1, 1)
    dim(finim3) <- c(width, height, 1, 1)

    finim1 <- imager::as.cimg(finim1)
    finim2 <- imager::as.cimg(finim2)
    finim3 <- imager::as.cimg(finim3)

    # combine all channels
    finim <- imager::imappend(list(finim1, finim2, finim3), "c")


  } else {

    finmat <- matrix(rep(0, 4 * length(x_start) * length(y_start)), ncol = 4)

    for (i in 1:length(x_start)) {
      for (j in 1:length(y_start)) {

        subim <- im[x_start[i]:x_end[i],
                        y_start[j]:y_end[j],
                        1,
                        1:4,
                        drop = FALSE]

        ch1 <- mean(subim[,,,1])
        ch2 <- mean(subim[,,,2])
        ch3 <- mean(subim[,,,3])
        ch4 <- mean(subim[,,,4])

        rescol <- get_closest_color(c(ch1, ch2, ch3), pal)

        finmat[(i - 1) * length(y_start) + j,] <- c(rescol, ch4)
      }
    }

    finim1 <- array(rep(0, width * height), dim = c(width, height))
    finim2 <- array(rep(0, width * height), dim = c(width, height))
    finim3 <- array(rep(0, width * height), dim = c(width, height))
    finim4 <- array(rep(0, width * height), dim = c(width, height))

    # TODO: optimize this part
    for (i in 1:length(x_start)) {
      for (j in 1:length(y_start)) {

        index <- (i - 1) * length(y_start) + j
        c_x <- x_start[i]:x_end[i]
        c_y <- y_start[j]:y_end[j]

        finim1[c_x, c_y] <- finmat[index, 1]
        finim2[c_x, c_y] <- finmat[index, 2]
        finim3[c_x, c_y] <- finmat[index, 3]
        finim4[c_x, c_y] <- finmat[index, 4]

      }
    }

    dim(finim1) <- c(width, height, 1, 1)
    dim(finim2) <- c(width, height, 1, 1)
    dim(finim3) <- c(width, height, 1, 1)
    dim(finim4) <- c(width, height, 1, 1)

    finim1 <- imager::as.cimg(finim1)
    finim2 <- imager::as.cimg(finim2)
    finim3 <- imager::as.cimg(finim3)
    finim4 <- imager::as.cimg(finim4)

    finim <- imager::imappend(list(finim1, finim2, finim3, finim4), "c")

  }


  finim


}













