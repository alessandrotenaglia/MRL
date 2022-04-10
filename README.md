# Machine and Reinforcement Learning in Control Applications

Teaching material for the course "Machine and Reinforcement Learning in Control Applications"

University of Rome "Tor Vergata", academic year 2021/2022

## Authors

- Corrado Possieri, corrado.possieri@uniroma2.it
- Alessandro Tenaglia, alessandro.tenaglia@uniroma2.it

## Repository Structure

- `DynamicProgramming/Src/` contains the code to implement **Dynamic Programming** algorithms;
  - `PolicyIter.m` is a class that implements the **Policy Iteration** algorithm;
  - `ValueIter.m` is a class that implements the **Value Iteration** algorithm;
- `Formula1/Src` contains the code to solve *F1* problem;
  - `f1_dp.m` is a script that solves the *F1* problem with **Dynamic Programming** algorithms;
  - `f1_main.m` is a script that shows the *F1* track;
  - `f1_mc.m` is a script that solves the *F1* problem with **Monte Carlo** methods;
  - `f1_mdp.m` is a script that defines the *F1* problem as a **MDP**;
  - `f1_track.m` is a script that generates a Grid World from an image of a *F1* track;
- `JacksCarRental/Src` contains the code to solve the *Jack's car rental* problem;
  - `JCR.m` is a class that implements the *Jack's car rental* problem;
  - `jcr_dp.m` is a class that solves the *Jack's car rental* problem with **Dynamic Programming** algorithms;
  - `jcr_mdp.m` is a script that defines the *Jack's car rental* problem as a **MDP**;
- `MonteCarlo/Src` contains the code to implement **Monte Carlo** methods;
  - `MonteCarlo` is a class that implements **Monte Carlo** methods;
- `MultiArmBandit/Src` contains the code to solve the *multi-armed bandit* problem;
  - `Bandit.m` is a class that implements a *multi-armed bandit* in different scenarios;
  - `Policy.m` is an abstract class that defines a template for sample-average policies;
  - `EpsGreedy/` contains the code of **&epsilon;-greedy** policy;
    - `EpsGreedy.m` is a class that implements the **&epsilon;-greedy** policy;
    - `eps_run.m` is a script that shows the behavior of the **&epsilon;-greedy** policy;
    - `eps_main.m` is a script that compares the **&epsilon;-greedy** policy in different scenarios;
  - `UpConfBound/` contains the code of **upper confidence bound policy**;
    - `UpConfBound.m` is a class that implements the **upper confidence bound policy**;
    - `ucb_run.m` is a script that shows the behavior of the **upper confidence bound policy**;
    - `ucb_main.m` is a script that compares the **upper confidence bound policy** in different scenarios;
  - `PrefUp/` contains the code of **preference updates policy**;
    - `PrefUp.m` is a class that implements the **preference updates policy**;
    - `pref_run.m` is a script that shows the behavior of the **preference updates policy**;
    - `pref_main.m` is a script that compares the **preference updates policy** in different scenarios;
- `MyGridWorld/Src` contains a custom implementation of a *Grid World*;
  - `MyGridWorld` is a class that implement the *Grid World*;
  - `mygw_dp.m` is a script that solves the *Grid World* problem with **Dynamic Programming** algorithms;
  - `mygw_main.m` is a script that shows the *Grid World*;
  - `mygw_mc.m` is a script that solves the *Grid World* problem with **Monte Carlo** methods;
  - `mygw_mdp.m` is a script that defines the *Grid World* problem as a **MDP**;
  - `mygw_td.m` is a script that solves the *Grid World* problem with **Temporal Difference** methods;
- `TemporalDifference/Src` contains the code to implement **Temporal Difference** methods;
  - `TempDiff` is a class that implements **Temporal Difference** methods: SARSA, ESARSA, QL, DQL;
