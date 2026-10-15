library(ggplot2)
library(dplyr)
library(tidyr)

input <- "output/08_annotation/somatic.filtered.PASS.vep.clinvar.tsv"
output_dir <- "output/09_visualization"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

lines <- readLines(input)
vep <- read.delim(text = paste(lines[!grepl("^##", lines)], collapse = "\n"),
                  check.names = FALSE, quote = "", comment.char = "") %>%
  mutate(chr = factor(sub(":.*", "", Location), levels = c("chr6", "chr17")),
         IMPACT = factor(IMPACT, levels = c("HIGH", "MODERATE", "LOW", "MODIFIER")),
         BIOTYPE = ifelse(BIOTYPE == "-", "unassigned", BIOTYPE))

consequences <- vep %>%
  separate_rows(Consequence, sep = "[,&]") %>%
  mutate(Consequence = factor(Consequence, levels = names(sort(table(Consequence)))))

theme_set(theme_minimal(base_size = 12))
impact_colors <- c(HIGH = "#D55E00", MODERATE = "#E69F00",
                   LOW = "#0072B2", MODIFIER = "#999999")
base_plot <- ggplot(consequences, aes(Consequence)) +
  coord_flip() + labs(x = NULL, y = "Consequence annotations")
impact_plot <- base_plot + geom_bar(aes(fill = IMPACT)) +
  scale_fill_manual(values = impact_colors, drop = FALSE) +
  theme(legend.position = "bottom")

plots <- list(
  consequences = base_plot + geom_bar(fill = "steelblue") +
    ggtitle("Distribution of variant consequences"),
  consequences_by_chromosome = base_plot + geom_bar(fill = "steelblue") +
    facet_grid(~chr) + ggtitle("Consequences by chromosome"),
  consequences_by_impact = impact_plot + ggtitle("Consequences by impact"),
  consequences_by_impact_chromosome = impact_plot + facet_grid(~chr) +
    ggtitle("Consequences by impact and chromosome"),
  variant_classes = vep %>% count(VARIANT_CLASS) %>%
    ggplot(aes(reorder(VARIANT_CLASS, n), n)) + geom_col(fill = "steelblue") +
    coord_flip() + labs(title = "Distribution of variant classes", x = NULL, y = "Variants"),
  biotypes = vep %>% count(BIOTYPE) %>%
    ggplot(aes(reorder(BIOTYPE, n), n)) + geom_col(fill = "steelblue") +
    coord_flip() + labs(title = "Distribution of biotypes", x = NULL, y = "Variants")
)

for (i in seq_along(plots)) {
  path <- file.path(output_dir, sprintf("%02d_%s", i, names(plots)[i]))
  plot <- plots[[i]] + labs(subtitle = paste(nrow(vep), "PASS variants; VEP --pick"))
  ggsave(paste0(path, ".png"), plot, width = 11, height = 6.5, dpi = 300)
  ggsave(paste0(path, ".pdf"), plot, width = 11, height = 6.5)
}
