#' Extract Posterior Samples
#'
#' @description Extract posterior samples for all parameters.
#'
#' @param object an object of class \code{estimate} or \code{explore}.
#'
#' @param ... currently ignored.
#'
#' @return A matrix of posterior samples for the partial correlation. Note that if controlling for
#'         variables (e.g., formula \code{~ age}), the matrix also includes the coefficients from each
#'         multivariate regression.
#'
#' @examples
#' \donttest{
#' # note: iter = 250 for demonstrative purposes
#'
#' ########################################
#' ### example 1: control  with formula ###
#' ########################################
#' # (the following works with all data types)
#'
#' # controlling for gender
#' Y <- bfi
#'
#' # to control for only gender
#' # (remove education)
#' Y <- subset(Y, select = - education)
#'
#' # fit model
#' fit <- estimate(Y, formula = ~ gender,
#'                 iter = 250)
#'
#' # note regression coefficients
#' samps <- posterior_samples(fit)
#'
#' hist(samps[,1])
#' }
#'
#' @export
posterior_samples <- function(object, ...){


  if(is(object, "estimate") | is(object, "explore")) {

    if(!is(object, "default")){
      stop("object most be from 'estimate' or 'explore'")
    }

    # nodes
    p <- object$p

    # total partials
    pcors_total <- p * (p - 1) * 0.5

    # identity matrix
    I_p <- diag(p)

    # iterations
    iter <- object$iter

    # pcor samples
    pcor_samples <-
      matrix(
        object$post_samp$pcors[, , 51:(iter + 50)][upper.tri(I_p)],
        nrow =  iter,
        ncol = pcors_total,
        byrow = TRUE
      )

  # column names
  cn <- colnames(object$Y)

  if(is.null(cn)){

    col_names <- sapply(1:p, function(x)  paste(1:p, x, sep = "--"))[upper.tri(I_p)]

  } else {

    col_names <- sapply(cn, function(x)  paste(cn, x, sep = "--"))[upper.tri(I_p)]
  }


  colnames(pcor_samples) <- col_names

  posterior_samples <- pcor_samples

  if(!is.null(object$formula)){

    # intercept only
    if(ncol(object$X) == 1){

      beta_terms <- "(Intercept)"

    } else {
    # predictors
    beta_terms <- colnames(object$X)

    }
    # number of terms
    n_beta_terms <- length(beta_terms)

    # posterior samples
    beta_samples <- object$post_samp$beta


    if(is.null(cn)){

      col_names <- 1:p

    } else {

      col_names <- cn

    }

    beta_start <- matrix(beta_samples[1:n_beta_terms,1, 51:(iter+50)],
                         nrow = iter, n_beta_terms, byrow = TRUE)


    colnames(beta_start) <- paste0(col_names[1], "_",  beta_terms)

    for(i in 2:p){

      # beta next
      beta_i <- matrix(beta_samples[1:n_beta_terms, i, 51:(iter+50)],
                       nrow = iter,
                       n_beta_terms,
                       byrow = TRUE)

      # colnames
      colnames(beta_i) <- paste0(col_names[i], "_",  beta_terms)

      # beta combine
      beta_start <- cbind(beta_start, beta_i)

    }

    posterior_samples <-  cbind(posterior_samples, beta_start)

  }
} else if (is(object, "var_estimate")) {

  if(!is(object, "default")){
    stop("object most be from 'var_estimate'")
  }
  # nodes
  p <- object$p

  # total partials
  pcors_total <- p * (p - 1) * 0.5

  # identity matrix
  I_p <- diag(p)

  # iterations
  iter <- object$iter

  # pcor samples
  pcor_samples <-
    matrix(
      object$fit$pcors[, , 51:(iter + 50)][upper.tri(I_p)],
      nrow =  iter,
      ncol = pcors_total,
      byrow = TRUE
    )


  # column names
  cn <- colnames(object$Y)

  if(is.null(cn)){

    col_names <- sapply(1:p, function(x)  paste(1:p, x, sep = "--"))[upper.tri(I_p)]

  } else {

    col_names <- sapply(cn, function(x)  paste(cn, x, sep = "--"))[upper.tri(I_p)]
  }
  colnames(pcor_samples) <- col_names
  posterior_samples <- pcor_samples

  n_beta_terms <- nrow(object$beta_mu)
  beta_samples <- object$fit$beta

  col_names <- colnames(object$Y)
  beta_terms <- colnames(object$X)

  beta_start <- matrix(beta_samples[1:n_beta_terms,1, 51:(iter+50)],
                       nrow = iter, n_beta_terms, byrow = TRUE)


 colnames(beta_start) <- paste0(col_names[1], "_",  beta_terms)

  for(i in 2:p){

    # beta next
    beta_i <- matrix(beta_samples[1:n_beta_terms, i, 51:(iter+50)],
                     nrow = iter,
                     n_beta_terms,
                     byrow = TRUE)

    # colnames
    colnames(beta_i) <- paste0(col_names[i], "_",  beta_terms)

    # beta combine
    beta_start <- cbind(beta_start, beta_i)

  }

 posterior_samples <-  cbind(posterior_samples, beta_start)

} else {
  stop("object class not currently supported")
}

  return(posterior_samples)

}
