
# Read in Kenya Survey and clean it


clean_survey_f <- function(data) {

  readxl::read_xlsx(data) |>
    dplyr::slice(-1) |>
    mutate(Age = as.numeric(Age))

}
