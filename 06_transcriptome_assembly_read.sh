#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/dbassi/rnaseq_course/logFiles/06_annoP3P_%j.o
#SBATCH --partition=pall

THREADS=$SLURM_CPUS_PER_TASK
BAM=/data/users/dbassi/rnaseq_course/mapped_reads2
ASSEMBLY=/data/users/dbassi/rnaseq_course/transcriptome_assembly/PRI
MAP=/data/users/dbassi/rnaseq_course/mapped_reads2
REFERENCE=/data/users/dbassi/rnaseq_course/reference_genome 

mkdir -p /data/users/dbassi/rnaseq_course/transcriptome_assembly
mkdir -p /data/users/dbassi/rnaseq_course/transcriptome_assembly/PRI


# load StringTie module
module add UHTS/Aligner/stringtie/1.3.3b

# call each file that you wants to transform from here /data/users/dbassi/rnaseq_course/mapped_reads2  

# reference-guided transcriptome assembly
# -p is the number of threads, --rf is the library stradness, -G is the reference Guide annotation
stringtie -o $ASSEMBLY/P3_L3.gtf -p $THREADS --rf -G $REFERENCE/gencode.v44.primary_assembly.annotation.gtf $MAP/P3_L3.bam








