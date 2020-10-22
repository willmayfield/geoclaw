for i in {1..100..1}
 do

     echo "################## Processing GF_( $i ) ###################"
     make clean
     
     export gf_i=$i
     export gf_dim=6
     make all   
    

 done       

