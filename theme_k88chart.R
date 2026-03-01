# theme_k88chart: an editorial ggplot2 theme
# Inspired by NIST/policy-report chart style
#
# Usage:
#   source("theme_k88chart.R")
#   ggplot(data, aes(...)) + geom_col() + theme_k88chart()
#
# Color palette:
#   k88_blue     - primary fill/line color
#   k88_navy     - secondary/darker variant
#   k88_red      - accent/highlight color
#   k88_gray     - gridline and muted text
#   scale_fill_k88() / scale_color_k88() - discrete scales

library(ggplot2)
library(showtext)
font_add_google("IBM Plex Sans", "ibm-plex-sans")
showtext_auto()
showtext_opts(dpi = 300)

# --- Palette (Observable10) ---
k88_blue   <- "#003DA5"
k88_red    <- "#ff725c"
k88_yellow <- "#efb118"
k88_teal   <- "#6cc5b0"
k88_green  <- "#3ca951"
k88_pink   <- "#ff8ab7"
k88_purple <- "#a463f2"
k88_ltblue <- "#97bbf5"
k88_brown  <- "#9c6b4e"
k88_gray   <- "#9498a0"
k88_black  <- "#1A1A1A"

k88_palette <- c(k88_blue, k88_red, k88_yellow, k88_teal, k88_green,
                 k88_pink, k88_purple, k88_ltblue, k88_brown, k88_gray)

k88_palette_blues   <- c("#041E42", "#003DA5", "#B0C3E3", "#E6ECF6")
k88_palette_reds    <- c("#7a1a0e", "#e05545", "#ff725c", "#ffd9d2")
k88_palette_neutral <- c("#4B4A45", "#A19E93", "#D6D2C4", "#FAF8F5")

scale_fill_k88 <- function(palette = "default", ...) {
  vals <- switch(palette,
    blues = k88_palette_blues,
    reds  = k88_palette_reds,
    k88_palette
  )
  scale_fill_manual(values = vals, ...)
}

scale_color_k88 <- function(palette = "default", ...) {
  vals <- switch(palette,
    blues = k88_palette_blues,
    reds  = k88_palette_reds,
    k88_palette
  )
  scale_color_manual(values = vals, ...)
}

# --- Helpers ---
annotate_outlined_text <- function(..., outline_color = "white", padding = 0.25) {
  args <- list(...)
  label_args <- args
  label_args$fill <- outline_color
  label_args$border.colour <- NA
  label_args$label.padding <- unit(padding, "lines")
  label_args$label.r <- unit(0, "lines")
  do.call(annotate, c("label", label_args))
}

geom_outlined_text <- function(..., outline_color = "white", padding = 0.15) {
  geom_label(..., fill = outline_color, border.colour = NA,
             label.padding = unit(padding, "lines"), label.r = unit(0, "lines"))
}

k88_source_caption <- function(source_text) {
  paste0("Source: ", source_text)
}

k88_save <- function(filename, plot = last_plot(), width = 6.5, height = 4, dpi = 300, ...) {
  ggsave(filename, plot, width = width, height = height, dpi = dpi, bg = "white", ...)
}

# --- Theme ---
theme_k88chart <- function(base_size = 13, base_family = "ibm-plex-sans") {
  theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    theme(
      # Background
      plot.background   = element_rect(fill = "white", color = NA),
      panel.background  = element_rect(fill = "white", color = NA),
      panel.border      = element_blank(),

      # Grid: horizontal dashed only
      panel.grid.major.y = element_line(color = k88_gray, linewidth = 0.4, linetype = "dotted"),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),

      # Axes
      axis.line   = element_blank(),
      axis.ticks  = element_blank(),
      axis.title  = element_text(size = rel(0.9), color = k88_black, margin = margin(t = 8)),
      axis.title.y = element_text(angle = 90, margin = margin(r = 8)),
      axis.text   = element_text(size = rel(0.85), color = k88_black),

      # Title / subtitle / caption
      plot.title    = element_text(
        size = rel(1.2), face = "bold", color = k88_black,
        hjust = 0, margin = margin(b = 4)
      ),
      plot.subtitle = element_text(
        size = rel(0.85), color = k88_black,
        hjust = 0, margin = margin(b = 12)
      ),
      plot.caption  = element_text(
        size = rel(0.7), color = k88_gray,
        hjust = 0, margin = margin(t = 10)
      ),
      plot.caption.position = "plot",

      # Legend
      legend.position  = "top",
      legend.justification = "left",
      legend.title     = element_blank(),
      legend.text      = element_text(size = rel(0.85), color = k88_black),
      legend.key       = element_rect(fill = NA, color = NA),
      legend.key.size  = unit(0.9, "lines"),
      legend.margin    = margin(b = 8),

      # Facets
      strip.text       = element_text(
        size = rel(0.9), face = "bold", color = k88_black, hjust = 0
      ),
      strip.background = element_blank(),

      # Spacing
      plot.margin = margin(16, 16, 12, 12)
    )
}
