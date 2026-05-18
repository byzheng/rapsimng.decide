

# rapsimng.decide

`rapsimng.decide` provides a high-level interface for analysing APSIM Next Generation simulation outputs through structured decision workflows.

The package coordinates domain-specific decision modules (e.g. cultivar suitability, experiment design) and returns standardised, reproducible decision reports.


---

## Installation

Currently on [Github](https://github.com/byzheng/rapsimng.decide.cultivar) only. Install with:

```r
remotes::install_github('byzheng/rapsimng.decide')
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
report <- evaluate(
  data,
  decision = "cultivar",
  context = list(...),
  criteria = list(...)
)
```

---

## Output Structure

All decisions return a consistent structure:

```r
list(
  meta     = list(...),
  metrics  = list(...),
  tables   = list(...),
  figures  = list(...)
)
```

This structure is designed for:

* reproducible workflows
* direct use in Quarto (`qmd`)
* downstream interpretation (e.g. `agrillm`)

---

## Design Principles

### 1. Separation of Responsibilities

* Decision logic lives in `rapsimng.decide.*`
* This package only orchestrates and standardises outputs

### 2. Transparency

* All assumptions and criteria are explicit
* No hidden optimisation or recommendation

### 3. Reproducibility

* Outputs are deterministic and structured
* Suitable for reporting and publication

***

## Scope

* APSIM **Next Generation outputs only**
* Input: `data.frame` / `tibble`
* No dependency on APSIM runtime

---

## Not in Scope

* APSIM simulation setup or execution
* Domain-specific decision logic
* User intent interpretation
* Automated decision-making

---

## Extending the System

New decision types can be added by creating packages such as:

* `rapsimng.decide.cultivar`
* `rapsimng.decide.experiment`

Each package:

* implements its own metrics, tables, and figures
* returns a standard decision report object

`rapsimng.decide` will automatically integrate them through its interface.

---

## Key Insight

> This package provides a **decision framework**,  
> not decision answers.

---

## Status

Early-stage infrastructure for:

* modular decision analysis
* scalable modelling workflows
* integration with AI-assisted interfaces

