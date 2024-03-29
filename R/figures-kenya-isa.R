
# Figures for the Kenya paper ISA presentation

suppressPackageStartupMessages(library(tidybayes))
suppressPackageStartupMessages(library(brms))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(patchwork))


# Write a function that will use the models from the models-kenya-isa.R script
# to generate the posterior predictive checks for the Kenya ISA paper.
# This function should have one argument for the model object and one argument
# for the predictor variable from the model that will be used to generate the
# posterior predictive checks and figures.
# The function should return a ggplot object that shows the posterior predictive.
# The function should use the ggdist and tidybayes packages to generate the posterior
# draws used to generate the ggplot figures.
# The posterior draws should be based on 1000 posterior draws from the model object.
# The ggplot object should use the ggdist package and the geom_dotsinterval function
# to plot the posterior predictive checks.
# PDF copies of the returned figures should be saved in the Kenya-ISA subfolder within the Figures
# folder in the project's root directory using the ggsave function.
# The PDF dimensions should be 5 inches tall and 8 inches wide.

ppc_plot_f <- function(model, outcome.cats, group.effects) {

# If the group.effects argument in this function is TRUE, the function should generate
# an object that equals the random effects component of the equation from the brms model object
# included in the model argument.

  if (group.effects == TRUE) {
    group_effects <- print(paste("~", str_extract(as.character(model$formula), pattern = "\\([^()]+\\)")),
                           quote = FALSE)[[1]]
  } else {
    group_effects <- NA
  }

  # Generate an object named "newdataframe". This object should contain variables from the formula in the
  # "models-kenya-isa.R" file that are not the outcome variable or the group effects variable. The code should use thet
  # tidyverse coding style to generate this object.
  # All of the variables in the newdataframe object should be from data in the model object included in the function
  # argument named "model".

  newdataframe <- expand_grid(USCitizenContact = c("Yes", "No"),
                              ChineseCitizenContact = c("Yes", "No"),
                              Age_z = mean(model[[1]]$data$Age_z),
                              Gender = names(which.max(table(model[[1]]$data$Gender))),
                              HighestEducationLevel = names(which.max(table(model[[1]]$data$HighestEducationLevel))),
                              Income = names(which.max(table(model[[1]]$data$Income))),
                              Film = names(which.max(table(model[[1]]$data$Film))),
                              TVProgram = names(which.max(table(model[[1]]$data$TVProgram))),
                              SportsMatch = names(which.max(table(model[[1]]$data$SportsMatch))),
                              ADM1 = unique(model[[1]]$data$ADM1))

  # Generate an object named "ppc_draws". This object should contain 500 posterior draws from the model object
  # This object should use the tidybayes and ggdist packages.
  # The draws should be generated using the add_epred_draws function from the tidybayes package.
  # The .ndraws argument should be set to 500.
  # The re_formula argument should be set to the group_effects object.
  # The newdata argument should be set to the newdataframe object.
  # The model argument should be set to the model object.
  # Each argument in the function should be on a new line.

  plotlist <- furrr::future_map(.x = seq_along(model),
                                 .f = ~ add_epred_draws(model[[.x]],
                                                        .ndraws = 200,
                                                        .value = ".epred",
                                                        re_formula = group_effects,
                                                        newdata = newdataframe,
                                                        seed = 55602) |>
    mutate(model = glue::glue("{model[[.x]]$formula[[5]]}"),
           model = case_when(str_detect(model, "US") ~ "United States",
                             str_detect(model, "Chinese") ~ "Chinese"),
           grouping = glue::glue("US Contact: {USCitizenContact} and Chinese Contact: {ChineseCitizenContact}"))
    )|>
   furrr::future_map(.f = ~ggplot2::ggplot(data = .x |> filter(.category %in% outcome.cats),
                                             aes(x = .epred)) +
                        ggdist::stat_slabinterval(aes(fill = grouping)) +
                       viridis::scale_fill_viridis(discrete = TRUE,
                                                   option = "magma") +
                        facet_grid(model ~ .category, scales = "free") +
                        flynnprojects::theme_flynn(base_size = 11, base_family = "oswald") +
                        labs(title = glue::glue("Views of {.x$model}"),
                             x = "Predicted Probability",
                             y = "Outcome Category")
                        )
  # Use the patchwork package to combine the list of ggplot objects into a single plotlist object.
  # Add a title to the combined plot saying "Predicted Probabilities of Outcome by Contact Type and Country".
  # Save the plotlist object as a PDF in the Kenya-ISA subfolder within the Figures folder in the project's root directory.
  # Use the ggsave function to save the plotlist object as a PDF.
  # The figure's height should be 8 in and the width should be 9 in.

  plotout <- patchwork::wrap_plots(plotlist[[1]], plotlist[[2]]) +
    patchwork::plot_annotation(title = "Predicted Probabilities of Outcome by Contact Type and Country")

    ggsave(plotout,
           here::here("Figures/Kenya-ISA/figure-predicted-probabilities.pdf"), height = 8, width = 9)


    return(plotlist)



}


