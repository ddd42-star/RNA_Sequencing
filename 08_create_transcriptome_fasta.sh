#!/usr/bin/env bash


#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/08_expression_%j.o
#SBATCH --partition=pall



THREADS=$SLURM_CPUS_PER_TASK
GENOME=/data/courses/rnaseq_course/lncRNAs/Project1/references
ANNOTATION=/data/users/dbassi/rnaseq_course/transcriptome_assembly
EXPRESSION=/data/users/dbassi/rnaseq_course/expression
FASTQ=/data/users/dbassi/rnaseq_course/reads


#create a directory if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/expression


#load module kallisto
module add UHTS/Analysis/kallisto/0.46.0
#load module gffreads
module add UHTS/Assembler/cufflinks/2.2.1

#creating a transcriptome fasta file
gffread -w $EXPRESSION/all_transcriptome.fa -g $GENOME/GRCh38.genome.fa $ANNOTATION/all_merge.gtf


