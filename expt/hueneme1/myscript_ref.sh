#!/bin/bash

set -x

module load default-environment
module load python/anaconda3-5.0.0.1
module load matlab

for i in {1..1..1}
 do


     echo "################## Processing ENS_( $i ) ###################"
     make clean
     
     export ens_num=$i
     export gf_dim=6
     make ref 


 done       

