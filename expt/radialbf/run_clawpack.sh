#!/bin/bash
#$ -N claw
#$ -S /bin/sh
#$ -cwd
#$ -o outclaw.log
#$ -e errclaw.log
#$ -pe orte 4

####################################################
# Note: run 'make clean' before doing this.        #
####################################################



module load default-environment
module load python/anaconda3-5.0.0.1

export FFLAGS='-O2 -fopenmp'
export OMP_NUM_THREADS=4
export CLAW=/home/math/mayfielw/CLAW/clawpack_src/clawpack-v5.7.0


make all
