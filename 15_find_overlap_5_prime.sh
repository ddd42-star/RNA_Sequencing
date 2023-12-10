#!/usr/bin/env bash

#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/15_overlap5prime_%j.o
#SBATCH --partition=pall

BED=/data/users/dbassi/rnaseq_course/bed

#module add bedtools
module add UHTS/Analysis/BEDTools/2.29.2

#add a window of 50 nucletides to start for (+)strand and to the end for (-)strand
awk '{if($6=="+") print $1,($2-50),($2+50),$4,$5,$6; else print $1,($3-50),($3+50),$4,$5,$6}' $BED/transformedBed.bed  | tr ' ' '\t' > $BED/window5prime.bed
# if there are coordinate that are negative just put it to 0
awk '{if($3<0 || $2<0) print $1,0,0,$4,$5,$6; else print $1,$2,$3,$4,$5,$6}' $BED/window5prime.bed  | tr ' ' '\t' > $BED/window5prime2.bed

# Bedtools intersect for 5' ends forward strands(+)
bedtools intersect -wa -s -a $BED/window5prime2.bed -b $BED/refTSS_v4.1_human_coordinate.hg38.bed > $BED/overlap5primeA.bed
# Bedtools intersect for 5' ends reverse strands(-)
bedtools intersect -wa -wb -s -a $BED/window5prime2.bed -b $BED/refTSS_v4.1_human_coordinate.hg38.bed > $BED/overlap5primeBoth.bed