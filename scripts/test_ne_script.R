library(dartRverse)
library(dartR.popgen)
library(ggplot2)
library(geohippos)
library(vcfR)
library(adegenet)

path.binaries <- "/home/trevor/Programs/NeEstimator-2.1"
setwd("/home/trevor/dev/lc_refuges_manuscript/")

# Test test data
# Run as it was classically run
# SNP data (use two populations and only the first 100 SNPs)

pops <- possums.gl[1:60, 1:100]
nes <- gl.LDNe(pops, outfile="popsLD.txt",
               neest.path = path.binaries,
               critical = c(0, 0.05), 
               singleton.rm = TRUE,
               mating = "random")

# Bishop

bishop_vcf <- read.vcfR('data/bishop/bishop.snps.vcf')
bishop <- vcfR2genlight(bishop_vcf)

bishop_pop <- bishop$ind.names[grepl('Bishop', bishop$ind.names)]
red_knolls <- bishop$ind.names[grepl('Red', bishop$ind.names)]

bishop <- gl.define.pop(bishop, bishop_pop, 'bishop')
bishop <- gl.define.pop(bishop, red_knolls, 'red_knolls')

bishop_loc.allbishop_nes <- gl.LDNe(bishop,
                      outfile='bishop_popsLD.txt',
                      neest.path = path.binaries,
                      critical = c(0, 0.05),
                      singleton.rm = TRUE,
                      mating = "random",
                      naive=TRUE)

bishop_sub <- bishop[1:26, sample(2486, 50)]

test <- gl.LDNe(bishop_sub,
        outfile='bishop_popsLD.txt',
        neest.path = path.binaries,
        critical = c(0, 0.05),
        singleton.rm = TRUE,
        mating = "random",
        plot.out=FALSE)

test
 

gl.sfs(gl.impute(bishop[1:14,]))
