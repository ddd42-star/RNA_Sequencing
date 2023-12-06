#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/11_bedtoolsIntersect_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
BED=/data/users/dbassi/rnaseq_course/bed

#module add bedtools
module add UHTS/Analysis/BEDTools/2.29.2


# Bedtools intersect for 5' ends
bedtools intersect -v -a $BED/all_merge.bed -b $BED/refTSS_v4.1_human_coordinate.hg38.bed > $BED/overlap5prime.bed

# Bedtools intersect for 3' ends
bedtools intersect -v -a $BED/all_merge.bed -b $BED/atlas.clusters.2.0.GRCh38.96.bed > $BED/overlap3prime.bed





