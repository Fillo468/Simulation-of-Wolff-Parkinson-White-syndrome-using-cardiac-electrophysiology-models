# Wolff-Parkinson-White Cardiac Electrophysiology Simulation

## Overview

This project presents a computational simulation of **Wolff-Parkinson-White (WPW) syndrome**, a cardiac conduction disorder characterized by the presence of accessory pathways (Bundle of Kent) that bypass the atrioventricular node.

The model reproduces the electrical propagation in cardiac tissue and investigates pathological behaviors such as **atrioventricular reentrant tachycardia (AVRT)**.

---

## Objectives

* Simulate cardiac electrical activity in a 2D domain
* Model normal and pathological conduction pathways
* Reproduce AVRT mechanisms
* Analyze the effect of multiple accessory pathways
* Approximate ECG signals from simulated data

---

## Model Description

### Geometry

* 2D representation of cardiac tissue
* Separation between atrial and ventricular regions
* Inclusion of:

  * Sinoatrial node (SAN)
  * Atrioventricular node (AVN)
  * Insulating boundary between atria and ventricles
* Configurable accessory pathways (Bundle of Kent)

---

### Mathematical Model

* Monodomain model for cardiac electrophysiology
* Assumption of proportional intracellular and extracellular conductivities

---

### Ionic Models

* Rogers-McCulloch model for ionic currents
* FitzHugh-Nagumo model for SAN automaticity

---

### Numerical Methods

* Finite difference method
* 2D spatial discretization
* 5-point stencil for Laplacian approximation
* Ghost points for boundary conditions

---

## Simulations

### 1. Normal Propagation

Simulation of physiological electrical propagation across atria and ventricles. 
The ECG signal is approximated by projecting the electrical activity onto a rotated reference system.
To improve physiological realism, the heart is assumed to be rotated by 45° within the thoracic cavity.


### 2. AVRT Simulation

Reentrant circuit induced by accessory pathway leading to tachycardia.

### 3. Multiple Accessory Pathways

Study of conduction patterns with multiple Kent bundles.

---

## Results

### Propagation

![Propagation](results/propagation.png)

### AVRT

![AVRT](results/avrt.png)

### Multiple Pathways

![Multiple](results/multiple_kent.png)

---

## Project Structure

project-root/
│
├── code/
│   ├── propagation_simulation.m
│   ├── avrt_simulation.m
│   └── multiple_kent_paths.m
│
├── results/
├── presentation/
├── README.md
└── LICENSE

---

## How to Run

Each simulation is independent.

1. Open MATLAB
2. Navigate to the `code/` folder

Run one of the following scripts:

* `propagation_simulation.m` → normal propagation
* `avrt_simulation.m` → reentrant tachycardia
* `multiple_kent_paths.m` → multiple accessory pathways

Each script can be modified to explore different parameters such as:

* Diffusivity
* Tissue properties
* Accessory pathway configuration

---

## Limitations

* Simplified 2D geometry
* Approximate ECG model not fully consistent with physiological recordings

---

## Future Improvements

* More realistic cardiac geometry
* Improved ECG modeling
* Extension to 3D simulations
* Parameter calibration with physiological data

---

## Author

Filippo Aspi

---

## License

This project is licensed under the MIT License.
