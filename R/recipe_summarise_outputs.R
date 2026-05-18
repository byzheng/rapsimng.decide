
# #' Summarise APSIMX outputs for decision support
# #' 
# #' This function takes the raw output from an APSIMX simulation and produces a summary table that includes mean values, quantiles, and risk metrics for key performance indicators. The summary is grouped by specified management factors (e.g., cultivar, fertilisation, sowing date) to facilitate comparison of different scenarios.
# #' 
# #' @param report A data frame containing the raw APSIMX output data (e.g., from the HarvestReport)
# #' @param crop The name of the crop being analysed (e.g., "Wheat")
# #' @param group_vars A character vector of column names to group by (e.g., c("Cultivar", "Fertilisation", "SowingDate"))
# #' @param years A numeric vector of years to include in the summary (e.g., seq(1996, 2025))
# #' @param yield_fail_threshold_t_ha A numeric value representing the yield threshold (in t/ha) below which a simulation is considered a failure (e.g., 1 t/ha)
# #' @return A data frame summarising the APSIMX outputs, including mean values, quantiles, and risk of failure for each group defined by `group_vars`.
# #' @export
# recipe_summarise_outputs <- function(
#     report, 
#     crop,
#     group_vars = c("Cultivar", "Fertilisation", "SowingDate"),
#     years = seq(1996, 2025),
#     yield_fail_threshold_t_ha = 1
# ) {
#     # Check inputs
#     stopifnot(is.data.frame(report))
#     stopifnot(is.character(crop), length(crop) == 1)
#     stopifnot(is.character(group_vars), length(group_vars) >= 1)
#     stopifnot(all(group_vars %in% names(report)))
#     stopifnot(is.numeric(years), length(years) >= 1)
#     stopifnot(is.numeric(yield_fail_threshold_t_ha), length(yield_fail_threshold_t_ha) == 1)
    
#     crop <- tools::toTitleCase(crop)

#     if ("SowingDate" %in% group_vars) {
#         if (!tibble::has_name(report, "SowingDOY")) {
#             stop("Expected 'SowingDOY' column not found in APSIM output. Please check the model configuration.")
#         }    
#         group_vars <- c(group_vars, "SowingDOY") |> unique()
#     }

#     if (!tibble::has_name(report, "Year")) {
#         stop("Expected 'Year' column not found in APSIM output. Please check the model configuration.")
#     }
#     if (!tibble::has_name(report, "SowingDOY")) {
#         stop("Expected 'SowingDOY' column not found in APSIM output. Please check the model configuration.")
#     }
#     all_years <- unique(report$Year)
#     stopifnot(all(years %in% all_years))
    
#     all_cols <- names(report)
#     grain_wt_col <- paste0(crop, ".Grain.FrostHeatYield")
#     if (!grain_wt_col %in% all_cols) {
#         stop("Expected grain weight column not found in APSIM output: ", grain_wt_col)
#     }
#     phenology_cols <- all_cols[grepl("Phenology.*DAS$", all_cols)]
#     if (length(phenology_cols) == 0) {
#         stop("No phenology columns found in APSIM output. Please check the model configuration.")
#     }    
#     metric_cols <- all_cols[startsWith(all_cols, paste0(crop, ".")) & vapply(report, is.numeric, logical(1))]
#     report |>
#         dplyr::filter(.data$Year %in% years) |>
#         dplyr::mutate(
#             dplyr::across(
#                 dplyr::all_of(phenology_cols),
#                 ~ .x + .data$SowingDOY,
#                 .names = "{sub('DAS$', 'DOY', .col)}"
#             )

#         ) |>
#         dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
#         dplyr::summarise(
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ mean(.x, na.rm = TRUE),
#                 .names = "mean_{.col}"
#             ),
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ quantile(.x, 0.1, na.rm = TRUE),
#                 .names = "p10_{.col}"
#             ),
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ quantile(.x, 0.05, na.rm = TRUE),
#                 .names = "p05_{.col}"
#             ),
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ quantile(.x, 0.5, na.rm = TRUE),
#                 .names = "p50_{.col}"
#             ),
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ quantile(.x, 0.9, na.rm = TRUE),
#                 .names = "p90_{.col}"
#             ),
#             dplyr::across(
#                 dplyr::all_of(metric_cols),
#                 ~ quantile(.x, 0.95, na.rm = TRUE),
#                 .names = "p95_{.col}"
#             ),
#             # Grain.FrostHeatYield assumed g/m2; threshold in t/ha
#             risk_failure = mean((.data[[grain_wt_col]] / 100) < yield_fail_threshold_t_ha , na.rm = TRUE),
#             n_years = dplyr::n(),
#             .groups = "drop"
#         )
# }


# .recipe_registry_env$recipe_summarise_outputs <- list(
#     name    = "recipe_summarise_outputs",
#     category = "general",
#     purpose = "Summarise multi-year APSIM outputs into decision metrics",
#     inputs  = "APSIM output data, grouping variables, year range",
#     outputs = "Summary data frame with means, quantiles, and variability metrics"
# )
