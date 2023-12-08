#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/10_gtfToBed_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
GTF=/data/users/dbassi/rnaseq_course/transcriptome_assembly
BED=/data/users/dbassi/rnaseq_course/bed


#create a directory if it doesn't exist yet
mkdir -p /data/users/dbassi/rnaseq_course/bed


module add UHTS/Analysis/bedops/2.4.40
# select only transcript
awk '$3=="transcript" {print}' $GTF/all_merge.gtf > $GTF/transcript_all_merge.gtf
# transfrom gtf file in bed file
awk '{if($11=="transcript_id") print $1,$4,$5,$12,$6,$7; else print $1,$4,$5,$12,$6,$7}' $GTF/transcript_all_merge.gtf | sed 's/;//g' | sed 's/"//g' | tr ' ' '\t' > $BED/transformedBed.bed

# or just use convert2bed, it's doing the same task (checked!)
#convert2bed -i gtf < $GTF/transcript_all_merge.gtf > $BED/all_merge.bed

# grep annotated
awk 'match($4,!/MSTR/) {print} ' $BED/transformedBed.bed > $BED/transformAnnotated.bed
#awk '!/MSTR/ {print} ' $BED/transformedBed.bed > transformedNovel.bed
#grep -v -e 'MSTR' transformedBed.bed > transformedNovel.bed  
#grep novel
awk 'match($4,/MSTR/) {print} ' $BED/transformedBed.bed > $BED/transformedNovel.bed 
#awk '/MSTR/ {print} ' $BED/transformedBed.bed > transformedNovel.bed  
#grep 'MSTR' transformedBed.bed > transformedNovel.bed 