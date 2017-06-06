#' Anscombe goes rawr!
#'
#' Dataset seen at Sarah Bird's PyData Talk in 2016.
#' https://twitter.com/birdsarah/status/776470450184617985
#'
#' Original post for the data can be found by Alberto Cairo here:
#' http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
#'
#' @docType data
#'
#' @usage data(anscombosaurus)
#'
#' @keywords datasets
#'
#' @references Alberto Cairo (2016) Download the Datasaurus: Never trust summary statistics alone; always visualize your data
#' (\href{http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html}{})
#'
#' @source \href{http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html}{}
#'
#' @examples
#' data(anscombosaurus)
#'
#' plot(anscombosaurus$x, anscombosaurus$y)
#'
#' library(ggplot2)
#' ggplot(data = anscombosaurus, aes(x = x, y = y)) + geom_point()
"anscombosaurus"
