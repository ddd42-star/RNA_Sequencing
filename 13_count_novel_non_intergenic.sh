#!/usr/bin/env bash

#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/13_novelIntergenic_%j.o

BED=/data/users/dbassi/rnaseq_course/bed
#3 prime new
awk '{print $4}' $BED/overlap3prime.bed | grep 'MSTR' | uniq | wc -l
#5 prime new
awk '{print $4}' $BED/overlap5prime.bed | grep 'MSTR' | uniq | wc -l

awk '{print $4}' $BED/overlap3prime.bed | grep 'MSTR' | uniq > $BED/novel3intergenic.txt
awk '{print $4}' $BED/overlap5prime.bed | grep 'MSTR' | uniq > $BED/novel5intergenic.txt


