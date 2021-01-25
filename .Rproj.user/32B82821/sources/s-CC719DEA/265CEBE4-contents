# get closest colour using RGB format
get_closest_color <- function(o_vec, pal) {
  t_mat <- pal_collection[[pal]] / 255
  index <- which.min(apply(t_mat, 1, color_dist, b_vec = o_vec))[1]
  t_mat[index,]
}
