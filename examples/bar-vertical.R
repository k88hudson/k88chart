source("theme_k88chart.R")

df_bar_vertical <- read.csv("data/bar-vertical.csv", stringsAsFactors = FALSE)
df_bar_vertical$label <- factor(df_bar_vertical$label, levels = df_bar_vertical$label)
year_min <- min(df_bar_vertical$year)
year_max <- max(df_bar_vertical$year)
year_text <- if (year_min == year_max) as.character(year_max) else paste0(year_min, "-", year_max)

p <- ggplot(df_bar_vertical, aes(x = label, y = growth)) +
  geom_col(width = 0.65, fill = k88_blue) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(
    title = "GDP growth across G7 economies",
    subtitle = paste0("Latest available World Bank observations (", year_text, ")"),
    x = NULL,
    y = "Annual GDP growth",
    caption = k88_source_caption("World Bank indicator NY.GDP.MKTP.KD.ZG (latest available)")
  ) +
  theme_k88chart()

k88_save("examples/bar-vertical.png", p)
