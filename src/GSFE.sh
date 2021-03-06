#!/bin/bash
#------------------------------------------------------------------------------------------
# |||--> b means burger vector
# |||--> b = a*1/2[111] ;|b| = a*sqrt(3)/2
# |||--> On the (110) plane the slip occur at <1-11> (For bcc structure)
# |||--> For gamma surface vary b from 0b to 1b
# Some bcc materials (e.g. α-Fe) can contain up to 48 slip systems. 
# There are six slip planes of type {110}, each with two <111> directions (12 systems). 
# There are 24 {123} and 12 {112} planes each with one <111> direction (36 systems, 
# for a total of 48). While the {123} and {112} planes are not exactly identical in 
# activation energy to {110}, they are so close in energy that for all intents and 
# purposes they can be treated as identical. example: 
# slip plane and direction are (110) and [-111], respectively
# https://www.sciencedirect.com/science/article/pii/S1359645417303671
# https://journals-aps-org.gaelnomade-2.grenet.fr/prb/pdf/10.1103/PhysRevB.62.3099
#------------------------------------------------------------------------------------------
count=00;
ax=9.18033; 	# Lattice parameter change according to your situation
touch burger.dat
if [ "$1" == "POSCAR110.cif" ]; then
  echo "-vasp"
else
  echo "COnvert POSCAR to .cif file. Convert with VESTA software"
  exit	
fi 
	
b=$(echo "scale=6; $ax*(sqrt(3.0)/2)" | bc -l); # Definition of a burger vector
echo "burger vectors b:: " $b "and lattice vector l:: " $ax

# change this value for # of displacement for burger vector
for i in `seq -w 0.0 0.05 1.0`
do
j=$(echo "$b*$i" | bc -l);

echo "i=$i::#=$count::"    $j  
echo $j >> burger.dat
atomsk $1 -shift above 0.25*box Z 0 $j 0 -wrap -fix X -fix Y POSCAR
mv POSCAR POSCAR_$count

#count=$(echo "$count+1" | bc -l);
count=`echo $count | awk '{printf "%02d", $1+1 }'`
done

#atomsk POSCAR110.cif -shift above 0.5*box Z 2.8  0.0 0.0 -wrap  POSCAR2.8.cif

