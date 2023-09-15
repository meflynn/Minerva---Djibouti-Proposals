# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(tidyverse)
library(tarchetypes) # Load other packages as needed. # nolint
library(here)
library(quarto)
library(future) # for multicore/parallel processing

# Suppress brms messages
suppressPackageStartupMessages(library(brms))

# brms and stan options
options(mc.cores = 4,
        mc.threads = 2,
        brms.backend = "cmdstanr")

set.seed(66502)

# Set target options:
tar_option_set(
  packages = c("tibble", "data.table", "brms", "sf", "tidybayes", "modelsummary", "cmdstanr", "marginaleffects", "flynnprojects", "viridis", "glue", "here", "kableExtra", "purrr", "furrr", "tarchetypes", "quarto", "future", "ggdist", "tinytex", "bayesplot", "patchwork"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# Probably also have to expand memory for futures package using the following
# #. Memory calculated using 2000*1024^2 = 2097152000 where 2000 is number of
# MB desired
# Found here: https://stackoverflow.com/questions/40536067/how-to-adjust-future-global-maxsize
options(future.globals.maxSize= 8097152000)

# Set up future package for multicore processing.
# This uses a nested multicore setup, so you can have four cores per model and
# run four models in parallel
#plan(multiprocess)
plan(
  list(
    tweak(multisession, workers = 4),
    tweak(multisession, workers = 4)
  )
)
# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Enable custom fonts
sysfonts::font_add_google("Oswald")
sysfonts::font_add_google("EB Garamond", family = "ebgaramond")
showtext::showtext_auto()
showtext::showtext_opts(dpi = 300)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed. # nolint

# Replace the target list below with your own:
list(

  # Load raw data
  tar_target(survey_raw, "Data/Kenya Survey/GeoPoll_Brandeis Survey_Kenya_Final_Data_2023_09_12 V2.xlsx", format = "file"),

  # Read in and clean raw data
  tar_target(survey_clean, clean_survey_f(survey_raw)),

  # Render preliminary report
  tar_quarto(preliminary_report,
             path = "preliminary-kenya-summary/preliminary-kenya-summary.qmd",
             quiet = FALSE)
)
