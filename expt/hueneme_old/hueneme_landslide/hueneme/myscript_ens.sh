for i in {11..100..1}
 do


     echo "################## Processing ENS_( $i ) ###################"
     make clean
     
     export ens_num=$i
     export gf_dim=6
     make all   


 done       

