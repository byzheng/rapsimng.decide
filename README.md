

# rapsimng.decide

`rapsimng.decide` provides a high-level interface for analysing APSIM Next Generation simulation outputs through structured decision workflows.

The package coordinates domain-specific decision modules (e.g. cultivar suitability, experiment design) and returns standardised, reproducible decision reports.


---

## Installation

Currently on [Github](https://github.com/byzheng/rapsimng.decide.cultivar) only. Install with:

```r
remotes::install_github('byzheng/rapsimng.decide.cultivar')
```

---


## Overview

Crop modelling often involves multiple steps:

1. Run APSIM simulations  
2. Analyse outputs for a specific decision  
3. Summarise results for reporting or interpretation  

This package focuses on **Step 2 and 3** by providing a unified entry point for decision analysis.

---

## Role in the Ecosystem

The package sits within a layered design:


- `rapsimng`  
  Handles APSIM file manipulation and simulation

- `rapsimng.decide.*`  
  Implements domain-specific decision logic  
  (e.g. cultivar, experiment design)

- `rapsimng.decide`  
  ✅ Coordinates decision packages  
  ✅ Standardises outputs  
  ✅ Provides a consistent user interface  

- `agrillm`  
  Interprets user intent and explains results

---

## Key Concept

> **This package does not define decisions.  
It coordinates how decisions are evaluated and reported.**

---

## Usage

### High-level entry point

```r
report <- evaluate_decision(
  data,
  decision = "cultivar",
  context = list(...),
  criteria = list(...)
)
```

