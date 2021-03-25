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

set -x

module load default-environment
module load python/anaconda3-5.0.0.1
module load matlab

export FFLAGS='-O2 -fopenmp'
export OMP_NUM_THREADS=4
export CLAW='/home/math/mayfielw/clawpack_src/clawpack'

./myscript_ens.sh > clawlog.log
