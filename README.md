# NAMD_interface
**Table of Content**
- [NAMD\_interface](#namd_interface)
  - [Brief summary](#brief-summary)
  - [Illustration of source codes](#illustration-of-source-codes)
    - [List of source codes](#list-of-source-codes)
    - [Input data procession](#input-data-procession)
    - [On-the-fly dynamic propagation](#on-the-fly-dynamic-propagation)
    - [Output data procession](#output-data-procession)
  - [Example of propagating methane trajectory](#example-of-propagating-methane-trajectory)
    - [Single trajectory](#single-trajectory)
    - [Multiple trajectories](#multiple-trajectories)
---
## Brief summary
  > Interface of running nonadiabatic molecular dynamics (NAMD) between QChem and homemade nuclear dynamic program (Dr. Dmitry Makhov).
- Electronic structure theory (EST) program: [Q-Chem](https://www.q-chem.com/about/)
- Nuclear dynamic method: [Chemical Physics 2017, 493, 200-218.](https://www.sciencedirect.com/science/article/pii/S0301010416310357?via%3Dihub)
- Molecular visualizer: [Jmol](https://jmol.sourceforge.net)
- EST and nuclear parts can by changed to other resources. 
---
## Illustration of source codes
### List of source codes
  1. Input data procession:  `dima2xyz`, `dima2inifile`
  2. On-the-fly dynamic propagation: `runNAMD_slave`, `macro_runNAMD`, `checkRunningDir`
  3. Output data procession:  `check1traj`, `anaOneProd`, `macro_ana`, `plotStates.gnu`
### Input data procession 
- Purpose of each source code
    1. `dima2xyz`: Transform Bohr to angstrom in order to check the initial molecular structure via [Jmol](https://jmol.sourceforge.net).
    2. `dima2inifile`: Pre-process initial input file (coordinate and momentum) for each trajectory.
### On-the-fly dynamic propagation
- Purpose of each source code
    1. `runNAMD_slave`: Propagate one trajectory on HPC; [Sun Grid Engine (SGE) scheduler system](http://talby.rcs.manchester.ac.uk/~ri/_linux_and_hpc_lib/sge_intro.html)
    2. `macro_runNAMD`: Call `runNAMD_slave` to propagate many trajectories.
    3. `checkRunningDir`: Check the running status for all trajectories, and standard output the statistic result. 
- Key pseudo-code in `runNAMD_slave`
    1. Calculate the first point of one trajectory
       1.  Extracting position and momentum to form the header of the dynamic file. 
       2.  Calculate non-adiabatic coupling.
       3.  Calculate force in different electronic states. 
       4.  Extract EST information to complete the dynamic file.
       5.  Nuclear preliminary propagation.
       6.  Calculate non-adiabatic coupling.
       7.  Calculate force in different electronic states. 
       8.  Extract EST information to write another dynamic file.
       9.  Final nuclear propagation 
    2. Propagate the rest points depending on the previous point
        - Repeat steps 5 to 9. 
### Output data procession 
- Purpose of each source code
    1. `check1traj`: Transform raw data to useful information
    2. `anaOneProd`: For one trajectory, calculate bonds length from the output of the previous step.
    3. `macro_ana`: Call `anaOneProd` to analyse all trajectories. 
    4. `plotStates.gnu`: Use gnuplot to plot potential energy curves, population of each electronic state, and non-adiabatic coupling for any two states. 
---
## Example of propagating methane trajectory 

### Single trajectory 

### Multiple trajectories
