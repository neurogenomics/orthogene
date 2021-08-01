## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, root.dir=here::here())
knitr::opts_knit$set(root.dir=here::here())

## ----setup--------------------------------------------------------------------
library(orthogene)

library(dplyr)
library(ggplot2) 
library(patchwork)

## -----------------------------------------------------------------------------
species <- c(human="H sapiens",
             chimp="P troglodytes",
             baboon="P anubis", 
             macaque = "M mulatta",
             marmoset = "C jacchus",
             mouse = "M musculus",
             rat = "R norvegicus",
             hamster = "M auratus",
             dog = "C lupus familiaris",
             cat = "F catus",
             cow = "B taurus",
             chicken = "G gallus",
             zebrafish = "D rerio",
             fly = "D melanogaster",
             worm = "C elegans",
             rice = "O sativa"
             )
species_mapped <- map_species(species = species) %>% `names<-`(names(species))


## ---- eval=FALSE--------------------------------------------------------------
#  bench_res <- orthogene:::run_benchmark(species_mapped = species_mapped[c("human","mouse","fly")],
#                                         run_convert_orthologs = TRUE,
#                                         mc.core = 10)
#  # write.csv(bench_res, here::here("inst/benchmark/bench_res_example.csv"), row.names = FALSE)

## -----------------------------------------------------------------------------
if(!exists("bench_res")) {
  bench_res <- read.csv(system.file(package = "orthogene","benchmark/bench_res_example.csv"))
}
knitr::kable(bench_res)

## ---- fig.height=8------------------------------------------------------------
bench_barplot <- orthogene:::plot_benchmark_bar(bench_res = bench_res)
# ggsave(here::here("inst/benchmark/bench_barplot.pdf"),bench_barplot, height = 8)

## -----------------------------------------------------------------------------
bench_scatterplot <- orthogene:::plot_benchmark_scatter(bench_res = bench_res)
# ggsave(here::here("inst/benchmark/bench_scatterplot.pdf"),bench_scatterplot)

## ----Session Info-------------------------------------------------------------
utils::sessionInfo()

