#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=100
#SBATCH --partition=pall
#SBATCH --time=01:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/01_count_reads_%j.o

# go in reads directory
cd /data/users/dbassi/rnaseq_course/reads

# count reads of differents files and print it in the console
for k in *.fastq;
do awk '{s++}END{print FILENAME " has " s/4 " reads."}' ${k};
done



