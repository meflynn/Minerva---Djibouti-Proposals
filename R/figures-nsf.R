

# Figures for NSF proposal


figures_nsf_military_presence_f <- function(data) {


  # Knowledge of military presences

  temp <- data |>
    dplyr::select(USMilitaryPresence, ChineseMilitaryPresence) |>
    group_by(USMilitaryPresence, ChineseMilitaryPresence) |>
    dplyr::summarise(count = n()) |>
    ungroup() |>
    dplyr::mutate(percent = count/sum(count))

  tempplot <- ggplot(data = temp, aes(x = USMilitaryPresence, y = ChineseMilitaryPresence, fill = percent)) +
    geom_tile(color = "white", linewidth = 0.13) +
    theme_flynn(base_size = 9, base_family = "Oswald") +
    viridis::scale_fill_viridis(option = "magma", labels = scales::percent_format()) +
    scale_x_discrete(labels = scales::wrap_format(20),
                     expand = c(0,0)) +
    scale_y_discrete(labels = scales::wrap_format(20),
                     expand = c(0,0)) +
    theme(axis.text.x.bottom = element_text(angle = 45, hjust = 1, lineheight = 1),
          axis.text.y.left = element_text(hjust = 1, lineheight = 1)) +
    labs(x = "US Military Presence in Kenya?",
         y = "Chinese Military Presece in Kenya?",
         fill = "Percent of\nRespondents")


  # Views of Military presences

  temp2 <- data |>
    dplyr::select(USMilitaryPresenceView, ChineseMilitaryPresenceView) |>
    group_by(USMilitaryPresenceView, ChineseMilitaryPresenceView) |>
    dplyr::summarise(count = n()) |>
    ungroup() |>
    dplyr::mutate(percent = count/sum(count)) |>
    dplyr::mutate(USMilitaryPresenceView = factor(USMilitaryPresenceView,
                                                  levels = c("Don't know / Decline to answer", "Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive")),
                  ChineseMilitaryPresenceView = factor(ChineseMilitaryPresenceView,
                                                       levels = c("Don't know / Decline to answer", "Very negative", "Somewhat negative", "Neither positive nor negative", "Somewhat positive", "Very positive")))


  tempplot2 <- ggplot(data = temp2, aes(x = USMilitaryPresenceView, y = ChineseMilitaryPresenceView, fill = percent)) +
    geom_tile(color = "white", linewidth = 0.13) +
    theme_flynn(base_size = 9, base_family = "Oswald") +
    viridis::scale_fill_viridis(option = "magma", labels = scales::percent_format()) +
    scale_x_discrete(labels = scales::wrap_format(20),
                     expand = c(0,0)) +
    scale_y_discrete(labels = scales::wrap_format(20),
                     expand = c(0,0)) +
    theme(axis.text.x.bottom = element_text(angle = 45, hjust = 1, lineheight = 1),
          axis.text.y.left = element_text(hjust = 1, lineheight = 1)) +
    labs(x = "Views of US Presence?",
         y = "Views of Chinese Presence?",
         fill = "Percent of\nRespondents")

  patchwork::wrap_plots(tempplot, tempplot2) +
    patchwork::plot_annotation(tag_levels = 'A')

  ggsave(here::here("Figures/NSF/nsf-figure-military-presence.jpg"),
         height = 4,
         width = 9)

}
