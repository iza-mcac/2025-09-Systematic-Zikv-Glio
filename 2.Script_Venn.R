# Installing and calling packages:
#Author: Diego Menezes

install.packages('readxl')
install.packages('dplyr')
install.packages('tidyverse')
install.packages('VennDiagram')
install.packages('png')
install.packages('ggplotify')
install.packages('ggpubr')
install.packages('grid')

library(readxl)
library(dplyr)
library(tidyverse)
library(VennDiagram)
library(png)
library(ggplotify)
library(ggpubr)
library(grid)

# Importing datasets:

degs <- read_excel("data/Table S1.xlsx")

#Modifying datasets:

lista_degs <- degs %>%
  group_by(expression) %>%
  summarise(genes = list(gene)) %>%
  deframe()

length(reduce(lista_degs, intersect))

degsUP <- degs[degs$expression=='upregulated',]
degsDOWN <- degs[degs$expression=='downregulated',]


lista_UP <- degsUP %>%
  group_by(author) %>%
  summarise(genes = list(gene)) %>%
  deframe()

print(reduce(lista_UP, intersect))

lista_DOWN <- degsDOWN %>%
  group_by(author) %>%
  summarise(genes = list(gene)) %>%
  deframe()

print(reduce(lista_DOWN, intersect))

# VennDiagrams:

## Color vector:

pastel_colors <- c('#FFB3BA', '#BAFFC9', '#FFFFBA', '#BAE1FF')  

## Generating graphs:

GrafUp <- venn.diagram(
  x = lista_UP,
  filename = NULL,
  fill = pastel_colors,
  alpha = 0.5,
  cex = 1.2,
  cat.cex = 1,
  cat.col = 'black',
  margin = 0.1,
  fontfamily = 'Times New Roman',
  cat.fontfamily = 'Times New Roman'
)

GrafDown <- venn.diagram(
  x = lista_DOWN,
  filename = NULL,
  fill = pastel_colors,
  alpha = 0.5,
  cex = 1.2,
  cat.cex = 1,
  cat.col = 'black',
  margin = 0.1,
  fontfamily = 'Times New Roman',
  cat.fontfamily = 'Times New Roman'
)

# Converting to ggplot grob objects:

p1 <- as.ggplot(function() grid.draw(GrafUp))
p2 <- as.ggplot(function() grid.draw(GrafDown))

# Save panel:

png('Fig2.png', width = 8000, height = 8000, res = 900)
ggarrange(
  p1, p2,
  nrow = 2,
  labels = c('A', 'B'),
  font.label = list(size = 10, face = 'bold',
                    family = 'Times New Roman')
)
dev.off()
