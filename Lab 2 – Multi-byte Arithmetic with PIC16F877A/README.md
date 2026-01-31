# Lab 2 – Multi-byte Arithmetic with PIC16F877A

## Description
This experiment demonstrates **multi-byte arithmetic operations** on an 8-bit microcontroller using **PIC16F877A** assembly language.

The main objective is to perform arithmetic operations on **24-bit numbers** by manually handling low, middle, and high bytes, including carry propagation between bytes.

## Implemented Operations
- 24-bit left shift operations (multiplication by powers of 2)
- Multi-byte addition with carry handling
- Register-level bank management
- Bitwise shift operations using `RLF`

## Variables & Memory Organization
- **x (24-bit)**: Stored in Bank 1  
- **y (24-bit)**: Stored in Bank 2  
- **z (24-bit)**: Stored in Bank 3  
- Temporary registers and counters are stored in **Bank 0**

Memory addresses are manually assigned using `EQU`.

## Hardware & Simulation
- Target MCU: **PIC16F877A**
- Architecture: **8-bit**
- Output: **PORTD (LED display)**
- Simulator: **PICSimLab**
- IDE: **MPLAB X**
- Assembler: **XC8 (pic-as)**


## Notes
- Bank switching is handled explicitly using `STATUS.RP0` and `STATUS.RP1`
- Carry flag (`STATUS.C`) is carefully managed during multi-byte addition
- Final result is displayed using the **high byte of Z on PORTD**

