#!/usr/local/bin/gnuplot -c
# 
# 2022/11/23, Grace, H.G.Chuang@leeds.ac.uk
# 

outputFile='../../aux/'.ARG1.'.png'
inputFile=ARG1.'.dat'
nstate=7
print outputFile

set terminal png 
set output outputFile 
set lmargin 25 
set bmargin 8
set key top opaque font ',10'
set title ' SF-BH\&HLYP/6-31+G*' font ',20'
set tics font ',15'
set xlabel 'Time (fs)' font ',20' offset 0,-1

set ylabel 'Potential energy curves (Hartree)' font ',20' offset -3,0
# set ylabel 'Population' font ',20' offset -3,0

plot for [i=1:nstate] inputFile u 1:i+1 w l lw 3 title 'S'.(i-1)

# Non-adiabatic coupling 
# set yrange [0:120]
# n_nonad=nstate*(nstate-1)/2
# # FIXME: need to relax the condition 
# nonad_title(n)=word('0-1 0-2 0-3 0-4 0-5 0-6 1-2 1-3 1-4 1-5 1-6 2-3 2-4 2-5 2-6 3-4 3-5 3-6 4-5 4-6 5-6',n)
# set ylabel 'Non-adiabatic coupling' font ',20' offset -3,0
# plot for [i=1:n_nonad] inputFile u 1:i+1 w linespoints title ''.nonad_title(i)