library(ggplot2)
dir.create("~/.local/share/fonts", showWarnings = FALSE, recursive = TRUE)
systemfonts::get_from_google_fonts("Oswald", dir = "~/.local/share/fonts/")
systemfonts::register_variant(
  name = "Oswald Light",
  family = "Oswald",
  weight = "light"
)
system("fc-cache -fv")
system("fc-match 'Oswald Light'")

# ---- parameters ----
a <- 1      # globe width radius
b <- 0.95    # globe height radius
pixel_size <- 0.08 # square tile size
tile_gap <- 0.02 # gap between tiles
hemisphere_gap <- 0.02 # gap between hemispheres
tilt <- 18 * pi / 180 # parallel tilt angle
meridian_lons_deg <- c(0, -25, -50) # meridian longitudes
parallel_lats_deg <- c(0, 30, -30) # parallel latitudes
logo_text <- "geocompx" # wordmark text
font_family <- "Oswald" # preferred font family
font_light_family <- "Oswald Light" # preferred font weight
outline_lwd <- 1 # left outline width
grid_lwd <- 0.8 # graticule line width
tile_lwd <- 0.4 # tile stroke width
mask_tol <- 1e-9 # numeric visibility tolerance

# ---- ellipse (left globe) ----
t <- seq(pi/2, 3*pi/2, length.out = 300)
ellipse <- data.frame(x = a * cos(t), y = b * sin(t))

deg2rad <- function(deg) deg * pi / 180

project_globe <- function(lat, lon, tilt_rad = tilt) {
  x <- cos(lat) * sin(lon)
  y <- sin(lat)
  z <- cos(lat) * cos(lon)
  y2 <- y * cos(tilt_rad) - z * sin(tilt_rad)
  z2 <- y * sin(tilt_rad) + z * cos(tilt_rad)
  data.frame(x = a * x, y = b * y2, z = z2)
}

visible_left_front <- function(df) {
  (df$z >= -mask_tol) & (df$x <= mask_tol)
}

split_visible_segments <- function(df, id) {
  keep <- visible_left_front(df)
  runs <- cumsum(c(TRUE, diff(keep) != 0))
  visible_runs <- unique(runs[keep])

  do.call(
    rbind,
    lapply(seq_along(visible_runs), function(index) {
      segment <- df[runs == visible_runs[[index]] & keep, c("x", "y")]
      if (nrow(segment) == 0) {
        return(NULL)
      }
      segment$gid <- paste0(id, "-", index)
      segment
    })
  )
}

build_graticule <- function(values_deg, coordinate = c("lon", "lat"), n = 400) {
  coordinate <- match.arg(coordinate)

  do.call(rbind, lapply(seq_along(values_deg), function(index) {
    value_rad <- deg2rad(values_deg[[index]])

    if (coordinate == "lon") {
      lat <- seq(-pi / 2, pi / 2, length.out = n)
      lon <- rep(value_rad, n)
      id <- paste0("m", index)
      tilt_rad <- 0
    } else {
      lon <- seq(-pi, pi, length.out = n)
      lat <- rep(value_rad, n)
      id <- paste0("p", index)
      tilt_rad <- tilt
    }

    projected <- project_globe(lat = lat, lon = lon, tilt_rad = tilt_rad)
    split_visible_segments(projected, id = id)
  }))
}

build_tile_grid <- function(pixel_size, tile_gap, hemisphere_gap) {
  tile_step <- pixel_size + tile_gap
  x_centers <- seq(
    hemisphere_gap + pixel_size / 2,
    a - pixel_size / 2,
    by = tile_step
  )
  y_limit <- b - pixel_size / 2
  max_row_index <- floor(y_limit / tile_step)
  y_centers <- seq(-max_row_index, max_row_index) * tile_step

  candidates <- expand.grid(x = x_centers, y = y_centers)
  corners <- expand.grid(dx = c(-0.5, 0.5), dy = c(-0.5, 0.5))

  keep <- vapply(seq_len(nrow(candidates)), function(index) {
    x_corner <- candidates$x[[index]] + corners$dx * pixel_size
    y_corner <- candidates$y[[index]] + corners$dy * pixel_size
    all(x_corner >= -mask_tol) &&
      all((x_corner^2 / a^2 + y_corner^2 / b^2) <= (1 + mask_tol))
  }, logical(1))

  candidates[keep, , drop = FALSE]
}

# ---- meridians ----
meridians <- build_graticule(meridian_lons_deg, coordinate = "lon")

# ---- parallels ----
parallels <- build_graticule(parallel_lats_deg, coordinate = "lat")

# ---- right hemisphere pixels (half ellipse) ----
grid <- build_tile_grid(
  pixel_size = pixel_size,
  tile_gap = tile_gap,
  hemisphere_gap = hemisphere_gap
)

