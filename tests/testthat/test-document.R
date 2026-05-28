test_that("document returns the delegated structured document", {
    mock_document <- list(
        prefix = list(body = c("Overview line 1", "Overview line 2")),
        sections = list(
            list(body = c("Section one")),
            list(body = c("Section two", "Section three"))
        )
    )

    local_mocked_bindings(
        .get_documenter = function(decision) {
            expect_identical(decision, "cultivar")

            function(data, context, criteria, options, ...) {
                expect_true(is.data.frame(data))
                expect_identical(context, list(location = "Wagga"))
                expect_identical(criteria, list(min_yield = 3))
                expect_identical(options, list(style = "brief"))

                mock_document
            }
        },
        .package = "rapsimng.decide"
    )

    result <- document(
        data = data.frame(yield = 4.2),
        decision = "cultivar",
        context = list(location = "Wagga"),
        criteria = list(min_yield = 3),
        options = list(style = "brief")
    )

    expect_identical(result, mock_document)
})

test_that("document simplifies structured output into lines", {
    mock_document <- list(
        prefix = list(body = c("Overview line 1", "Overview line 2")),
        sections = list(
            list(body = c("Section one")),
            NULL,
            list(body = c("Section two", "Section three"))
        )
    )
    class(mock_document) <- "rapsimng_decide_document"
    local_mocked_bindings(
        .get_documenter = function(decision) {
            expect_identical(decision, "cultivar")

            function(data, context, criteria, options, ...) {
                mock_document
            }
        },
        .package = "rapsimng.decide"
    )

    result <- document(
        data = data.frame(yield = 4.2),
        decision = "cultivar",
        simplify = TRUE
    )

    expect_identical(
        result,
        c(
            "Overview line 1",
            "Overview line 2",
            "",
            "Section one",
            "",
            "Section two",
            "Section three",
            ""
        )
    )
})

test_that("document errors when data is not a data frame", {
    expect_error(
        document(data = list(yield = 4.2), decision = "cultivar"),
        "`data` must be a data.frame or tibble"
    )
})

test_that("document errors when decision is unknown", {
    expect_error(
        document(data = data.frame(yield = 4.2), decision = "unknown")
    )
})
