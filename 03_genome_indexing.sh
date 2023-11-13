#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/03_mapping_reads_%j.o
#SBATCH --partition=pall

READS=/data/users/dbassi/rnaseq_course/reads
REFERENCE=/data/courses/rnaseq_course/lncRNAs/Project1/references
GENOME=/data/users/dbassi/rnaseq_course/reference_genome
THREADS=$SLURM_CPUS_PER_TASK 

# load the module for alignment
module add UHTS/Aligner/hisat/2.2.1

# creates the mappain and reference_genome folder if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/logFiles/mapping
mkdir -p /data/users/dbassi/rnaseq_course/reference_genome
# enter the reads folder
cd $REFERENCE

# index the genome
hisat2-build -p $THREADS $REFERENCE/GRCh38.genome.fa $GENOME/GRCh38






