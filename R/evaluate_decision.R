
.decision_registry <- list(
    cultivar = rapsimng.decide.cultivar::evaluate_cultivar_suitability
)


.get_decision_evaluator <- function(decision) {
    
    fn <- .decision_registry[[decision]]
    
    if (is.null(fn)) {
        stop(sprintf("Unknown decision type: %s", decision))
    }
    
    fn
}


#' Evaluate a Decision From APSIM NG Outputs
#'
#' @description
#' `evaluate_decision()` is a high-level orchestration wrapper for decision
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
#'   evaluation behaviour in the selected decision workflow.
#' @param ... Additional arguments passed through to the domain-specific
#'   decision evaluator.
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
#' @examples
#' mock_data <- data.frame(
#'   SimulationName = "example",
#'   Yield = 4.2,
#'   stringsAsFactors = FALSE
#' )
#'
#' # Example usage once a decision package is installed:
#' # evaluate_decision(
#' #   data = mock_data,
#' #   decision = "cultivar",
#' #   context = list(location = "Wagga Wagga"),
#' #   criteria = list(min_yield = 3.5),
#' #   options = list()
#' # )
#'
#' @export
evaluate_decision <- function(
    data,
    decision,
    context = list(),
    criteria = list(),
    options = list(),
    ...
) {

    if (!is.data.frame(data)) {
        stop("`data` must be a data.frame or tibble")
    }

    if (!is.character(decision) || length(decision) != 1) {
        stop("`decision` must be a single string")
    }

    evaluator <- .get_decision_evaluator(decision)

    result <- evaluator(
        data = data,
        context = context,
        criteria = criteria,
        options = options,
        ...
    )

    # basic structure check
    required_names <- c("meta", "metrics", "tables", "figures")
    if (!all(required_names %in% names(result))) {
        stop("Decision result must contain: meta, metrics, tables, figures")
    }

    class(result) <- "rapsimng_decide_report"

    return(result)
}
