# NAMD_interface
- [NAMD\_interface](#namd_interface)
  - [Summary](#summary)
  - [Brief illustration of source code](#brief-illustration-of-source-code)
    - [Input data procession](#input-data-procession)
    - [On-the-fly dynamic propagation](#on-the-fly-dynamic-propagation)
    - [Output data procession](#output-data-procession)
  - [Example of propagating methane trajectory](#example-of-propagating-methane-trajectory)
    - [Single trajectory](#single-trajectory)
    - [Multiple trajectories](#multiple-trajectories)
---
## Summary
- Interface of running nonadiabatic molecular dynamics (NAMD) between QChem and homemade nuclear dynamic program (Dr. Dmitry Makhov).
- Electronic structure program: [Q-Chem](https://www.q-chem.com/about/)
- Nuclear dynamic method: [Chemical Physics 2017, 493, 200-218.](https://www.sciencedirect.com/science/article/pii/S0301010416310357?via%3Dihub)
- Molecular visualizer: [Jmol](https://jmol.sourceforge.net)
---
## Brief illustration of source code
1. Input data procession:  `dima2xyz`, `dima2inifile`
2. On-the-fly dynamic propagation:  `runNAMD_head`, `runNAMD_slave`, `macro_runNAMD`, `checkRunningDir`
3. Output data procession:  `check1traj`, `anaOneProd`, `macro_ana`, `plotStates.gnu`
### Input data procession 

### On-the-fly dynamic propagation

<!-- #### Select computational platform
1. `runNAMD_head`: propagate trajectories on the head node; it is written for testing. 
2. `runNAMD_slave`: propagate trajectories on HPC; [Sun Grid Engine (SGE) scheduler system](http://talby.rcs.manchester.ac.uk/~ri/_linux_and_hpc_lib/sge_intro.html) -->


### Output data procession 

---
## Example of propagating methane trajectory 

### Single trajectory 

### Multiple trajectories
