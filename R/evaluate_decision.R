evaluate_decision <- function(data, decision, ...) {
    switch(
        decision,
        cultivar = rapsimng.decide.cultivar::evaluate_cultivar_suitability(data, ...),
        stop("Unknown decision type")
    )
}