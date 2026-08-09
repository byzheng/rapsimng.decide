[![R-CMD-check.yaml](https://github.com/byzheng/rapsimng.decide/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/byzheng/rapsimng.decide/actions/workflows/R-CMD-check.yaml)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/rapsimng.decide)](https://cran.r-project.org/package=rapsimng.decide)

[![](http://cranlogs.r-pkg.org/badges/grand-total/rapsimng.decide?color=green)](https://cran.r-project.org/package=rapsimng.decide)
[![](http://cranlogs.r-pkg.org/badges/last-month/rapsimng.decide?color=green)](https://cran.r-project.org/package=rapsimng.decide)
[![](http://cranlogs.r-pkg.org/badges/last-week/rapsimng.decide?color=green)](https://cran.r-project.org/package=rapsimng.decide)

# rapsimng.decide

rapsimng.decide provides a small interface for decision workflows built from APSIM Next Generation outputs.

It currently exports three helpers:

- `read_output()` to read a report from an APSIMX file into a data frame.
- `evaluate()` to run a decision workflow through a decision-specific package.
- `document()` to produce a documented report in the same workflow.

## Installation

Install from GitHub:

```r
remotes::install_github("byzheng/rapsimng.decide")
```

## Basic usage

```r
library(rapsimng.decide)

sim_data <- read_output(
  "path/to/model.apsimx",
  report = "HarvestReport"
)

result <- evaluate(
  data = sim_data,
  decision = "cultivar",
  context = list(location = "Wagga Wagga"),
  criteria = list(min_yield = 3.5),
  options = list()
)
```

The `decision` argument selects a domain-specific implementation from an installed decision package such as `rapsimng.decide.cultivar`. This package itself does not implement the decision logic; it provides a consistent interface and report structure.

## Notes

- `read_output()` expects APSIMX output columns such as `Clock.Today`, `SowingDate`, `Cultivar`, and `Fertilisation`.
- `evaluate()` returns a structured report object with `meta`, `metrics`, `tables`, and `figures` components.
- `document()` is available when you want a human-readable report as text.

