#' Return registered recipe metadata
#'
#' @return A named list describing registered recipes.
#' @export
.recipe_registry_env <- new.env(parent = emptyenv())

recipe_registry <- function() {
    as.list.environment(.recipe_registry_env, all.names = TRUE)
}