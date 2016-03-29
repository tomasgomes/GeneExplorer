# GeneExplorer
A simple shiny app for exploring genes in single cell RNA-seq data

![alt tag](http://imgur.com/cADhx8p)

Running (in R):
 1. Download and install shiny package
 2. library(shiny)
 3. runGitHub("GeneExplorer","tomasgomes")

Notes on usage:
 - Expression table is a genes-by-cells matrix, requiring both row (gene) and column (cell) names
 - Subgroups table is a cells-by-subgroups matrix, requiring both row (cell) and column (header) names
 - Cell names must match between tables
 - The app is expression unit-agnostic, and the minimum expression threshold is decided by the user
 - The files are capped at 100Mb
