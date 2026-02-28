# Lab 04 – Conditional Number Generation, Multiplication & Button Display

This laboratory experiment focuses on implementing conditional number generation using arithmetic operations, 8-bit multiplication, array summation, and button-driven display on a PIC 8-bit microcontroller.

## 🔧 Environment

- **Microcontroller:** PIC16F877A
- **Architecture:** 8-bit
- **Language:** PIC Assembly
- **Assembler:** MPLAB XC8 (pic-as)
- **Simulation:** PICSimLab
- **Clock Frequency:** ~4 MHz

## 🧮 Implemented Concepts

The following low-level tasks are implemented step-by-step:

### 1. Conditional Array Generation

- **Loop Control:** A `while` loop runs as long as $x < N$ **or** $y < N$, with initial values $x = 7$, $y = 11$, $N = 23$.
- **Odd/Even Branching:** At each iteration $temp = x + y$ is computed. The program branches based on parity using `BTFSS` on bit 0:
  - **Odd →** Stores $x \times y$ into the array, then increments $x$.
  - **Even →** Stores $\lfloor (x + y) / 3 \rfloor$ into the array, then increments $y$ by 3.
- **Indirect Addressing:** Uses `FSR` / `INDF` to write results sequentially into RAM starting at address `0x30`.

### 2. 8-bit Shift-and-Add Multiplication

- **Algorithm:** Performs `arg1 × arg2` using an 8-iteration shift-and-add loop (`RRF` + conditional `ADDWF`).
- **Result Handling:** The 16-bit product is accumulated in `mul_res_H:mul_res_L` and a combined value is returned via the W register.

### 3. Integer Division by 3

- **Repeated Subtraction:** Divides $(x + y)$ by 3 using a subtraction loop, storing the quotient and remainder separately.

### 4. Array Summation

- **Subroutine:** `AddNumbers` iterates over the generated array using `FSR`/`INDF` and accumulates the total into the `sum` variable.

## 🚥 Display & Button Interaction

### Output on PORTD

After generation and summation, the **total sum** is immediately displayed on `PORTD` (e.g., via LEDs).

### Button-Driven Element Browsing

- **Input:** `RB2` on `PORTB` is used as a push-button input.
- **Debounce Logic:** The program waits for a press (low) followed by a release (high) before acting.
- **Cycling:** Each valid button press displays the next array element on `PORTD`.
- **Reset:** After **5 elements** have been shown, the display returns to the total sum and the index resets to zero.
- The cycle repeats indefinitely.

## 🗺️ Memory Map

| Address | Variable    | Description                     |
| ------- | ----------- | ------------------------------- |
| 0x20    | x           | Loop variable                   |
| 0x21    | y           | Loop variable                   |
| 0x22    | N           | Upper bound                     |
| 0x23    | count       | Number of generated elements    |
| 0x24    | sum         | Sum of array elements           |
| 0x27    | array_index | Array index for button loop     |
| 0x30+   | ARRAY       | Generated numbers buffer        |
| 0x70    | arg1        | Multiply parameter 1            |
| 0x71    | arg2        | Multiply / add parameter 2      |
| 0x74    | math_temp   | Temporary calculation register  |
| 0x78    | mul_res_L   | Multiplication result low byte  |
| 0x79    | mul_res_H   | Multiplication result high byte |
| 0x7A    | loop_i      | Loop counter                    |
| 0x7B    | div_rem     | Division remainder              |

## 📝 Algorithm Summary (Pseudocode)

```
x = 7, y = 11, N = 23
count = 0, array = []

while (x < N) OR (y < N):
    temp = x + y
    if temp is odd:
        array[count] = x * y
        x = x + 1
    else:
        array[count] = (x + y) / 3
        y = y + 3
    count++

sum = total(array[0..count-1])
PORTD = sum

// Button loop
index = 0
while true:
    wait_for_button_press()
    if index == 5:
        PORTD = sum
        index = 0
    else:
        PORTD = array[index]
        index++
```

## 📝 Notes

- **I/O Configuration:** `PORTB` is configured as input (button on RB2); `PORTD` is configured as output for LED display. `TRISB` / `TRISD` are set in Bank 1.
- **Memory Management:** Variable storage starts at `0x20`; the generated array is stored at `0x30`.
- **Bank Selection:** Memory bank switching is handled manually using `BSF`/`BCF` on `STATUS` register bits.
- **Verification:** All logic was verified using **PICSimLab** to confirm correct array generation, summation, and button-driven display cycling.
