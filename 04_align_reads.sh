#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/04_align_reads32_%j.o
#SBATCH --partition=pall

READS=/data/users/dbassi/rnaseq_course/reads
GENOME=/data/users/dbassi/rnaseq_course/reference_genome
THREADS=$SLURM_CPUS_PER_TASK
INDEX=/data/users/dbassi/rnaseq_course/reference_genome
MAP=/data/users/dbassi/rnaseq_course/mapped_reads2 

# load the module for alignment
module add UHTS/Aligner/hisat/2.2.1

# creates the mappgin folder if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/logFiles/mapping
mkdir -p /data/users/dbassi/rnaseq_course/mapped_reads2
# enter the reads folder
cd $READS

# align RNA reads to the genome
# call the name of the file of the reads found here /data/users/dbassi/rnaseq_course/reads
# -p performing with threads, -x index genome, -1 and -2 pair reads (forward and reverse), -S sam output file
hisat2 -p $THREADS --rna-strandness RF -x $INDEX/GRCh38 -1 $READS/P3_L3_R1_001_fjv6hlbFgCST.fastq -2 $READS/P3_L3_R2_001_xo7RBLLYYqeu.fastq -S $MAP/P3_L3.sam
