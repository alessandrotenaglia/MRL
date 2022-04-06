# Machine and Reinforcement Learning in Control Applications

Teaching material for the course "Machine and Reinforcement Learning in Control Applications"

University of Rome "Tor Vergata", academic year 2021/2022

## Authors

- Corrado Possieri, corrado.possieri@uniroma2.it
- Alessandro Tenaglia, alessandro.tenaglia@uniroma2.it

## Repository Structure

- `MultiArmBandit/` contains the code to resolve the **multi-armed bandit** problem;
  - `Bandit.m` is a class that implements a bandit in different scenarios;
  - `Policy.m` is an abstract class that defines a template for a sample-average policy;
  - `EpsGreedy/` contains the code of **&epsilon;-greedy policy**;
    - `EpsGreedy.m` is a class that implements the **&epsilon;-greedy policy**;
    - `eps_run.m` is a script that shows the behavior of the **&epsilon;-greedy policy**;
    - `eps_main.m` is a script that compares the **&epsilon;-greedy policy** in different scenarios;
  - `UpConfBound/` contains the code of **upper confidence bound policy**;
    - `UpConfBound.m` is a class that implements the **upper confidence bound policy**;
    - `ucb_run.m` is a script that shows the behavior of the **upper confidence bound policy**;
    - `ucb_main.m` is a script that compares the **upper confidence bound policy** in different scenarios;
  - `PrefUp/` contains the code of **preference updates policy**;
    - `PrefUp.m` is a class that implements the **preference updates policy**;
    - `pref_run.m` is a script that shows the behavior of the **preference updates policy**;
    - `pref_main.m` is a script that compares the **preference updates policy** in different scenarios;
- `DynamicProgramming/` contains the code to resolve **dynamic programming** problems;
  - `PolicyIter.m` is a class that implements the **policy iteration** algorithm;
  - `ValueIter.m` is a class that implements the **value iteration** algorithm;
- `MyGridWorld/` contains a custom implementation of a **grid world**;
  - `MyGridWorld.m` is a class that implements a **grid world** environment;
  - `mygw_mdp.m` is a script that reforms the shortest path problem on a **grid world** as a **MDP**;
  - `mygw_dp.m` is a class that resolves the shortest path problem on a **grid world** using the **dynamic programming**;
- `JacksCarRental/` contains the code to resolve the **Jack's car rental** problem;
  - `JCR.m` is a class that implements the **Jack's car rental** problem;
  - `jcr_mdp.m` is a script that reforms the **Jack's car rental** problem as a **MDP**;
  - `jcr_dp.m` is a class that resolves the **Jack's car rental** problem using the **dynamic programming**;
- `MonteCarlo/`
