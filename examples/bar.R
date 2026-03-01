source("theme_k88chart.R")

df_bar <- read.csv("data/bar.csv", stringsAsFactors = FALSE)
country_levels <- unique(df_bar$country)
df_bar$country <- factor(df_bar$country, levels = country_levels)

p <- ggplot(df_bar, aes(y = country, x = participation_rate, fill = sex)) +
  geom_col(position = position_dodge(width = 0.82), width = 0.78) +
  scale_x_continuous(labels = scales::percent_format(scale = 1), limits = c(0, 100)) +
  scale_fill_k88("blues") +
  labs(
    title = "Labor-force participation by country and sex",
    subtitle = "Latest available World Bank observations",
    x = "Participation rate",
    y = NULL,
    caption = k88_source_caption("World Bank, indicators SL.TLF.CACT.MA.ZS and SL.TLF.CACT.FE.ZS (latest available)")
  ) +
  theme_k88chart() +
  theme(
    panel.grid.major.x = element_line(color = k88_gray, linewidth = 0.4, linetype = "dotted"),
    panel.grid.major.y = element_blank()
  )

k88_save("examples/bar.png", p, height = 5.8)
