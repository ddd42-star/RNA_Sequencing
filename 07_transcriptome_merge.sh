#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/07_mergeP_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
ASSEMBLY=/data/users/dbassi/rnaseq_course/transcriptome_assembly/PRI
MERGE=/data/users/dbassi/rnaseq_course/transcriptome_assembly
REFERENCE=/data/users/dbassi/rnaseq_course/reference_genome



# load StringTie module
module add UHTS/Aligner/stringtie/1.3.3b

# reference-guided transcriptome assembly
# -p is the number of threads, --rf is the library stradness, -G is the reference Guide annotation
stringtie --merge -o $MERGE/pri_merge.gtf -p $THREADS --rf -G $REFERENCE/gencode.v44.primary_assembly.annotation.gtf $ASSEMBLY/*