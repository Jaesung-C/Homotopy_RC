# Homotopy Reservoir Computing

Official MATLAB code reproducing the key figures of the paper:

> **Homotopy reservoir computing: Harnessing chaos for computation**
> *Chaos* (2025) — DOI: [10.1063/5.0265318](https://doi.org/10.1063/5.0265318)

> **Note.** This repository was cleaned up and reorganised separately after
> publication, so minor differences from the original code are possible — but it
> reproduces essentially the same results as the published figures.

---

## Overview

Homotopy Reservoir Computing (HRC) is a reservoir computing architecture whose
reservoir is a network of coupled *chaotic* dynamical systems — coupled Lorenz
oscillators, the Kuramoto–Sivashinsky (KS) PDE, or the Lorenz-96 model.  A
**homotopy blending mechanism** smoothly interpolates each reservoir node
between two regimes:

- **Chaotic mode** (full nonlinear attractor dynamics) — activated by input
- **Equilibrium mode** (pull toward a fixed point) — stabilises the reservoir when input is weak

The homotopy weight for node *i* is

```
s1 = (1 - exp(-p1 · ‖u_i‖)) · exp(-p2 · ‖r_i − r_eq‖)
s2 = 1 − s1
```

where `u_i` is the input projection and `r_i − r_eq` is the node's deviation
from its equilibrium.  This replaces the usual echo-state condition (spectral
radius < 1) with a physically motivated stability mechanism while keeping the
rich dynamics of a chaotic substrate.

---

## Repository Structure

```
Homotopy_RC_repos/
├── core/                     Reservoir update functions (one step)
│   ├── homotopy_rc.m         Coupled-Lorenz HRC (N nodes, 3N states) ← main
│   ├── homotopy_rc_KS.m      Kuramoto–Sivashinsky PDE reservoir (ETDRK4)
│   ├── homotopy_rc_L96.m     Lorenz-96 reservoir
│   └── homotopy_rc_s1.m      Switch-recording variant of homotopy_rc
│                             (writes s1 into the last state slot; used only
│                             for the switch_variable figure)
│
├── defaults/                 Default hyperparameter structs
│   ├── homotopyDefaults.m        Coupled Lorenz (N=100)
│   ├── homotopyDefaults_KS.m     Kuramoto–Sivashinsky (N=128)
│   └── homotopyDefaults_L96.m    Lorenz-96 (N=40)
│
├── utils/                    RC pipeline + helpers
│   ├── rc_train_state.m      Drive reservoir, collect states (1000-step washout)
│   ├── rc_readout.m          Linear readout (pseudoinverse / ridge)
│   ├── out_test.m            Open-loop test (reconstruction)
│   ├── long_pred.m           Closed-loop autonomous prediction
│   ├── metric_error.m        RMSE, NRMSE1, NRMSE2, MAE
│   ├── data_gen.m            Generate time-series from a dynamical system
│   ├── task_gen.m            Build input–target pairs per task
│   ├── given_test_split.m    Train/test split
│   ├── narma.m               NARMA-N benchmark sequence
│   ├── ks_step.m             ETDRK4 one-step KS integrator
│   ├── save_figure.m         Export a figure to figures/output (PDF, or PNG via 'image')
│   ├── struct2vars.m         Unpack struct fields into the workspace
│   └── defaults2args.m       Fill missing data args from system defaults
│
├── systems/                  Dynamical systems + solvers
│   ├── eq_rossler.m / eq_rosslerDefaults.m   Rössler (reconstruction target)
│   ├── eq_mackey.m  / eq_mackeyDefaults.m    Mackey–Glass DDE (prediction target)
│   ├── eq_lorenz.m  / eq_lorenzDefaults.m    Lorenz system
│   ├── rk4_solver.m          4th-order Runge–Kutta solver
│   ├── dde23_solver.m        Delay-differential solver (Mackey–Glass)
│   ├── recon_task.m          Task helper: observe a subset, reconstruct the rest
│   └── pred_task.m           Task helper: one-step-ahead prediction
│
└── figures/                  Figure scripts
    ├── concept.m             Concept illustration (Lorenz-96 substrate)
    ├── reconstruction.m      Rössler reconstruction (CLN / L96 / KS)
    ├── prediction.m          Mackey–Glass real-time prediction
    └── switch_variable.m     Homotopy switch variable s(t)
```

Figures are written to `figures/output/` — dense raster panels (`concept`,
`reconstruction`) as PNG, line plots (`prediction`, `switch_variable`) as
vector PDF.

---

## Quick Start

```matlab
addpath(genpath('path/to/Homotopy_RC_repos'));

cd figures
concept            % concept illustration   (fast, ~seconds)
reconstruction     % Rössler reconstruction (~1–2 min: three reservoir substrates)
prediction         % Mackey–Glass prediction (~1 min: closed-loop)
switch_variable    % switch variable s(t)   (fast, ~seconds)
```

Each script prints its diagnostics (NRMSE values, switch-variable range) and
saves the figure to `figures/output/`.

---

## The Figures

| Script | Output | What it shows |
|--------|--------|---------------|
| `concept` | `concept.png` | Concept illustration of the homotopy mechanism on a Lorenz-96 substrate: free-running spatiotemporal chaos vs. the same nodes embedded as a Homotopy reservoir (rest → input-driven excitation → relaxation back to equilibrium) |
| `reconstruction` | `reconstruction.png` | Rössler attractor reconstruction (observe *x*, reconstruct *y,z*) with three reservoirs: coupled Lorenz, Lorenz-96, KS *(manuscript Fig. 2)* |
| `prediction` | `prediction.pdf` | Real-time (closed-loop) prediction of the Mackey–Glass series over 10 000 steps *(manuscript Fig. 3)* |
| `switch_variable` | `switch_variable.pdf` | The homotopy switch variable *s(t)* of a representative node while the reservoir is driven by the Rössler task — shows each node being continuously blended between chaotic (*s*≈1) and equilibrium (*s*≈0) modes *(manuscript Fig. 4)* |

Approximate reconstruction error (NRMSE₂ of *z*): coupled Lorenz ≈ 0.0008,
Lorenz-96 ≈ 0.028, KS ≈ 0.003.

---

## Reproducibility note: input-weight initialisation

The manuscript *text* states that the input weight matrix `Win` is "initialized
with uniformly distributed random values in [-0.1, 0.1]". The released reference
code, however, initialised it with a **Gaussian** draw,

```matlab
Win = Win_a * (randn(N, inSize) * 2 - 1);     % Win_a = 0.1
```

which is `N(-0.1, 0.2²)`, *not* `Uniform[-0.1, 0.1]` — most likely a
`rand` → `randn` slip. The **published figures were produced with this Gaussian
form**, so this repository reproduces it (see `switch_variable.m`) in order to
match the paper's figures exactly. We document the discrepancy here so that users
are aware of it and can explore the alternative.

**Does it change the results?** Only the switch-variable figure.

- `reconstruction` / `prediction` train a linear readout *after* `Win`, so the
  readout absorbs the choice of `Win` and the error is essentially unchanged.
  Reconstructing the Rössler *z* component gives the same NRMSE₂ under all three
  initialisations:

  | `Win` initialisation | NRMSE₂ (*z*) |
  |----------------------|--------------|
  | `randn(1,3N)`, std 1 (this repo's default) | 0.00084 |
  | `0.1·(randn·2−1)`, Gaussian (published code) | 0.00086 |
  | `0.1·(2·rand−1)`, Uniform[−0.1,0.1] (manuscript text) | 0.00092 |

- `switch_variable` reads `s = (1−e^{−p1‖u‖})·e^{−p2‖r−r_eq‖}` *directly* off
  `u = Win·input` with no trained readout, so it depends sensitively on `Win`.
  To follow the manuscript text instead of the published figure, replace the
  Gaussian draw in `switch_variable.m` with
  `Win_a * (2*rand(nWin, inSize) - 1)`.

---

## Key Parameters

| Field | Symbol | Typical | Description |
|-------|--------|---------|-------------|
| `ep`     | K   | 7–17 | Inter-node coupling strength |
| `p1`     | ε₁  | 1 (Lorenz) | Homotopy input-sensitivity exponent |
| `p2`     | ε₂  | 1 (Lorenz) | Homotopy equilibrium-proximity exponent |
| `var_l1` | σ_ω | 0.2  | Time-scale (rate) noise std |
| `var_l2` | σ_ρ | 10   | Reservoir parameter noise std |
| `N`      | N   | 100 / 40 / 128 | Number of reservoir nodes (Lorenz / L96 / KS) |
| `reg_p`  | λ   | — | Optional ridge parameter; if unset the readout uses `pinv` |

The KS and Lorenz-96 reservoirs use their own homotopy exponents and step sizes
(see the supplementary material), baked into their `homotopyDefaults_*` files.

---

## Supported Reservoirs and Tasks

| `type_rc` | Reservoir dynamics | State dim |
|-----------|--------------------|-----------|
| `homotopy_rc`     | N coupled Lorenz ODEs | 3N |
| `homotopy_rc_KS`  | Kuramoto–Sivashinsky PDE (ETDRK4) | N = 128 |
| `homotopy_rc_L96` | Lorenz-96 | N = 40 |
| `homotopy_rc_s1`  | Coupled Lorenz, records switch weight s1 (diagnostic) | 3N |

| Task name | Description |
|-----------|-------------|
| `'reconstruction'` | Observe a subset of dimensions, reconstruct the rest (open-loop) |
| `'prediction'`     | Closed-loop autonomous prediction |
| `'narma<N>'`       | NARMA-N nonlinear memory benchmark |

---

## Requirements

- MATLAB R2020a or later (uses only core MATLAB)
- `exportgraphics` for figure export (R2020a+)
- `dde23` for the Mackey–Glass target in the prediction figure (built-in)

---

## Citation

```bibtex
@article{homotopy_rc_2025,
  title   = {Homotopy reservoir computing: Harnessing chaos for computation},
  author  = {Choi, Jaesung and Kim, Pilwon},
  journal = {Chaos},
  year    = {2025},
  doi     = {10.1063/5.0265318}
}
```
