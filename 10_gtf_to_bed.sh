#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/10_gtfToBed_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
GTF=/data/users/dbassi/rnaseq_course/transcriptome_assembly
BED=/data/users/dbassi/rnaseq_course/bed


#create a directory if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/bed


module add UHTS/Analysis/bedops/2.4.40

awk '$3=="transcript" {print}' $GTF/all_merge.gtf > $GTF/transcript_all_merge.gtf

convert2bed -i gtf < $GTF/transcript_all_merge.gtf > $BED/all_merge.bed

