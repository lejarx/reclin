
#' Add variables from data sets to pairs
#' 
#' @param pairs a \code{pairs} object, such as generated by 
#'   \code{\link{pair_blocking}}
#' @param ... a set of option of the form \code{newvarname = "varname"}, where
#'   \code{varname} is a column in \code{x} or \code{y}.
#'   
#' @return 
#' A \code{pairs} object which contains all column of the original \code{pairs}
#' with the new columns added to it. An error is generated when it is attempted
#' to add variables that already exist in pairs. 
#' 
#' @examples 
#' data("linkexample1", "linkexample2")
#' pairs <- pair_blocking(linkexample1, linkexample2, "postcode")
#' pairs <- compare_pairs(pairs, c("lastname", "firstname", "address", "sex"))
#' pairs <- add_from_x(pairs, id_x = "id")
#' pairs <- add_from_y(pairs, id_y = "id")
#' pairs$true_match <- pairs$id_x == pairs$id_y
#'
#' \dontshow{gc()}
#'
#' @rdname add_from_x
#' @export
add_from_x <- function(pairs, ...) {
  if (!methods::is(pairs, "pairs")) stop("pairs should be an object of type 'pairs'.")  
  UseMethod("add_from_x")
}

#' @export
add_from_x.data.frame <- function(pairs, ...) {
  add_from_xy_impl(pairs, "x", ...)
}

#' @export
add_from_x.ldat <- function(pairs, ...) {
  add_from_xy_impl(pairs, "x", ...)
}

#' @rdname add_from_x
#' @export
add_from_y <- function(pairs, ...) {
  if (!methods::is(pairs, "pairs")) stop("pairs should be an object of type 'pairs'.")  
  UseMethod("add_from_y")
}

#' @export
add_from_y.data.frame <- function(pairs, ...) {
  add_from_xy_impl(pairs, "y", ...)
}

#' @export
add_from_y.ldat <- function(pairs, ...) {
  add_from_xy_impl(pairs, "y", ...)
}

add_from_xy_impl <- function(pairs, from = c("x", "y"), ...) {
  from <- match.arg(from)
  d <- attr(pairs, from)
  variables <- list(...)
  for (i in seq_along(variables)) {
    var <- variables[[i]]
    if (!is.character(var) || length(var) != 1) 
      stop("Variable is not a character vector of length 1.")
    varname <- names(variables)[i]
    if (is.null(varname) || varname == "") varname <- var
    if (varname %in% names(pairs)) 
      stop("'", varname, "' already exists in pairs.")
    v <- if (is_ldat(pairs)) as_lvec(d[[var]]) else d[[var]]
    pairs[[varname]] <- v[pairs[[from]]]
  }
  pairs
}
