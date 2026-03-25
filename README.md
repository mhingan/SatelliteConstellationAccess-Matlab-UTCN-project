# Satellite Constellation Access Analyzer

A MATLAB-based application for analyzing satellite constellation access over ground stations, developed as a project at the Technical University of Cluj-Napoca (UTCN).

---

## Overview

This tool allows you to:

- **Configure** LEO (Low Earth Orbit) satellite constellations with custom orbital parameters
- **Define** ground stations with customizable position and minimum elevation angle
- **Simulate** camera sensors (conical sensors) mounted on each satellite
- **Analyze** access intervals between satellites and the ground station
- **Calculate** system-wide access coverage statistics
- **Visualize** the scenario in an interactive 3D viewer
- **Generate** TLE (Two-Line Element) files for custom constellations

---

## Project Structure

```
proiect_sc_hm/
├── SatelliteConstellationApp.m     # Main MATLAB GUI application
├── createLEOConstellationTLE.m     # Utility to generate TLE files for LEO constellations
├── leoConstellation.tle            # Sample TLE file (40 LEO satellites, 55° inclination)
├── run_sat_app.m                   # Startup script — checks toolboxes and launches the app
└── test.m                          # Standalone test script for quick scenario runs
```

---

## Requirements

- **MATLAB** (R2021b or later recommended)
- **Satellite Communications Toolbox**
- **Aerospace Toolbox**

To check which toolboxes are installed, run `ver` in the MATLAB Command Window, or use the provided `run_sat_app.m` script which performs this check automatically.

---

## Getting Started

### 1. Launch the GUI Application

Open MATLAB, navigate to the `proiect_sc_hm` folder, and run:

```matlab
run_sat_app
```

This script:
1. Verifies that all required toolboxes are installed.
2. Launches the `SatelliteConstellationApp` graphical interface.

### 2. Use the Application

The app has five sections accessible via the navigation panel:

| Section | Description |
|---|---|
| **Welcome** | Introduction and quick-start button |
| **Configuration** | Set satellite and ground station parameters |
| **Simulation** | Launch the 3D viewer and run the scenario |
| **Results** | View access statistics, intervals, and plots |
| **Help** | Usage instructions and parameter descriptions |

### 3. Configuration Parameters

**Satellite Constellation:**

| Parameter | Default | Range | Description |
|---|---|---|---|
| Number of satellites | 40 | 1–100 | Total satellites evenly distributed in one orbital plane |
| Altitude (km) | 500 | 200–2000 | Orbital altitude above Earth's surface |
| Inclination (°) | 55 | 0–90 | Orbital inclination |
| Camera FOV (°) | 90 | 10–180 | Half-angle field of view of the conical sensor |

**Ground Station:**

| Parameter | Default | Range | Description |
|---|---|---|---|
| Latitude (°) | 42.3 | −90 to 90 | Geographic latitude |
| Longitude (°) | −71.35 | −180 to 180 | Geographic longitude |
| Min Elevation Angle (°) | 30 | 0–90 | Minimum satellite elevation for a valid pass |
| Simulation Duration (h) | 6 | 1–24 | Total scenario duration |
| Sample Time (s) | 30 | 10–300 | Propagation time step |

---

## Generating a TLE File

Use `createLEOConstellationTLE` to generate a custom TLE file:

```matlab
createLEOConstellationTLE(numSatellites, altitude, inclination, filename)
```

**Example:**
```matlab
% Create a 40-satellite constellation at 550 km, 53° inclination
createLEOConstellationTLE(40, 550, 53, 'myConstellation.tle');
```

This creates a TLE file that can be loaded into any satellite scenario tool, including the MATLAB Satellite Communications Toolbox.

---

## Running the Test Script

The `test.m` script provides a quick, standalone demonstration without the GUI:

```matlab
% In MATLAB, navigate to proiect_sc_hm/ and run:
run('test.m')
```

The script:
1. Creates a 24-hour satellite scenario starting on May 12, 2020.
2. Loads the LEO constellation from a TLE file (`leoSatelliteConstellation.tle`).
3. Attaches a gimbal and conical sensor to each satellite, pointed at the ground station.
4. Places a ground station in Cluj-Napoca, Romania (46.77°N, 23.62°E) with a 20° minimum elevation angle.
5. Computes and displays access intervals.
6. Opens a 3D scenario viewer and plots the system-wide access status over time.

> **Note:** The test script expects a file named `leoSatelliteConstellation.tle` in the working directory. You can generate one with `createLEOConstellationTLE`, or rename the provided `leoConstellation.tle`.

---

## Sample TLE File

The included `leoConstellation.tle` contains 40 satellites (LEO-SAT-1 through LEO-SAT-40) with:
- Altitude: ~550 km (mean motion ≈ 15.22 rev/day)
- Inclination: 55°
- Satellites evenly spaced in one orbital plane (every 9°)

---

## Example Output

After running a simulation, the application shows:

- **Access intervals table** — start/stop times for each satellite pass
- **System-wide access plot** — a binary time-series showing when at least one satellite is visible
- **Coverage percentage** — fraction of the simulation during which the ground station has access to any satellite
- **3D scenario viewer** — animated orbital view with satellite tracks and access links highlighted in red

---

## Acknowledgements

This project was developed as part of a satellite communications course at the **Technical University of Cluj-Napoca (UTCN)** and uses the **MathWorks Satellite Communications Toolbox** for orbital propagation and access analysis.