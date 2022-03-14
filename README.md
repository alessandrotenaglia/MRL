# Machine and Reinforcement Learning in Control Applications

Teaching material for the course "Machine and Reinforcement Learning in Control Applications"

University of Rome "Tor Vergata", academic year 2021/2022

## Authors

- Corrado Possieri, corrado.possieri@uniroma2.it
- Alessandro Tenaglia, alessandro.tenaglia@uniroma2.it

## Repository structure

- `MultiArmBandit/` contains the code to resolve the **multi-armed bandit** problem;
  - `Bandit.m` is a class that implements a bandit in different scenarios;
  - `Policy.m` is an abstract class that defines a template
  - `EpsGreedy/` contains the code of **$\eps$-greedy policy**
    - `EpsGreedy.m`
    - `eg_run.m`
    - `eg_main.m`
  - `UpConfBound/`
    - `UpConfBound.m`
    - `ucb_run.m`
    - `ucb_main.m`
  - `PrefUp/`
    - `PrefUp.m`
    - `pref_run.m`
    - `pref_main.m`
- `DynamicProgramming/` contains the code to resolve **dynamic programming** problems;
  - `PolicyIter.m`
  - `ValueIter.m`
- `MyGridWorld/` contains a custom implementation of a **grid world**;
  - `MyGridWorld.m`
  - `mygw_mdp.m`
  - `mygw_dp.m`
- `JacksCarRental/` contains the code to resolve the **Jack's car rental** problem;
  - `JCR.m`
  - `jcr.mdp.m`
  - `jcr_dp.m`
