source("theme_k88chart.R")

df_lines <- read.csv("data/lines.csv", stringsAsFactors = FALSE)
country_order <- c("Korea, Rep.", "Japan", "Germany", "United States", "United Kingdom", "France")
df_lines$country <- factor(df_lines$country, levels = country_order)
years <- sort(unique(df_lines$year))

df_labels <- df_lines[df_lines$year == max(years), ]
label_nudges <- c("United States" = 0.08, "France" = -0.08, "Korea, Rep." = 0.08)
df_labels$nudge_y <- label_nudges[as.character(df_labels$country)]
df_labels$nudge_y[is.na(df_labels$nudge_y)] <- 0

p <- ggplot(df_lines, aes(x = year, y = spend, color = country)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  geom_outlined_text(data = df_labels, aes(label = country),
            hjust = 0, nudge_x = 0.3, nudge_y = df_labels$nudge_y,
            size = 3.5, color = k88_black, show.legend = FALSE) +
  scale_color_k88() +
  scale_x_continuous(breaks = years, expand = expansion(mult = c(0.02, 0.18))) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  coord_cartesian(clip = "off") +
  labs(
    title = "R&D spending as share of GDP",
    subtitle = "World Bank data shows Korea and Japan leading research investment intensity",
    x = NULL, y = "Gross R&D expenditure (% of GDP)",
    caption = k88_source_caption("World Bank indicator GB.XPD.RSDV.GD.ZS (2014-2022)")
  ) +
  theme_k88chart() +
  theme(legend.position = "none")

k88_save("examples/lines.png", p)
