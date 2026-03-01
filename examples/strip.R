source("theme_k88chart.R")

df_strip <- read.csv("data/strip.csv", stringsAsFactors = FALSE)

p <- ggplot(df_strip, aes(x = group, y = value, color = group)) +
  geom_jitter(width = 0.15, size = 2, shape = 21, stroke = 0.5, aes(fill = group), color = "white") +
  stat_summary(fun = mean, geom = "point", size = 4, shape = 18, color = k88_black) +
  stat_summary(fun = mean, geom = "crossbar", width = 0.3, linewidth = 0.4,
               color = k88_black, fill = NA) +
  scale_color_k88() +
  scale_fill_k88() +
  labs(
    title = "Hourly temperature samples by city",
    subtitle = "Last 30 hourly observations from Open-Meteo for New York, London, and Tokyo",
    x = NULL, y = "Temperature (°C)",
    caption = k88_source_caption("Open-Meteo hourly temperature, past 7 days (latest 30 observations per city)")
  ) +
  theme_k88chart() +
  theme(legend.position = "none")

k88_save("examples/strip.png", p)
