context("Testing impute_missing")

test_that("impute_missing(df, col, method, missing_val_char) returns a data frame without missing values in a specified column
          with three simple methods", {

  # expected output
  expect_equal(
    impute_missing(data.frame(V1 = c(1, 2, 3), V2 = c(0, 10, NA)),
                   "V2",
                   "CC",
                   NA),
    data.frame(V1 = c(1, 2), V2 = c(0, 10)))

  expect_equal(
    impute_missing(matrix(c(1,2,3, 0,10, NA), nrow = 3, ncol = 2, byrow = FALSE),
                   "V2",
                   "CC",
                   NA),
    data.frame(V1 = c(1, 2), V2 = c(0, 10)))

  expect_equal(
    impute_missing(data.frame(x = c(1, 2, 3), y = c(0, 10, "?")),
                   "y",
                   "MIP",
                   "?"),
    data.frame(x = c(1, 2, 3), y = c(0, 10, 5)))

  expect_equal(
    impute_missing(data.frame(x = c(1, 2, 3), y = c(0, 5, " ")),
                   "y",
                   "MIP",
                   " "),
    data.frame(x = c(1, 2, 3), y = c(0.0, 5.0, 2.5)))

  expect_equal(
    impute_missing(matrix(c(1,2,3, 0,10,NaN), nrow = 3, ncol = 2, byrow = FALSE),
                   "V2",
                   "MIP",
                   NaN),
    data.frame(V1 = c(1, 2, 3), V2 = c(0, 10, 5)))

  expect_equal(
    impute_missing(data.frame(ex = c(1, 2, 3), bf = c(6, 8, "")),
                   "bf",
                   "DIP",
                   ""),
    data.frame(ex = c(1, 2, 3), bf = c(6, 8, 7)))

  expect_equal(
    impute_missing(matrix(c(1,2,3, 6,8,NA), nrow = 3, ncol = 2, byrow = FALSE),
                   "V2",
                   "DIP",
                   NA),
    data.frame(V1 = c(1, 2, 3), V2 = c(6, 8, 7)))

  # expected errors
  expect_error(impute_missing(matrix(c(1,2,3, 6,8,""), nrow = 3, ncol = 2, byrow = FALSE),
                              "V2",
                              "DIP",
                              ""),
               "Error: only NA and NaN are allowed for matrix, otherwise the input matrix is not numerical")

  expect_error(impute_missing(list(1, 2, 2, NA), "V2", "MIP", NA),
               "Error: data format is not supported, expected a data frame or a matrix")

  expect_error(impute_missing(data.frame("exp" = c(1, 2, 3), "res" = c(0, 10, NaN)),
                              2,
                              "CC",
                              NaN),
               "Error: column name is not applicable, expected a string instead")

  expect_error(impute_missing(data.frame(exp = c(1, 2, 3), res = c(0, 10, "")),
                              "dn",
                              "CC",
                              ""),
               "Error: the specified column name is not in the data frame")

  expect_error(impute_missing(data.frame(x = c(1, 2, 3), y = c(0, 10, NA)), "y", "multi_im", NA),
               "Error: method is not applicable")

  expect_error(impute_missing(data.frame(x = c(1, 2, 3), y = c(0, 10, 0)), "y", "CC", 0),
               "Error: missing value format is not supported, expected one of blank space, a question mark, NA and NaN")
})
