# ---------------------------------------------------------

# Melbourne Bioinformatics Training Program

# This exercise to assess your familiarity with R and git. Please follow
# the instructions on the README page and link to your repo in your application.
# If you do not link to your repo, your application will be automatically denied.

# Leave all code you used in this R script with comments as appropriate.
# Let us know if you have any questions!


# You can use the resources available on our training website for help:
# Intro to R: https://mbite.org/intro-to-r
# Version Control with Git: https://mbite.org/intro-to-git/

# ----------------------------------------------------------

# Load libraries -------------------
# You may use base R or tidyverse for this exercise

# ex. library(tidyverse)

library(tidyverse)

# Load data here ----------------------
# Load each file with a meaningful variable name.

metadata <- readr::read_csv("/Users/PYYIN1/Desktop/training-program-application-2026/data/GSE60450_filtered_metadata.csv", show_col_types = FALSE)
expr_wide <- readr::read_csv("/Users/PYYIN1/Desktop/training-program-application-2026/data/GSE60450_GeneLevel_Normalized(CPM.and.TMM)_data.csv", show_col_types = FALSE)


# Inspect the data -----------------
dim(metadata)
dim(expr_wide)

# Clean up metadata ----------------
metadata_clean <- metadata %>%
  rename(sample_id = 1) %>%   # renames the *first* column to sample_id
  rename(
    cell_type = immunophenotype,
    developmental_stage = `developmental stage`
  )


expr_long <- expr_wide %>%
  rename(ensembl_id = 1) %>%  
  pivot_longer(
    cols = starts_with("GSM"),
    names_to = "sample_id",
    values_to = "expression"
  )

# Prepare/combine the data for plotting ------------------------
# How can you combine this data into one data.frame?

combined <- expr_long %>%
  left_join(metadata_clean, by = "sample_id")


# Plot the data --------------------------
## Plot the expression by cell type
## Can use boxplot() or geom_boxplot() in ggplot2
p <- ggplot(combined, aes(x = cell_type, y = expression)) +
  geom_boxplot() +
  theme_bw() +
  labs(
    title = "Overall expression distribution by cell type",
    x = "Cell type",
    y = "Expression level"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 30, hjust = 1)
  )

print(p)
## Save the plot
### Show code for saving the plot with ggsave() or a similar function
ggsave(
  filename = "/Users/PYYIN1/Desktop/training-program-application-2026/results/gene_expression_by_cell_type_boxplot.png",
  plot = p,
  dpi = 300,
  height = 5,
  width = 8
)
