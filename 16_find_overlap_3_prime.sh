#!/usr/bin/env bash

#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/16_bedtoolsIntersect_%j.o
#SBATCH --partition=pall

BED=/data/users/dbassi/rnaseq_course/bed

#module add bedtools
module add UHTS/Analysis/BEDTools/2.29.2

#add a window of 50 nucletides to start for (+)strand and to the end for (-)strand
awk '{if($6=="+") print $1,($3-50),($3+50),$4,$5,$6; else print $1,($2-50),($2+50),$4,$5,$6}' $BED/all_merge.bed  | tr ' ' '\t' > $BED/window3prime.bed
awk '{if($3<0 || $2<0) print $1,0,0,$4,$5,$6; else print $1,$2,$3,$4,$5,$6}' $BED/window3prime.bed  | tr ' ' '\t' > $BED/window3prime2.bed

awk '{print $1,$2,$3,$4,$5,$6}' $BED/atlas.clusters.2.0.GRCh38.96.bed  | tr ' ' '\t' | sed 's/^/chr/' > $BED/polyArefactor.bed
# Bedtools intersect for 3' ends forward strands (+)
bedtools intersect -wa -s -a $BED/window3prime2.bed -b $BED/polyArefactor.bed > $BED/overlap3primeA.bed
# Bedtools intersect for 3' ends reverse strands (-)
bedtools intersect -wa -wb -s -a $BED/window3prime2.bed -b $BED/polyArefactor.bed > $BED/overlap3primeBoth.bed
