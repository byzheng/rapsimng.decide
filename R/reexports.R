#' @importFrom rapsimng.decide.core document_lines
#' @export
#' @examples
#' example_document <- structure(
#'   list(prefix = list(body = "Example report"), sections = list()),
#'   class = "rapsimng_decide_document"
#' )
#' document_lines(example_document)
rapsimng.decide.core::document_lines

#' @importFrom rapsimng.decide.core write_document
#' @export
#' @examples
#' example_document <- structure(
#'   list(prefix = list(body = "Example report"), sections = list()),
#'   class = "rapsimng_decide_document"
#' )
#' path <- tempfile()
#' write_document(example_document, path)
#' readLines(path)
#' unlink(path)
rapsimng.decide.core::write_document