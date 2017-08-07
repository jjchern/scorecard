
#' Attach variable labels
#'
#' @md
#' @return A tibble, with proper variable labels
#' @export
attach_var_label = function(df){
  labelled::var_label(df) <- var_label_lst
  df
}

#' Attach value labels
#'
#' @md
#' @return A tibble, with proper value labels
#' @export
attach_val_label = function(df){
  labelled::val_labels(df) <- val_label_lst
  df
}
