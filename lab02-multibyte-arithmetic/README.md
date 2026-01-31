# Lab 02 – Multi-byte Arithmetic with PIC Assembly

This laboratory experiment focuses on performing **multi-byte arithmetic**
operations using PIC Assembly on an 8-bit microcontroller.

The aim is to understand how larger-than-8-bit values are handled manually
through register pairing and carry propagation.

---

## 🔧 Environment

- **Microcontroller:** PIC16F877A  
- **Architecture:** 8-bit  
- **Language:** PIC Assembly  
- **Assembler:** MPLAB XC8  
- **Simulation:** PICSimLab  

---

## 🧮 Implemented Concepts

The following low-level concepts are implemented and tested:

- Multi-byte addition and subtraction  
- Carry and borrow handling  
- Register pairing (LSB / MSB)  
- Manual propagation using STATUS register  
- Arithmetic on values larger than 8 bits  

All operations are implemented explicitly using PIC assembly instructions
without relying on high-level abstractions.

---

## 💡 Output

- The final result is written to **PORTD**
- LEDs connected to PORTD display the **LSB (Least Significant Byte)** of the result
- Intermediate values are stored in general-purpose registers

---

## 📝 Notes

- Arithmetic is performed on multi-byte values using 8-bit registers  
- Overflow and carry are handled manually  
- Tested using **PICSimLab**  
- Written for educational purposes  
