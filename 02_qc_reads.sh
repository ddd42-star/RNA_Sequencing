#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/02_qc_reads_%j.o

QC=/data/users/dbassi/rnaseq_course/logFiles/quality_control

# load fastqc module
module add UHTS/Quality_control/fastqc/0.11.9

#create a directory for fastqc in logFiles
mkdir -p /data/users/dbassi/rnaseq_course/logFiles/quality_control

#go in the new directy
cd /data/users/dbassi/rnaseq_course/reads

# I will use 2 threads to run 2 files simultaneously
for k in *.fastq;
do fastqc -t 2 -o $QC ${k};
done

