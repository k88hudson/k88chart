source("theme_k88chart.R")

df_dumbbell <- read.csv("data/dumbbell.csv", stringsAsFactors = FALSE)
df_dumbbell$category <- sub(
  "Middle East, North Africa, Afghanistan & Pakistan",
  "Middle East, North Africa,\nAfghanistan & Pakistan",
  df_dumbbell$category,
  fixed = TRUE
)
label_row <- df_dumbbell[1, ]
df_dumbbell$category <- factor(df_dumbbell$category, levels = rev(df_dumbbell$category))

p <- ggplot(df_dumbbell) +
  geom_segment(aes(x = before, xend = after, y = category, yend = category),
               color = k88_gray, linewidth = 0.6) +
  geom_point(aes(x = before, y = category), size = 3, color = k88_blue) +
  geom_point(aes(x = after, y = category), size = 3, color = k88_red) +
  annotate("text", x = label_row$after, y = as.character(label_row$category), label = "2023",
           color = k88_red, fontface = "bold", size = 3.5, vjust = -1) +
  annotate("text", x = label_row$before, y = as.character(label_row$category), label = "2000",
           color = k88_blue, fontface = "bold", size = 3.5, vjust = -1) +
  scale_x_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title = "Population age 65+ share by world region",
    subtitle = "Change in share of population between 2000 and 2023",
    x = "Share of population", y = NULL,
    caption = k88_source_caption("World Bank indicator SP.POP.65UP.TO.ZS (2000 vs 2023)")
  ) +
  coord_cartesian(clip = "off") +
  theme_k88chart() +
  theme(panel.grid.major.y = element_blank())

k88_save("examples/dumbbell.png", p)
