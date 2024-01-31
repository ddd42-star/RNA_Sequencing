#!/usr/bin/env bash



BED=/data/users/dbassi/rnaseq_course/bed
# count intergenic novel transcript
total_novel=$(wc -l $BED/transformedNovel.bed | awk '{print $1}')
novel_intergenic=$(wc -l $BED/novelIntergenic.bed | awk '{print $1}')

# count 5' overlaps
total=$(wc -l $BED/transformedBed.bed | awk '{print $1}')
total_five=$(wc -l $BED/overlap5primeA.bed | awk '{print $1}')

# count 3' prime overlaps
total_three=$(wc -l $BED/overlap3primeA.bed | awk '{print $1}')


percentage_intergenic=$(echo "scale=2; ($novel_intergenic / $total_novel) * 100" | bc)
percentage_five_overlaps=$(echo "scale=2; ($total_five / $total) * 100" | bc)
percentage_three_overlaps=$(echo "scale=2; ($total_three / $total) * 100" | bc)


echo "Total of novel transcripts $total_novel"
echo "Total of novel transcript intergenic $novel_intergenic"
echo "Percentage of novel transcript intergenic $percentage_intergenic%"
echo "Percentage 5 prime overlaps $percentage_five_overlaps%"
echo "Percentage 3 prime overlaps $percentage_three_overlaps%"
