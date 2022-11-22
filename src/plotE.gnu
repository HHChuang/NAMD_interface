#!/usr/local/bin/gnuplot --persist
outputFile='../aux/E_'.ARG1.'.png'
inputFile='E_'.ARG1.'.dat'

set terminal png 
set output outputFile 
set title 'traj'.ARG1.' SF-BH\&HLYP/6-31+G*' font ',20'
set ylabel 'Hartree' font ',20'
set xlabel 'Time (fs)' font ',20'

plot    inputFile using 1:2 with linespoints title 'E0', \
        inputFile using 1:3 with linespoints title 'E1', \
        inputFile using 1:4 with linespoints title 'E2', \
        inputFile using 1:5 with linespoints title 'E3', \
        inputFile using 1:6 with linespoints title 'E4'

