# NAMD_interface

- Interface of running nonadiabatic molecular dynamics (NAMD) between QChem and homemade nuclear dynamic program (Dr. Dmitry Makhov).
- Molecular visualizer: [Jmol](https://jmol.sourceforge.net)

## Brief illustration of source code
1. Input data procession:  `dima2xyz`, `dima2inifile`
2. On-the-fly dynamic propagation:  `runNAMD_head`, `runNAMD_slave`, `macro_runNAMD`, `checkRunningDir`
3. Output data procession:  `check1traj`, `anaOneProd`, `macro_ana`, `plotStates.gnu`
### Input data procession 

### On-the-fly dynamic propagation


#### Select computational platform
1. `runNAMD_head`: propagate trajectories on the head node; it is written for testing purpose. 
2. `runNAMD_slave`: propagate trajectories on HPC; using slave nodes with SGE scheduler system.

### Output data procession 
