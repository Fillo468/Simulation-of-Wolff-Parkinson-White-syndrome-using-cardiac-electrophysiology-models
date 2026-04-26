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

The simulation is based on a 2D representation of the heart, where different regions are characterized by specific electrophysiological properties:

Atrial Tissue: Modeled with specific conductivity and recovery parameters to simulate atrial depolarization.

Ventricular Tissue: To reproduce the physiological transmural heterogeneity, the ventricular wall (with a thickness of 1 cm) is divided into three distinct layers:
 * Epicardium: The outermost layer (36% of the wall thickness).
 * Mid-myocardium: The intermediate layer.
 * Endocardium: The innermost layer (36% of the wall thickness), characterized by faster conduction.

Inclusion of:

  * Sinoatrial node (SAN)
  * Atrioventricular node (AVN)
  * Insulating boundary between atria and ventricles
* Configurable accessory pathways (Bundle of Kent)

![Rappresentation](results/rappresentation.png)

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

![Propagation](results/Propagation.mp4)

### AVRT

![AVRT](results/avrt_simulation.mp4)

### Multiple Pathways

![Multiple KENT](results/multiple_KENT.mp4)

---

## How to Run

Each simulation is independent.

Run one of the following scripts:

* `propagation_simulation.m` → normal propagation, with ECG approximation
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
* Extension to 3D simulations

---

## Author

Filippo Aspi

---

## License

This project is licensed under the MIT License.
