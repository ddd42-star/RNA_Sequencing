#!/usr/bin/env bash

#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/12_overlapsStats_%j.o

BED=/data/users/dbassi/rnaseq_course/bed

# Count total transcript
total_transcripts3=$(wc -l $BED/atlas.clusters.2.0.GRCh38.96.bed | awk '{print $1}')
total_transcripts5=$(wc -l $BED/refTSS_v4.1_human_coordinate.hg38.bed | awk '{print $1}')
# Count 5'primes overlapping
overlapping_5prime=$(wc -l $BED/overlap5prime.bed | awk '{print $1}')
# Count 3' primes overlapping
overlapping_3prime=$(wc -l $BED/overlap3prime.bed | awk '{print $1}')

# calculate percentage 5'primes
percentage_5prime=$(echo "scale=2; ($overlapping_5prime / $total_transcripts5) * 100" | bc)
#calculate percentage 3'primes
percentage_3prime=$(echo "scale=2; ($overlapping_3prime / $total_transcripts3) * 100" | bc)


echo "Percentage of transcripts with correct 5' end annotations: $percentage_5prime%"
echo "Percentage of transcripts with correct 3' end annotations: $percentage_3prime%" 
