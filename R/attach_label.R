
#' Attach variable labels
#'
#' @md
#' @param df An extracted data frame from the scorecard merged files
#' @return A data frame, with proper variable labels
#' @examples
#' \dontrun{
#' attach_var_label(scorecard::mf2014_15)
#' }
#' @export
attach_var_label = function(df){
  labelled::var_label(df) <- var_label_lst
  df
}

#' Attach value labels
#'
#' @md
#' @param df An extracted data frame from the scorecard merged files
#' @return A data frame, with proper value labels
#' @examples
#' \dontrun{
#' attach_var_label(scorecard::mf2014_15)
#' }
#' @export
attach_val_label = function(df){
  labelled::val_labels(df) <- val_label_lst
  df
}
