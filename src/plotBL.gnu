#!/usr/local/bin/gnuplot --persist
outputFile='../aux/Bonds_'.ARG1.'.png'
inputFile='Bonds_'.ARG1.'.ang'

set terminal png 
set output outputFile
set title 'traj'.ARG1.' SF-BH\&HLYP/6-31+G*' font ',20'
set ylabel 'Angstrom' font ',20'
set xlabel 'Time (fs)' font ',20'
set yrange [0:6]

plot    inputFile u 1:2 w line lw 3 title 'C1H2', \
        inputFile u 1:3 w line lw 3 title 'C1H3', \
        inputFile u 1:4 w line lw 3 title 'C1H4', \
        inputFile u 1:5 w line lw 3 title 'C1H5', \
        inputFile u 1:6 w line title 'H2H3', \
        inputFile u 1:7 w line title 'H2H4', \
        inputFile u 1:8 w line title 'H2H5', \
        inputFile u 1:9 w line title 'H3H4', \
        inputFile u 1:10 w line title 'H3H5', \
        inputFile u 1:11 w line title 'H4H5'

