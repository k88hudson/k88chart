source("theme_k88chart.R")

df_cleveland <- read.csv("data/cleveland.csv", stringsAsFactors = FALSE)
df_cleveland$country <- factor(df_cleveland$country, levels = rev(df_cleveland$country))

p <- ggplot(df_cleveland, aes(x = rate, y = country)) +
  geom_segment(aes(x = 0, xend = rate, yend = country), color = k88_gray, linewidth = 0.4) +
  geom_point(size = 3, color = k88_blue) +
  scale_x_continuous(limits = c(0, 100), labels = function(x) paste0(x, "%")) +
  labs(
    title = "Internet usage rate by country",
    subtitle = "Latest World Bank observations show near-universal access in N Europe",
    x = NULL, y = NULL,
    caption = k88_source_caption("World Bank indicator IT.NET.USER.ZS (latest available)")
  ) +
  theme_k88chart() +
  theme(panel.grid.major.y = element_blank())

k88_save("examples/cleveland.png", p)
