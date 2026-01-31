# Lab 03 – Indirect Addressing and Decision Logic

This laboratory experiment focuses on implementing array operations, indirect memory addressing, and complex decision-making logic using PIC Assembly on an 8-bit microcontroller.

## 🔧 Environment

* **Microcontroller:** PIC16F84A / PIC16F877A
* **Architecture:** 8-bit
* **Language:** PIC Assembly
* **Assembler:** MPLAB XC8 (pic-as)
* **Simulation:** PICSimLab
* **Clock Frequency:** ~4 MHz

## 🧮 Implemented Concepts

The following low-level tasks are implemented step-by-step:

### 1. Array Generation & Pointer Manipulation
* **Array Definition:** Computes $A[i] = 2^i$ for $i = 0 \dots 7$ using power-of-two logic.
* **Indirect Addressing:** Uses `FSR` (File Select Register) and `INDF` (Indirect File) to manage memory buffers dynamically in RAM.
* **Efficient Arithmetic:** All operations are implemented manually using Rotate-Left (`RLF`) instructions instead of complex multiplication.

### 2. Multi-Stage Decision Logic (Coordinate Mapping)
* **Nested Branching:** Emulates `IF-ELSE` structures using `BTFSS`, `BTFSC`, and `GOTO` instructions.
* **Range Validation:** Performs boundary checks (e.g., $x \leq 11$, $y \leq 10$) using the `SUBLW` instruction and monitoring the `STATUS` register Carry bit.

## 🚥 LED Sequence & Visual Logic

### Module 1: Power-of-Two "Ping-Pong" Scanner
The program displays the generated array on **PORTD** in a bidirectional (Knight Rider) pattern. The sequence follows a specific timing requirement:



* **Forward Path:** LED moves from **RD0** to **RD7** with **200ms** intervals.
* **Corner Hold:** Once the sequence hits the boundaries (**RD0** or **RD7**), it stays lit for **500ms** before reversing direction.
* **Backward Path:** LED moves back from **RD6** to **RD1** with **200ms** intervals.

**Binary Pattern on PORTD:**
* `00000001` (RD0) -> **500ms Delay**
* `00000010` (RD1) -> 200ms Delay
* `00000100` (RD2) -> 200ms Delay
* ...
* `10000000` (RD7) -> **500ms Delay**
* `01000000` (RD6) -> 200ms Delay

## ⏱ Delay Control

Two software delay subroutines are implemented to match the timing requirements of the laboratory manual:
* **~200 ms Delay:** Optimized for fast transitions during the scanning phase.
* **~500 ms Delay:** Optimized for the "Corner Hold" effect at the start and end of the array.
* *Note: Delays are achieved using triple-nested loop counters and are calibrated for a 4 MHz clock speed.*



## 📝 Notes

* **I/O Configuration:** `PORTD` is configured as output for LED visualization; `TRISD` is handled in Bank 1.
* **Memory Management:** Variable storage is defined starting from address `0x20`, while the array is stored at `0x30`.
* **Bank Selection:** Memory bank switching is handled manually using `BSF/BCF` on the `STATUS` register bits.
* **Verification:** All logic was verified using **PICSimLab** to match the required timing diagram and LED sequence.
