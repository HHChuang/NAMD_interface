#!/bin/bash
#############################################################
# 2017/11/24, Grace											#
# $1 = pes.txt												#
# $2 = basis												#
# $3 = option of modes (integer)							#
#															#
#       4 modes                                             #
#           1. Separate                                     #
#           2. read smaller basis                           #
#           3. read one minimum                             #
#           4. read one-by-one (forware/reverse)            #
# $4 = min.txt												#
#############################################################

# Parameters setting
natom=25 # PhO/PhOH
nline=$(wc -l $1 | awk '{print $1}')
nfile=$(($nline/($natom+2)))

function struc(){
# $1 = pes.txt
# $2 = order of the target structure
# output
#	1. struc.tmp
#	2. coord.tmp
sed -n "$((1+($natom+2)*($2-1))),$((($natom+2)*$2)) p" $1 \
	| tail -n $natom > struc.tmp
sed -n "$((1+($natom+2)*($2-1))),$((($natom+2)*$2)) p" $1 \
	| head -n 2 | tail -n 1 > coord.tmp
}

function comment(){
# $1 = name of job
# $2 = coord.tmp
coord=$(cat $2)
cat << EOF >> $1
\$comment
coordinate is $coord
\$end
EOF
}

function header(){
# $1 = name of job
cat << EOF >> $1 
\$molecule
0 4
EOF
}

function header_read(){
# $1 = name of job
cat << EOF >> $1
\$molecule
	read
\$end
EOF
}

function ref_rem(){
# $1 = name of job
# $2 = basis
cat << EOF >> $1
\$rem
Jobtype             SP
Method              MPW1K
Basis               $2
Max_SCF_cycles      150
SCF_Algorithm       GDM
SCF_Convergence     3
Unrestricted        True
\$end
EOF
}

function sf_rem(){
# $1 = name of job
# $2 = basis
cat << EOF >> $1
\$rem
Jobtype             SP
Method              MPW1K
Basis               $2
Max_SCF_cycles      150
SCF_Algorithm       GDM
SCF_Convergence     8
SCF_Guess           read
SCF_Guess_Mix       3
Unrestricted        True

Spin_flip           True
CIS_N_roots         5
STS_FCD             True
STS_Donor           2-13
STS_Acceptor        14-25
STS_MOM             True
Mem_total           14000
Mem_static          2000
\$end
EOF
}

# main program
case $3 in 
"1")# Separate
#	for ((i=1;i<=1;i++))
	for ((i=1;i<=nfile;i++))
	do		
		struc $1 $i
		name=$(cat coord.tmp)
		rm -f $name.inp
		header $name.inp
		cat struc.tmp >> `echo $name.inp`
		echo '$end' >> `echo $name.inp`
		ref_rem $name.inp $2
		echo '@@@' >> `echo $name.inp`
		comment $name.inp coord.tmp
		header_read $name.inp
		sf_rem $name.inp $2
		qcsub -v mydc $name.inp $name.out
	done
;;
"2")# Read smaller basis
	for ((i=1;i<=nfile;i++))
	do
		struc $1 $i
        name=$(cat coord.tmp)
        rm -f $name.inp
        header $name.inp
        cat struc.tmp >> `echo $name.inp`
        echo '$end' >> `echo $name.inp`
        ref_rem $name.inp 6-31G
        echo '@@@' >> `echo $name.inp`
		comment $name.inp coord.tmp
        header_read $name.inp
        sf_rem $name.inp $2	
		qcsub -v mydc $name.inp $name.out
	done
;;
"3")# Read one minimum
	for ((i=1;i<=nfile;i++))
	do
		struc $1 $i
        name=$(cat coord.tmp)
        rm -f $name.inp
        header $name.inp
		cat $4 >> `echo $name.inp`
        echo '$end' >> `echo $name.inp`
        ref_rem $name.inp $2
        echo '@@@' >> `echo $name.inp`
		comment $name.inp coord.tmp
        header $name.inp
		cat struc.tmp >> `echo $name.inp`
		echo '$end' >> `echo $name.inp`
        sf_rem $name.inp $2
		qcsub -v mydc $name.inp $name.out
	done
;;
"4")# Read one-by-one (forward/reverse)
	name=$(echo "read-1-to-$nfile")
	rm -f $name.inp
	for ((i=1;i<=$nfile;i++))
	do
		struc $1 $i
		if [ "$i" == 1 ]
		then
			header $name.inp
			cat struc.tmp >> `echo $name.inp`
			echo '$end' >> `echo $name.inp`
			ref_rem $name.inp $2
			echo '@@@' >> `echo $name.inp`
			comment $name.inp coord.tmp
			header_read $name.inp 	
			sf_rem $name.inp $2
		else
			echo '@@@' >> `echo $name.inp`
			comment $name.inp coord.tmp
			header $name.inp
			cat struc.tmp >> `echo $name.inp`
			echo '$end' >> `echo $name.inp`
			sf_rem $name.inp $2
		fi
	done	
	qcsub -v mydc $name.inp $name.out

	name=$(echo "read-$nfile-to-1")	
	rm -f $name.inp
    for ((i=$nfile;i>=1;i=i-1))
    do
        struc $1 $i
        if [ "$i" == $nfile ]
        then
            header $name.inp
            cat struc.tmp >> `echo $name.inp`
            echo '$end' >> `echo $name.inp`
            ref_rem $name.inp $2
			echo '@@@' >> `echo $name.inp`
			comment $name.inp coord.tmp
			header_read $name.inp
			sf_rem $name.inp $2
        else
            echo '@@@' >> `echo $name.inp`
			comment $name.inp coord.tmp
            header $name.inp
            cat struc.tmp >> `echo $name.inp`
            echo '$end' >> `echo $name.inp`
            sf_rem $name.inp $2
        fi
    done
	qcsub -v mydc $name.inp $name.out
;;
esac	

rm -f *.tmp
