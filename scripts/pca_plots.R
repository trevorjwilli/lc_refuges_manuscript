library(tidyverse)
library(ggsci)
library(ggpubr)

setwd('~/dev/lc_refuges_manuscript/')


#' Plot PCA Data
#' 
#' Plots PCA data created by smartpca that is located in the specified directory
#' 
#' @param path Path to directory with `pca` subdirectory within it
#' @param output_name Name to write out plot to
#' @param return What data to return, if 'data.frame' returns the data frame if 
#' 'plot' returns the plot.
#' 
#' @return Dataframe with formatted pca data and a ggplot graph
plot_pca <- function(path, outpath=NA, returns='plot') {
  
  stopifnot(returns %in% c('plot', 'data.frame'))
  
  # Read in eigenvalues
  eigen_path <- file.path(path, 'pca', 'pca.eval')
  eigen <- read.table(eigen_path)
  eigen <- eigen |>
    mutate(percent = V1/sum(V1))
  percent_pc1 <- eigen$percent[1]
  percent_pc2 <- eigen$percent[2]
  
  # Make list of source poopulation names
  source_pops <- c('Bishop', 'Clear Lake', 'Gandy', 'Leland Harris',
                   'Mills Valley', 'Mona')
  
  # Read in PC scores
  evec_path <- file.path(path, 'pca', 'pca.evec')
  evec <- read.table(evec_path)
  colnames(evec) <- c('sample', paste0('PC', 1:20), 'pop')
  
  # Wrangle data
  evec <- evec |>
    mutate(
      sample = gsub('\\w+[:](.*)', '\\1', sample),
      pop = str_replace(pop, "_", " "),
      refuge = case_when(
        pop %in% source_pops ~ 'Source',
        .default = 'Refuge'
      )
    )
  
  # Plot PCA
  p <- ggplot(evec, aes(PC1, PC2, shape = pop, color = refuge)) +
    geom_point(size = 2) +
    scale_color_d3() +
    coord_fixed(percent_pc2/percent_pc1) +
    xlab(paste0('PC1 (', round(percent_pc1*100, digits=1), '%)')) +
    ylab(paste0('PC2 (', round(percent_pc2*100, digits=1), '%)')) +
    theme_bw() +
    guides(color = "none", shape = guide_legend(title=NULL)) +
    theme(legend.title = element_blank(),
          axis.text = element_text(size = 7),
          axis.title = element_text(size = 7),
          legend.text = element_text(size = 5))
  
  # If output path given, save plot
  if(!is.na(outpath)) {
    print(paste0('Writing plot to ', path))
    
    ggsave(paste0(outpath, '.png'), plot=p, device = 'png',
           width = 140, height = 100, units = 'mm', dpi = 300)
    
    ggsave(paste0(outpath, '.pdf'), plot=p, device = 'pdf',
           width = 140, height = 100, units = 'mm', dpi = 300)
  }

  print(p)
  if(returns == 'plot') {
    return(p)
  } else {
    return(evec)
  }
}

b_plot <- plot_pca('data/bishop/', outpath = 'data/bishop/pca_plot')
cl_plot <- plot_pca('data/clear_lake/', outpath = 'data/clear_lake/pca_plot')
g_plot <- plot_pca('data/gandy/', outpath = 'data/gandy/pca_plot')
lh_plot <- plot_pca('data/leland_harris/', outpath = 'data/leland_harris/pca_plot')
mv_plot <- plot_pca('data/mills_valley/', outpath = 'data/mills_valley/pca_plot')
mo_plot <- plot_pca('data/mona/', outpath = 'data/mona/pca_plot')

ggarrange(b_plot, lh_plot, g_plot, mv_plot, cl_plot, mo_plot, 
          ncol=2, nrow=3, labels=LETTERS,
          font.label=list(size=8, color='black', face='bold'))

ggsave('figures/all_pca_plots.pdf', device='pdf', width=168, height=168,
       units='mm', dpi=300)
ggsave('figures/all_pca_plots.png', device='png', width=168, height=168,
       units='mm', dpi=300)
