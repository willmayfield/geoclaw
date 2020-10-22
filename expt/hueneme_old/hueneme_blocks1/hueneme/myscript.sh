for i in {0..6..1}
 do
    for j in {0..6..1}
     do

     echo "################## Processing GF_( $i , $j ) ###################"
     make clean
     
     export gf_i=$i
     export gf_j=$j
     export gf_dim=7
     make all   
    
    done

 done       

