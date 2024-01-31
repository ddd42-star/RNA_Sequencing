
# count transcripts
awk '$2 !=0 || $3!=0 || $4!=0 || $5!=0 || $6!=0 || $7!=0 {print }' count_transcript.txt | wc -l 



# count novel transcripts
awk '$2 !=0 || $3!=0 || $4!=0 || $5!=0 || $6!=0 || $7!=0 {print }' count_transcript.txt | awk 'match($1,/MSTR/) {print}' | wc -l

# count genes
awk '$3!=0 || $4!=0 || $5!=0 || $6!=0 || $7!=0 || $8!=0 {print }' counts_per_genes.txt | wc -l

# count novel genes
wk '$3!=0 || $4!=0 || $5!=0 || $6!=0 || $7!=0 || $8!=0 {print }' counts_per_genes.txt | awk 'match($2,/MSTR/) {print}' | wc -l