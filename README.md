# NAMD_interface
**Table of Content**
- [NAMD\_interface](#namd_interface)
  - [Brief summary](#brief-summary)
  - [Illustration of source codes](#illustration-of-source-codes)
    - [List of source codes](#list-of-source-codes)
    - [Input data procession](#input-data-procession)
    - [On-the-fly dynamic propagation](#on-the-fly-dynamic-propagation)
    - [Output data procession](#output-data-procession)
  - [Example of propagating trajectory](#example-of-propagating-trajectory)
    - [Single trajectory](#single-trajectory)
      - [Set input and submit jobs on HPC](#set-input-and-submit-jobs-on-hpc)
      - [Analyse output files](#analyse-output-files)
    - [Multiple trajectories](#multiple-trajectories)
      - [Set input and submit jobs on HPC](#set-input-and-submit-jobs-on-hpc-1)
      - [Analyse output files](#analyse-output-files-1)
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
  3. Output data procession:  `check1traj`, `macro_chk`,`ana1traj`, `macro_ana`, `plotStates.gnu`
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
    1. `check1traj`: Transform raw data to useful information for one trajectory. 
    2. `macro_chk`: Call `check1traj` to transform raw data to useful information for all trajectories. 
    3. `ana1traj`: For one trajectory, calculate bonds length from the output of the previous step.
    4. `macro_ana`: Call `ana1traj` to analyse all trajectories. 
    5. `plotStates.gnu`: Use gnuplot to plot potential energy curves, population of each electronic state, and non-adiabatic coupling for any two states. 
---
## Example of propagating trajectory 

### Single trajectory 

- PATH: /run/CH4 
#### Set input and submit jobs on HPC
1. Check geometry after sampling.
     - Transform the unit of molecular coordinate from Bohr to angstrom.
        - input: g_1.dima, atomlist.dat 
        - output: g_1.xyz 
        ```
          $ dima2xyz g_1.dima atomlist.dat 
        ```
     - Visualize molecular structure. 
       - [Download Jmol](https://jmol.sourceforge.net/download/) via this link if you need.
       - input: g_1.xyz
       - output: stdout 
        ```
        $ jmol g_1.xyz 
        ```
        [<img src="/aux/CH4.png" width="250"/>](/aux/CH4.png)

2. Check nuclear and electronic setting.
    -  File: setting.dat  
    -  Especially check the number of atom and number of state for different molecule.
  
3. Run dynamics on HPC.
    - Input for `runNAMD_slave`
        1. File with molecular coordinate and momentum (g_1.iniPM).
        2. File with nuclear and electronic setting (setting.dat). 
    ```
    $ qsub runNAMD_slave g_1.iniPM setting.dat 
    ```

#### Analyse output files

### Multiple trajectories

- PATH: /run/C3H2F4 

#### Set input and submit jobs on HPC

1. Check geometry after sampling. In this example, it has five molecular structures. 
   - Transform the unit of molecular coordinate from Bohr to angstrom.
        - input: c3h2f4.dima, atomlist.dat 
        - output: c3h2f4.xyz 
        ```
            $ dima2xyz c3h2f4.dima atomlist.dat 
        ```

    - Visualize molecular structure. 
      - input: c3h2f4.xyz 
      - output: stdout
       ```
       $ jmol c3h2f4.xyz 
       ```
       [<img src="https://user-images.githubusercontent.com/23027121/207396553-20de17e4-2ad3-45f7-839f-fd4ac715483c.mov" width="50%"/>](https://user-images.githubusercontent.com/23027121/207396553-20de17e4-2ad3-45f7-839f-fd4ac715483c.mov)
    
2. Generate the file with both molecular coordinate and momentum (c3h2f4.iniPM) by the sampling file (c3h2f4.dima). 
    - input: c3h2f4.dima, atomlist.dat 
    - output: c3h2f4_*.iniPM
    ```
    $ dima2iniPM c3h2f4.dima atomlist.dat 
    ```

3. Check the nuclear and electronic setting.
    -  File: setting.dat  
    -  Now, the number of atom is 9, and the number of state is 5 in this case.

4. Use a loop to prepare necessary files. 
    - Create sub-directory for each trajectory. The psudo-code is 
        ```
        $ mkdir traj_$(directory index)
        ```
    - And then put all the *.iniPM into these subdirectories separately. The psudo-code is 
        ```
        $ mv $(some name).iniPM traj_$(directory index)
        ```
    - Also, create the list for recording the sub-directory index. The psudo-code is 
        ```
        $ echo $(subdirectory index) >> list.dat
        ```
    - Combine above three steps, the real script for the testing 5 subdirectories is 
        ```
        $ for ((i=1;i<=5;i++))
            do 
                mkdir traj_$i
                mv g_$i.iniPM traj_$i 
                echo $i >> list.dat 
            done 
        ```

5. Run dynamics on HPC. 
    ```
    $ macro_runNAMD list.dat setting.dat 
    ```


#### Analyse output files
