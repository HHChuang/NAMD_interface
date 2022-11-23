#!/usr/local/bin/gnuplot -c
# 
# 2022/11/23, Grace, H.G.Chuang@leeds.ac.uk
# 

outputFile='../../aux/'.ARG1.'.png'
inputFile=ARG1.'.dat'
print outputFile

set terminal png 
set output outputFile 
set lmargin 25 
set bmargin 8
set key top opaque font ',10'
set title ' SF-BH\&HLYP/6-31+G*' font ',20'
set tics font ',15'

# set ylabel 'Potential energy curves (Hartree)' font ',20' offset -3,0
# set ylabel 'Population' font ',20' offset -3,0
set ylabel 'Non-adiabatic coupling' font ',20' offset -3,0

set xlabel 'Time (fs)' font ',20' offset 0,-1

plot    inputFile using 1:2 with linespoints title 'S0', \
        inputFile using 1:3 with linespoints title 'S1', \
        inputFile using 1:4 with linespoints title 'S2', \
        inputFile using 1:5 with linespoints title 'S3', \
        inputFile using 1:6 with linespoints title 'S4', \
        inputFile using 1:7 with linespoints title 'S5', \
        inputFile using 1:8 with linespoints title 'S6'

