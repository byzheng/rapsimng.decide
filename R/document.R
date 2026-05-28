

.document_registry <- list(
    cultivar = rapsimng.decide.cultivar::document,
    sowing = rapsimng.decide.sowing::document,
    nitrogen = rapsimng.decide.nitrogen::document
)


.get_documenter <- function(decision) {
    
    fn <- .document_registry[[decision]]
    
    if (is.null(fn)) {
        stop(sprintf("Unknown decision type: %s", decision))
    }
    
    fn
}


#' Document a Decision From APSIM NG Outputs
#'
#' @description
#' `document()` is a high-level orchestration wrapper for decision
#' workflows built on APSIM Next Generation outputs. It validates inputs,
#' dispatches to a domain-specific decision package, and standardises the
#' returned result into a common report structure. It does not implement the
#' decision logic itself.
#'
#' @param data A data frame or tibble containing APSIM Next Generation
#'   simulation outputs.
#' @param decision A single string identifying which decision workflow to run,
#'   such as `"cultivar"`.
#' @param context A named list of contextual inputs supplied to the selected
#'   decision workflow.
#' @param criteria A named list of decision criteria or thresholds used by the
#'   selected decision workflow.
#' @param options A named list of additional options that control reporting or
#'   documentation behaviour in the selected decision workflow.
#' @param simplify A boolean flag indicating whether to simplify the returned
#'   document into a character vector of lines. If `FALSE`, the full structured
#'   document is returned.
#' @param ... Additional arguments passed through to the domain-specific
#'   decision documenter.
#'
#' @details
#' This package separates responsibilities across the wider workflow:
#'
#' - `rapsimng` is responsible for running or preparing APSIM Next Generation
#'   simulations and outputs.
#' - `rapsimng.decide.*` packages implement domain-specific decision logic,
#'   such as cultivar suitability assessment.
#' - downstream analysis or interpretation layers, including packages such as
#'   `agrillm`, can consume the standardised report returned here.
#'
#' `rapsimng.decide` sits between these layers and provides a consistent entry
#' point and output contract for decision-oriented reporting.
#'
#' @return A list with class `"rapsimng_decide_report"` containing four named
#'   components:
#'
#' - `meta`: metadata describing the decision context and execution.
#' - `metrics`: summary metrics produced by the decision workflow.
#' - `tables`: tabular outputs ready for reporting.
#' - `figures`: figure objects, specifications, or references for visual output.
#'
#'
#' @export
document <- function(
    data,
    decision,
    context = list(),
    criteria = list(),
    options = list(),
    simplify = FALSE,
    ...
) {

    if (!is.data.frame(data)) {
        stop("`data` must be a data.frame or tibble")
    }

    if (!is.character(decision) || length(decision) != 1) {
        stop("`decision` must be a single string")
    }

    documenter <- .get_documenter(decision)

    result <- documenter(
        data = data,
        context = context,
        criteria = criteria,
        options = options,
        ...
    )
    if (simplify) {
        result <- document_lines(result)
    }
    return(result)
}

