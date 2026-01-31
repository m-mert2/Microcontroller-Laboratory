# Lab 01 – Arithmetic Operations in PIC Assembly

This laboratory experiment focuses on implementing arithmetic expressions
using PIC Assembly on an 8-bit microcontroller.

---

## 🔧 Environment

- **Microcontroller:** PIC16F877A
- **Architecture:** 8-bit
- **Language:** PIC Assembly
- **Assembler:** MPLAB XC8
- **Simulation:** PICSimLab

---

## 🧮 Implemented Operations

The following expressions are calculated step by step:

- r1 = 5*x - 2*y + z - 3  
- r2 = (x + 5)*4 - 3*y + z  
- r3 = x/2 + y/2 + z/4  
- r4 = (3*x - y - 3*z)*2 - 30  
- r  = 3*r1 + 2*r2 - r3/2 - r4  

All operations are implemented manually using loops and
bitwise rotate/shift instructions.

---

## 💡 Output

- The final result is written to **PORTD**
- LEDs connected to PORTD display the result in binary form

---

## 📝 Notes

- Arithmetic is performed using 8-bit registers (modulo 256 behavior)
- Tested using PICSimLab
- Written for educational purposes
