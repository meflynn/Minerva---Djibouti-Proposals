
# models for Kenya ISA paper

suppressPackageStartupMessages(library(tidybayes))
suppressPackageStartupMessages(library(brms))

clean_priors_province_f <- function(data) {

  priors <- brms::get_prior(
    bf(mvbind(USView4cat , ChineseView4cat) ~ 0 + Intercept + Age_z + Gender + Income + HighestEducationLevel +
         USCitizenContact + ChineseCitizenContact +
         Film + TVProgram + SportsMatch + (1 | ADM1),
       decomp = "QR"),
    family = categorical(link = "logit",
                         refcat = "Neutral"),
    data = data
  )

# using the object named 'priors' from the previous code chunk and the tidyverse style of coding
# and the tidyverse package and the native pipe return an object named 'priors' that is the same as the input object
# add a normal prior to every line in the 'priors' object that has a class of 'b'
# and a normal prior to every line in the 'priors' object that has a class of 'sd'
# and add an lkj(1) prior to every line in the 'priors' object that has a class of 'cor'

  priors <- priors |>
    mutate(
      prior = case_when(
        class == "b" ~ "normal(0, 1)",
        class == "sd" ~ "normal(0, 1)",
        class == "cor" ~ "lkj(1)",
        class == "Intercept" ~ "student_t(3, 0, 1)"
      )
    )

  return(priors)

}

models_kenya_f <- function(data, priors) {

PRIOR <- priors
ITERS <- 5000
WARMS <- 2500
THINS <- 1
CHAINS <- 4
CORES <- 4

FORMULA <- bf(mvbind(USView4cat, ChineseView4cat) ~ 0 + Intercept + Age_z + Gender + Income + HighestEducationLevel +
                USCitizenContact + ChineseCitizenContact +
                Film + TVProgram + SportsMatch + (1 | ADM1),
              decomp = "QR")

# using the object named 'data' from the previous code chunk and the tidyverse style of coding
# and the objects named PRIOR ITERS WARMS THINS CHAINS and CORES write a brms model with a formula that
# equals the FORMULA object above with a categorical family and a
# logit link with a refcat that equals "Neither positive nor negative"
# make the adapt delta setting equal to 0.82
# allow for threading with 2 threads per core
# use the cmdstanr backend

  model <- brms::brm(
    formula = FORMULA,
    family = categorical(link = "logit",
                         refcat = "Neutral"),
    data = data,
    prior = priors,
    iter = ITERS,
    warmup = WARMS,
    thin = THINS,
    chains = CHAINS,
    cores = CORES,
    control = list(adapt_delta = 0.82),
    threads = threading(2),
    backend = "cmdstanr"
  )

  return(model)

}

