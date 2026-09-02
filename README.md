\# C2S0306 – AES/RSA/SHA Cryptographic Accelerator



A complete \*\*RTL-to-GDSII ASIC implementation\*\* of a hardware cryptographic accelerator integrating \*\*AES, RSA, and SHA\*\* engines with an \*\*APB interface\*\*, implemented in \*\*SCL 180 nm CMOS technology\*\* using the Cadence digital ASIC design flow.



The project covers the complete ASIC implementation cycle from RTL development and functional verification through synthesis, logic equivalence checking, physical design, signoff, and final GDSII generation.



\---



\## Project Overview



Modern embedded and communication systems require high-performance cryptographic processing with predictable timing and efficient hardware utilization. This project implements dedicated hardware accelerators for:



\* \*\*AES\*\* – Symmetric encryption and decryption

\* \*\*RSA\*\* – Public-key cryptographic operations

\* \*\*SHA-256\*\* – Secure hashing and message integrity

\* \*\*APB\*\* – Processor-to-accelerator control and data interface

\* \*\*SIPO\*\* – Serial-In Parallel-Out input interface

\* \*\*PISO\*\* – Parallel-In Serial-Out output interface



The SIPO/PISO architecture was introduced to reduce the number of external I/O pins and improve the physical utilization of the ASIC. This enabled the design to move from an initial \*\*4 × 4 pad configuration to a compact 3 × 3 configuration\*\*.



\---



\## Key Features



\* AES encryption and decryption

\* RSA cryptographic accelerator

\* SHA-256 hashing accelerator

\* 32-bit internal datapath

\* APB-based register interface

\* Serial input/output architecture

\* Central cryptographic scheduler

\* Configurable register bank

\* Modular Verilog RTL architecture

\* RTL functional verification

\* Gate-level synthesis

\* RTL-to-netlist Logic Equivalence Checking

\* Physical implementation

\* Clock Tree Synthesis

\* Routing

\* DRC and antenna verification

\* Post-layout equivalence checking

\* Final GDSII generation



\---



\## System Architecture



```text

&#x20;                        ┌──────────────────────────┐

&#x20;                        │      APB Interface       │

&#x20;                        │   APB Slave / Control    │

&#x20;                        └────────────┬─────────────┘

&#x20;                                     │

&#x20;                                     ▼

&#x20;                        ┌──────────────────────────┐

&#x20;                        │     Register Bank        │

&#x20;                        │   Configuration / Data   │

&#x20;                        └────────────┬─────────────┘

&#x20;                                     │

&#x20;                                     ▼

&#x20;                        ┌──────────────────────────┐

&#x20;                        │   Crypto Scheduler       │

&#x20;                        │   Control / Sequencing   │

&#x20;                        └────────────┬─────────────┘

&#x20;                                     │

&#x20;                ┌────────────────────┼────────────────────┐

&#x20;                │                    │                    │

&#x20;                ▼                    ▼                    ▼

&#x20;       ┌────────────────┐   ┌────────────────┐   ┌────────────────┐

&#x20;       │      AES       │   │      RSA       │   │    SHA-256     │

&#x20;       │ Encrypt/Decrypt│   │ Cryptographic  │   │ Hash Engine    │

&#x20;       └────────────────┘   │    Engine      │   └────────────────┘

&#x20;                            └────────────────┘

&#x20;                                    

&#x20;                Serial Data Path

&#x20;                        │

&#x20;             ┌──────────┴──────────┐

&#x20;             ▼                     ▼

&#x20;       ┌───────────┐         ┌───────────┐

&#x20;       │   SIPO    │         │   PISO    │

&#x20;       │ Serial In │         │ Serial Out│

&#x20;       └───────────┘         └───────────┘

```



\---



\## ASIC Design Flow



The project was taken through the major stages of a digital ASIC implementation flow:



```text

RTL Design

&#x20;   │

&#x20;   ▼

Functional Verification

&#x20;   │

&#x20;   ▼

Logic Synthesis ──────────► Genus

&#x20;   │

&#x20;   ▼

RTL ↔ Netlist LEC ────────► Conformal

&#x20;   │

&#x20;   ▼

Pre-Gate-Level Simulation

&#x20;   │

&#x20;   ▼

Floorplanning

&#x20;   │

&#x20;   ▼

Power Planning

&#x20;   │

&#x20;   ▼

Placement

&#x20;   │

&#x20;   ▼

Clock Tree Synthesis

&#x20;   │

&#x20;   ▼

Routing

&#x20;   │

&#x20;   ▼

Post-Layout LEC

&#x20;   │

&#x20;   ▼

Physical Verification

&#x20;┌──┴───────────────┐

&#x20;▼                  ▼

DRC              Antenna

&#x20;└───────┬──────────┘

&#x20;        ▼

&#x20;   Final Signoff

&#x20;        │

&#x20;        ▼

&#x20;     GDSII

```



The implementation flow used Cadence tools for RTL verification, synthesis, equivalence checking, and physical implementation.



\---



\## Technology and Tools



| Category              | Technology / Tool     |

| --------------------- | --------------------- |

| Process Technology    | SCL 180 nm CMOS       |

| HDL                   | Verilog HDL           |

