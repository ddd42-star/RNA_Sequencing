#!/usr/bin/env bash

#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/11_bedtoolsIntersect_%j.o
#SBATCH --partition=pall

BED=/data/users/dbassi/rnaseq_course/bed

#module add bedtools
module add UHTS/Analysis/BEDTools/2.29.2

#Find intergenic intersect for novel transcript using novel transcript vs using annoted transcript
bedtools intersect -v -wa -a $BED/transformedNovel.bed -b $BED/transformAnnotated.bed > $BED/novelIntergenic.bed





