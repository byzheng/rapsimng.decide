test_that("evaluate returns a report for valid minimal input", {
    mock_report <- list(
        meta = list(decision = "cultivar"),
        metrics = list(score = 1),
        tables = list(summary = data.frame(value = 1)),
        figures = list()
    )

    local_mocked_bindings(
        .get_evaluator = function(decision) {
            expect_identical(decision, "cultivar")

            function(data, context, criteria, options, ...) {
                expect_true(is.data.frame(data))
                expect_identical(context, list())
                expect_identical(criteria, list())
                expect_identical(options, list())

                mock_report
            }
        },
        .package = "rapsimng.decide"
    )

    result <- evaluate(
        data = data.frame(yield = 4.2),
        decision = "cultivar"
    )

    expect_named(result, c("meta", "metrics", "tables", "figures"))
    expect_s3_class(result, "rapsimng_decide_report")
})

test_that("evaluate errors when data is not a data frame", {
    expect_error(
        evaluate(data = list(yield = 4.2), decision = "cultivar"),
        "`data` must be a data.frame or tibble"
    )
})

test_that("evaluate errors when decision is unknown", {
    expect_error(
        evaluate(data = data.frame(yield = 4.2), decision = "unknown"),
        "Unknown decision type: unknown"
    )
})

test_that("evaluate assigns the report class to returned output", {
    mock_report <- list(
        meta = list(),
        metrics = list(),
        tables = list(),
        figures = list(plot = NULL)
    )

    local_mocked_bindings(
        .get_evaluator = function(decision) {
            expect_identical(decision, "cultivar")

            function(data, context, criteria, options, ...) {
                mock_report
            }
        },
        .package = "rapsimng.decide"
    )

    result <- evaluate(
        data = data.frame(yield = 4.2),
        decision = "cultivar"
    )

    expect_s3_class(result, "rapsimng_decide_report")
})

