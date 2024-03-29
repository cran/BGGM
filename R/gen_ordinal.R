#' Generate Ordinal and Binary data
#'
#' Generate Multivariate Ordinal and Binary data.
#'
#' @param n Number of observations (\emph{n}).
#'
#' @param p Number of variables  (\emph{p}).
#'
#' @param levels Number of categories (defaults to 2; binary data).
#'
#' @param cor_mat A \emph{p} by \emph{p} matrix including the true correlation structure.
#'
#' @param empirical Logical. If true, \code{cor_mat} specifies  the empirical not
#'                  population covariance matrix.
#'
#' @return A \emph{n} by \emph{p} data matrix.
#'
#' @references
#' \insertAllCited{}
#'
#' @importFrom utils capture.output
#' @note
#'
#' In order to allow users to enjoy the functionality of \bold{BGGM}, we had to make minor changes to the function \code{rmvord_naiv}
#' from the \code{R} package \bold{orddata} \insertCite{orddata}{BGGM}. All rights to, and credit for, the function \code{rmvord_naiv}
#' belong to the authors of that package.
#'
#' This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
#' This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#' A copy of the GNU General Public License is available online.
#'
#' @examples
#' ################################
#' ######### example 1 ############
#' ################################
#'
#' main <-  ptsd_cor1[1:5,1:5]
#' p <- ncol(main)
#'
#' pcors <- -(cov2cor(solve(main)) -diag(p))
#' diag(pcors) <- 1
#' pcors <- ifelse(abs(pcors) < 0.05, 0, pcors)
#'
#' inv <-  -pcors
#' diag(inv) <- 1
#' cors <- cov2cor( solve(inv))
#'
#' # example data
#' Y <- BGGM::gen_ordinal(n = 500, p = 5,
#'                        levels = 2,
#'                        cor_mat = cors,
#'                        empirical = FALSE)
#'
#'
#'
#' ################################
#' ######### example 2 ############
#' ################################
#' # empirical = TRUE
#'
#' Y <-  gen_ordinal(n = 500,
#'                   p = 16,
#'                   levels = 5,
#'                   cor_mat = ptsd_cor1,
#'                   empirical = TRUE)
#'
#' @export
gen_ordinal <- function(n,  p, levels = 2,  cor_mat, empirical = FALSE){

  ls <- list()

  for(i in 1:p){
    temp <- table(sample(c(1:levels),
                         size = n,
                         replace = T))
    ls[[i]] <- as.numeric(temp / sum(temp))
  }

  junk <- capture.output(data <- rmvord_naiv(n = n, probs =  ls,
                                             Cors = cor_mat,
                                             empirical = empirical))
  data
}