| RTL Simulation        | Cadence Xcelium       |

| Synthesis             | Cadence Genus         |

| Logic Equivalence     | Cadence Conformal LEC |

| Physical Design       | Cadence Innovus       |

| Physical Verification | DRC / Antenna         |

| Final Layout          | GDSII                 |



\---



\## Synthesis Results



The synthesized design successfully met the specified timing requirements.



| Parameter                  |     Result |

| -------------------------- | ---------: |

| Technology                 | SCL 180 nm |

| Clock Period               |      58 ns |

| Worst Negative Slack (WNS) |   +1467 ps |

| Total Negative Slack (TNS) |       0 ps |

| Failing Endpoints          |          0 |

| Total Cell Area            |  2,663,343 |

| Leaf Cells                 |     77,865 |

| Total Instances            |     77,865 |



These values are from the Cadence Genus QoR reported for the implemented design.



\---



\## Physical Design Results



The design progressed through:



\* Floorplanning

\* Power planning

\* Placement

\* Clock Tree Synthesis

\* Routing

\* Post-layout verification

\* Final signoff



A key physical-design optimization was the reduction of external I/O requirements using SIPO and PISO. This enabled the transition from the initial \*\*4 × 4 pad configuration to 3 × 3\*\*, improving silicon utilization and reducing package complexity.



\---



\## Signoff Results



Final implementation achieved:



\* \*\*RTL-to-netlist LEC: PASS\*\*

\* \*\*Post-layout LEC: PASS\*\*

\* \*\*DRC violations: 0\*\*

\* \*\*Antenna violations: 0\*\*

\* \*\*Final GDSII generated successfully\*\*



The project report states that the final physical implementation completed successfully and that the final GDSII database was generated.



\---



\## Repository Structure



```text

C2S0306-AES-RSA-SHA-Cryptographic-Accelerator/

│

├── constraints/

│   ├── C2S0306.io

│   ├── C2S0306\_signoff.sdc

│   └── crypto\_constraints.sdc

│

├── rtl/

│   ├── apb/

│   ├── common/

│   ├── third\_party/

│   │   ├── secworks\_aes/

│   │   ├── secworks\_rsa/

│   │   └── secworks\_sha256/

│   └── top/

│

├── verification/

│   ├── aes/

│   ├── apb/

│   ├── sha256/

│   └── top/

│

├── synthesis/

│   ├── reports/

│   ├── scripts/

│   └── rtl\_files\_top.f

│

├── lec/

│

├── results/

│   └── lec/

│

├── physical\_design/

│   ├── floorplan/

│   ├── power\_planning/

│   ├── placement/

│   ├── cts/

│   └── routing/

│

├── signoff/

│

├── gls/

│

├── post\_gls/

│

└── .gitignore

```



\---



\## Verification



The RTL was verified at both module and system levels.



Verification coverage includes:



\* AES functional blocks

\* AES encryption/decryption

\* APB interface

\* Register bank

\* SHA-256

\* Integrated cryptographic accelerator

\* Serial input/output path

\* Top-level functionality



Cadence Xcelium and waveform-based debugging were used during RTL verification.



\---



\## Physical Design Optimization



\### I/O Reduction



The original implementation required a relatively large number of external pins, resulting in low core utilization.



The design was therefore modified to introduce:



```text

External Serial Input

&#x20;       │

&#x20;       ▼

&#x20;     SIPO

&#x20;       │

&#x20;       ▼

&#x20;  32-bit Internal

&#x20;     Datapath

&#x20;       │

&#x20;       ▼

&#x20;     PISO

&#x20;       │

&#x20;       ▼

External Serial Output

```



This reduced the external I/O requirement and enabled a transition from a \*\*4 × 4 pad configuration to 3 × 3\*\*.



\---



\## Engineering Highlights



This project demonstrates practical experience with:



\* RTL design using Verilog

\* AMBA APB interface integration

\* Cryptographic hardware architecture

\* Serial/parallel data-path design

\* RTL functional verification

\* Logic synthesis

\* Timing analysis

\* Logic equivalence checking

\* Floorplanning

\* Power planning

\* Placement

\* CTS

\* Routing

\* Physical verification

\* Signoff

\* GDSII generation



The complete flow was carried through physical implementation rather than stopping at RTL simulation or synthesis.



\---



\## Future Improvements



Potential extensions include:



\* Migration to advanced CMOS nodes

\* ECC and ChaCha20 accelerators

\* Post-quantum cryptographic algorithms

\* Higher-performance AMBA interfaces such as AHB/AXI

\* DFT and scan-chain integration

\* BIST implementation

\* Clock-gating and low-power optimization

\* Complete parasitic-extraction-based STA

\* Silicon fabrication and hardware validation



\---



\## Authors



\*\*Kamales D\*\*

\*\*Kavin Nathan V\*\*

\*\*Dinesh A\*\*



\---



\## Disclaimer



This repository contains the project RTL, verification material, implementation scripts, reports, and selected ASIC design artifacts.



\*\*Foundry/PDK proprietary libraries and technology files are intentionally excluded from this repository.\*\*



The third-party cryptographic RTL included in `rtl/third\_party/` remains subject to its respective upstream licensing terms.



