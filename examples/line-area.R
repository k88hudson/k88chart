source("theme_k88chart.R")

df_line <- read.csv("data/line-area.csv", stringsAsFactors = FALSE)

p <- ggplot(df_line, aes(x = age, y = rejection_rate)) +
  geom_area(
    data = subset(df_line, age <= 18),
    aes(y = rejection_rate), fill = k88_palette_neutral[4]
  ) +
  geom_area(
    data = subset(df_line, age >= 18),
    aes(y = rejection_rate), fill = k88_palette_blues[2]
  ) +
  geom_line(data = subset(df_line, age <= 18), color = k88_palette_neutral[3], linewidth = 0.8) +
  geom_line(data = subset(df_line, age >= 18), color = k88_palette_blues[1], linewidth = 0.8) +
  geom_point(color = k88_black, size = 2) +
  geom_vline(xintercept = 18, linewidth = 0.6, color = k88_black) +
  scale_y_continuous(labels = scales::percent_format(scale = 1), limits = c(0, 100),
                     expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(breaks = seq(10, 25, 2)) +
  coord_cartesian(clip = "off") +
  annotate_outlined_text(x = 18, y = 100, label = "Threshold Age",
           hjust = 0.5, vjust = -0.5, fontface = "bold", size = 4, color = k88_black) +
  labs(
    title = "Rejection rate by age of subject",
    subtitle = "Over half of 18-year-olds were falsely rejected",
    y = "Rejection rate",
    x = "Age of Subject",
  ) +
  theme_k88chart() +
  theme(panel.ontop = TRUE, panel.background = element_rect(fill = NA, color = NA))

k88_save("examples/line-area.png", p)
