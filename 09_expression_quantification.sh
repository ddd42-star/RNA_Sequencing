#!/usr/bin/env bash


#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/0932_expression_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
GENOME=/data/courses/rnaseq_course/lncRNAs/Project1/references
ANNOTATION=/data/users/dbassi/rnaseq_course/transcriptome_assembly
EXPRESSION=/data/users/dbassi/rnaseq_course/expression
ALLANNOTATION=/data/users/dbassi/rnaseq_course/expression/P3
FASTQ=/data/users/dbassi/rnaseq_course/reads


#create a directory if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/expression
mkdir -p /data/users/dbassi/rnaseq_course/expression/P3


#load module kallisto
module add UHTS/Analysis/kallisto/0.46.0





#Build a kallisto index
kallisto index -i $EXPRESSION/all_kallisto_index $EXPRESSION/all_transcriptome.fa


#quantification algorithm
kallisto quant -i $EXPRESSION/all_kallisto_index -o $ALLANNOTATION -b 40 --rf-stranded --threads $THREADS $FASTQ/P3_L3_R1_001_fjv6hlbFgCST.fastq $FASTQ/P3_L3_R2_001_xo7RBLLYYqeu.fastq