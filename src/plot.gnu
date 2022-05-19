set terminal png 
set output 'E.png'
set title 'SF-BH\&HLYP/6-31+G*' font ',20'
set ylabel 'Hartree' font ',20'


plot 'E.dat' using 1:2 with linespoints title 'E0', \
    'E.dat' using 1:3 with linespoints title 'E1', \
    'E.dat' using 1:4 with linespoints title 'E2', \
    'E.dat' using 1:5 with linespoints title 'E3', \
    'E.dat' using 1:6 with linespoints title 'E4', \
    'E.dat' using 1:7 with linespoints title 'E5'

