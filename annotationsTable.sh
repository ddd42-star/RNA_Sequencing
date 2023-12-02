#!/usr/bin/env bash

ALLMERGE=/data/users/dbassi/rnaseq_course/transcriptome_assembly
GUIDE=/data/users/dbassi/rnaseq_course/reference_genome
EXPRESSION=/data/users/dbassi/rnaseq_course/expression


awk '$3=="transcript" {if($15=="ref_gene_id") print $12,$16,$14; else print $12,$10,$14;}' $ALLMERGE/all_merge.gtf | sort > $EXPRESSION/allMergeAnnotation.txt

# biotype and transcript id
awk ' $3=="transcript"  {print $12,$14,$18}' $GUIDE/gencode.v44.chr_patch_hapl_scaff.annotation.gtf | sort > $EXPRESSION/bioType.txt

#joint the two tables
join -t ';' -a 1 -a 2 -1 1 -2 1 $EXPRESSION/allMergeAnnotation.txt $EXPRESSION/bioType.txt | sed 's/;;/;/g' > $EXPRESSION/annotable.txt