# ---- logo plot builder ----
base_logo_plot <- function() {
  ggplot() +
    # left hemisphere fill (behind) and outline
    geom_polygon(data = ellipse, aes(x, y), fill = "white", color = NA) +
    geom_path(data = ellipse, aes(x, y), linewidth = outline_lwd) +
    # meridians
    geom_path(data = meridians, aes(x, y, group = gid), linewidth = grid_lwd) +
    # parallels
    geom_path(data = parallels, aes(x, y, group = gid), linewidth = grid_lwd) +
    # right hemisphere pixels
    geom_tile(
      data = grid, aes(x, y),
      width = pixel_size,
      height = pixel_size,
      fill = "white",
      color = "black",
      linewidth = tile_lwd
    ) +
    theme_void() +
    theme(plot.margin = margin(10, 10, 10, 10))
}

# ---- versions ----
logo_only <- base_logo_plot() +
  coord_equal()

logo_vertical <- base_logo_plot() +
  annotate(
    "text",
    x = 0, y = -1.25,
    label = logo_text,
    family = font_light_family,
    fontface = "plain",
    size = 32
  ) + 
  coord_equal(xlim = c(-1.1, 1.1), ylim = c(-1.65, 1.1), clip = "off")

logo_horizontal <- base_logo_plot() +
  annotate(
    "text",
    x = 1.15, y = 0.15,
    label = logo_text,
    family = font_light_family,
    fontface = "plain",
    size = 48,
    hjust = 0
  ) +
  coord_equal(xlim = c(-1.1, 5.1), ylim = c(-1.1, 1.1), clip = "off")

# --- white-text variants (plain white text, for dark shirts) ---
logo_vertical_white <- base_logo_plot() +
  annotate(
    "text",
    x = 0, y = -1.25,
    label = logo_text,
    family = font_light_family,
    fontface = "plain",
    size = 32,
    colour = "white"
  ) +
  coord_equal(xlim = c(-1.1, 1.1), ylim = c(-1.65, 1.1), clip = "off")

logo_horizontal_white <- base_logo_plot() +
  annotate(
    "text",
    x = 1.15, y = 0.15,
    label = logo_text,
    family = font_light_family,
    fontface = "plain",
    size = 48,
    hjust = 0,
    colour = "white"
  ) +
  coord_equal(xlim = c(-1.1, 5.1), ylim = c(-1.1, 1.1), clip = "off")

favicon_plot <- base_logo_plot() +
  coord_equal(xlim = c(-1.05, 1.05), ylim = c(-1.05, 1.05), clip = "off")

svg_web_fonts <- systemfonts::fonts_as_import(font_family, weight = "light")

# ---- saves ----
# Final portable SVGs may require converting text to paths in Inkscape.
ggsave("static/logo/geocompx-logo-only2026.png", logo_only, width = 4, height = 4, dpi = 300, bg = NULL, device = ragg::agg_png)
ggsave("static/logo/geocompx-logo-vertical2026.png", logo_vertical, width = 5.5, height = 5, dpi = 300, bg = NULL, device = ragg::agg_png)
ggsave("static/logo/geocompx-logo-horizontal2026.png", logo_horizontal, width = 11, height = 4, dpi = 300, bg = NULL, device = ragg::agg_png)
ggsave("static/logo/geocompx-logo-only2026.svg", logo_only, width = 4, height = 4, bg = NULL, device = svglite::svglite, web_fonts = svg_web_fonts)
ggsave("static/logo/geocompx-logo-vertical2026.svg", logo_vertical, width = 5.5, height = 5, bg = NULL, device = svglite::svglite, web_fonts = svg_web_fonts)
ggsave("static/logo/geocompx-logo-horizontal2026.svg", logo_horizontal, width = 11, height = 4, bg = NULL, device = svglite::svglite, web_fonts = svg_web_fonts)
ggsave("static/logo/favicon-512.png", favicon_plot, width = 512 / 96, height = 512 / 96, dpi = 96, bg = NULL, device = ragg::agg_png)

# ---- saves for white-text variants ----
ggsave("static/logo/geocompx-logo-vertical-white2026.png", logo_vertical_white, width = 5.5, height = 5, dpi = 300, bg = NULL, device = ragg::agg_png)
ggsave("static/logo/geocompx-logo-vertical-white2026.svg", logo_vertical_white, width = 5.5, height = 5, bg = NULL, device = svglite::svglite, web_fonts = svg_web_fonts)
ggsave("static/logo/geocompx-logo-horizontal-white2026.png", logo_horizontal_white, width = 11, height = 4, dpi = 300, bg = NULL, device = ragg::agg_png)
ggsave("static/logo/geocompx-logo-horizontal-white2026.svg", logo_horizontal_white, width = 11, height = 4, bg = NULL, device = svglite::svglite, web_fonts = svg_web_fonts)
