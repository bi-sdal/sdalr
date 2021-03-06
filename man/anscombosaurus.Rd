% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anscombosaurus.R
\docType{data}
\name{anscombosaurus}
\alias{anscombosaurus}
\title{Anscombe goes rawr!}
\format{An object of class \code{tbl_df} (inherits from \code{tbl}, \code{data.frame}) with 142 rows and 2 columns.}
\source{
\href{http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html}{
http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
}
}
\usage{
data(anscombosaurus)
}
\description{
Dataset seen at Sarah Bird's PyData Talk in 2016.
https://twitter.com/birdsarah/status/776470450184617985
}
\details{
Original post for the data can be found by Alberto Cairo here:
http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html
}
\examples{
data(anscombosaurus)

plot(anscombosaurus$x, anscombosaurus$y)

library(ggplot2)
ggplot(data = anscombosaurus, aes(x = x, y = y)) + geom_point()
}
\references{
Alberto Cairo (2016) Download the Datasaurus: Never trust summary statistics alone; always visualize your data
(\href{http://www.thefunctionalart.com/2016/08/download-datasaurus-never-trust-summary.html}{})
}
\keyword{datasets}
