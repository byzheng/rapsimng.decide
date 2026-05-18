
#' Read APSIMX output 
#' 
#' @param apsimx_file The path to the APSIMX output file (.apsimx)
#' @param report The name of the report to read from the APSIMX output (
#' default: "HarvestReport")
#' @return A data frame containing the APSIMX output data
#' @export
read_output <- function(apsimx_file, report = "HarvestReport") {
    stopifnot(is.character(apsimx_file), length(apsimx_file) == 1, file.exists(apsimx_file))
    df <-  rapsimng::read_report(apsimx_file, report)
    if (!tibble::has_name(df, "Clock.Today")) {
        stop("Expected 'Clock.Today' column not found in APSIM output. Please check the model configuration.")
    }
    if (!tibble::has_name(df, "SowingDate")) {
        stop("Expected 'SowingDate' column not found in APSIM output. Please check the model configuration.")
    }
    if (!tibble::has_name(df, "Cultivar")) {
        stop("Expected 'Cultivar' column not found in APSIM output. Please check the model configuration.")
    }
    if (!tibble::has_name(df, "Fertilisation")) {
        stop("Expected 'Fertilisation' column not found in APSIM output. Please check the model configuration.")
    }
    df |>
        dplyr::mutate(
            Clock.Today = as.Date(.data$Clock.Today),
            SowingDOY = as.numeric(as.Date(paste(.data$SowingDate, "-2011", sep = ""), format = "%d-%b-%Y")) - 
        as.numeric(as.Date("2010-12-31")),
            Year = as.numeric(format(.data$Clock.Today, "%Y")),
        )
    
}

