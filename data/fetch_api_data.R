suppressPackageStartupMessages({
  library(jsonlite)
})

wb_fetch <- function(codes, indicator) {
  endpoint <- sprintf(
    "https://api.worldbank.org/v2/country/%s/indicator/%s?format=json&per_page=20000",
    paste(codes, collapse = ";"),
    indicator
  )
  payload <- fromJSON(endpoint)
  df <- payload[[2]]
  data.frame(
    code = df$countryiso3code,
    country = df$country$value,
    year = as.integer(df$date),
    value = as.numeric(df$value),
    stringsAsFactors = FALSE
  )
}

latest_non_missing <- function(df) {
  out <- do.call(rbind, lapply(split(df, df$code), function(x) {
    x <- x[!is.na(x$value), ]
    if (nrow(x) == 0) {
      return(NULL)
    }
    x[which.max(x$year), c("code", "country", "year", "value")]
  }))
  rownames(out) <- NULL
  out
}

# 1) Grouped bar: labor-force participation by sex
bar_countries <- c("AFG", "PAK", "IND", "BGD", "NGA", "BRA", "USA", "SWE")
bar_male <- wb_fetch(bar_countries, "SL.TLF.CACT.MA.ZS")
bar_female <- wb_fetch(bar_countries, "SL.TLF.CACT.FE.ZS")
bar_male_latest <- latest_non_missing(bar_male)
bar_female_latest <- latest_non_missing(bar_female)

bar_df <- rbind(
  data.frame(country = bar_male_latest$country, sex = "Male", participation_rate = bar_male_latest$value),
  data.frame(country = bar_female_latest$country, sex = "Female", participation_rate = bar_female_latest$value)
)
bar_df$country <- factor(bar_df$country, levels = unique(bar_male_latest$country))
bar_df <- bar_df[order(bar_df$country, bar_df$sex), ]
write.csv(bar_df, "data/bar.csv", row.names = FALSE)

# 2) Vertical bar with short labels: GDP growth for G7 economies
bar_vertical_codes <- c("CAN", "FRA", "DEU", "ITA", "JPN", "GBR", "USA")
bar_vertical_df <- wb_fetch(bar_vertical_codes, "NY.GDP.MKTP.KD.ZG")
bar_vertical_df <- latest_non_missing(bar_vertical_df)
bar_vertical_df <- bar_vertical_df[, c("code", "year", "value")]
names(bar_vertical_df) <- c("label", "year", "growth")
bar_vertical_df <- bar_vertical_df[order(bar_vertical_df$growth, decreasing = TRUE), ]
write.csv(bar_vertical_df, "data/bar-vertical.csv", row.names = FALSE)

# 3) Line/area: keep original threshold-age example values, but store in CSV
line_df <- data.frame(
  age = 10:25,
  rejection_rate = c(99, 98, 96, 94, 93, 92, 84, 68, 48, 45, 28, 8, 1, 0.5, 0.5, 0.3)
)
write.csv(line_df, "data/line-area.csv", row.names = FALSE)

# 4) Multi-line: R&D spending share of GDP by country
rd_countries <- c("KOR", "JPN", "DEU", "USA", "GBR", "FRA")
lines_df <- wb_fetch(rd_countries, "GB.XPD.RSDV.GD.ZS")
lines_df <- lines_df[!is.na(lines_df$value) & lines_df$year >= 2014 & lines_df$year <= 2023, c("year", "value", "country")]
lines_df <- lines_df[order(lines_df$country, lines_df$year), ]
names(lines_df) <- c("year", "spend", "country")
write.csv(lines_df, "data/lines.csv", row.names = FALSE)

# 5) Cleveland plot: internet usage by country
cleveland_countries <- c("SWE", "NOR", "DNK", "FIN", "NLD", "DEU", "FRA", "GBR", "ESP", "ITA", "POL", "GRC")
cleveland_df <- wb_fetch(cleveland_countries, "IT.NET.USER.ZS")
cleveland_df <- latest_non_missing(cleveland_df)
cleveland_df <- cleveland_df[order(cleveland_df$value, decreasing = TRUE), c("country", "value")]
names(cleveland_df) <- c("country", "rate")
write.csv(cleveland_df, "data/cleveland.csv", row.names = FALSE)

# 6) Dumbbell: share of population age 65+ by region (2000 vs 2023)
region_codes <- c("EAS", "ECS", "LCN", "MEA", "NAC", "SAS", "SSF")
aging_df <- wb_fetch(region_codes, "SP.POP.65UP.TO.ZS")
aging_df <- aging_df[aging_df$year %in% c(2000, 2023) & !is.na(aging_df$value), c("country", "year", "value")]
aging_wide <- reshape(
  aging_df,
  idvar = "country",
  timevar = "year",
  direction = "wide"
)
aging_wide <- aging_wide[complete.cases(aging_wide), ]
aging_wide <- aging_wide[order(aging_wide$value.2023, decreasing = TRUE), ]
aging_wide <- aging_wide[, c("country", "value.2000", "value.2023")]
names(aging_wide) <- c("category", "before", "after")
write.csv(aging_wide, "data/dumbbell.csv", row.names = FALSE)

# 7) Strip chart: hourly temperatures for major cities (last 30 observations each)
fetch_city_temps <- function(group, latitude, longitude) {
  endpoint <- sprintf(
    "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&hourly=temperature_2m&past_days=7&forecast_days=0&timezone=UTC",
    latitude,
    longitude
  )
  payload <- fromJSON(endpoint)
  temps <- payload$hourly$temperature_2m
  keep <- tail(temps, 30)
  data.frame(group = group, value = as.numeric(keep), stringsAsFactors = FALSE)
}

strip_df <- rbind(
  fetch_city_temps("New York", 40.7128, -74.0060),
  fetch_city_temps("London", 51.5072, -0.1276),
  fetch_city_temps("Tokyo", 35.6764, 139.6500)
)
write.csv(strip_df, "data/strip.csv", row.names = FALSE)

message("Wrote CSV files to data/")
