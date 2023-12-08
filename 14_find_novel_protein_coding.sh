#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/14_bedtoolsIntersect_%j.o
#SBATCH --partition=pall

GENOME=/data/courses/rnaseq_course/lncRNAs/Project1/references
BED=/data/users/dbassi/rnaseq_course/bed

module add SequenceAnalysis/GenePrediction/cpat/1.2.4
module add UHTS/Analysis/BEDTools/2.29.2


 
bedtools getfasta -fi $GENOME/GRCh38.genome.fa -bed $BED/transformedBed.bed -fo $BED/novelProteinSeq.fa

cpat.py -x $BED/Human_Hexamer.tsv -d Human_logitModel.RData -g $BED/novelProteinSeq.fa -o $BED/novelProtein