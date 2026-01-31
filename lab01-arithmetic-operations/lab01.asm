#include <xc.inc>

; =================================================
; PIC16F877A – MICRO LAB
; Tested on PICSimLab, 8-bit arithmetic
; =================================================

; ===== RAM MAP (BANK0: 0x20–0x7F) =====
x       EQU 0x20
y       EQU 0x21
z       EQU 0x22
r1      EQU 0x23
r2      EQU 0x24
r3      EQU 0x25
r4      EQU 0x26
r       EQU 0x27
temp    EQU 0x28
temp2   EQU 0x29
counter EQU 0x2A

; ===== RESET VECTOR =====
PSECT resetVec, class=CODE, delta=2
resetVec:
    GOTO main

; ===== PROGRAM CODE =====
PSECT code, class=CODE, delta=2

main:
    ; ---- PORTD output (LED) ----
    BANKSEL TRISD
    CLRF TRISD
    BANKSEL PORTD
    CLRF PORTD

    ; ---- Initial values ----
    MOVLW 9
    MOVWF x
    MOVLW 10
    MOVWF y
    MOVLW 11
    MOVWF z

; =================================================
; r1 = (5*x - 2*y + z - 3)
; =================================================
    CLRF temp
    MOVLW 5
    MOVWF counter
r1_loop1:
    MOVF x, W
    ADDWF temp, F
    DECFSZ counter, F
    GOTO r1_loop1

    MOVF y, W
    ADDWF y, W
    SUBWF temp, F

    MOVF z, W
    ADDWF temp, F

    MOVLW 3
    SUBWF temp, F

    MOVF temp, W
    MOVWF r1

; =================================================
; r2 = (x+5)*4 - 3*y + z
; =================================================
    MOVLW 5
    ADDWF x, W
    MOVWF temp

    CLRF temp2
    MOVLW 4
    MOVWF counter
r2_loop1:
    MOVF temp, W
    ADDWF temp2, F
    DECFSZ counter, F
    GOTO r2_loop1

    CLRF temp
    MOVLW 3
    MOVWF counter
r2_loop2:
    MOVF y, W
    ADDWF temp, F
    DECFSZ counter, F
    GOTO r2_loop2

    MOVF temp, W
    SUBWF temp2, F

    MOVF z, W
    ADDWF temp2, F

    MOVF temp2, W
    MOVWF r2

; =================================================
; r3 = x/2 + y/2 + z/4
; =================================================
    CLRF temp

    MOVF x, W
    MOVWF temp2
    BCF STATUS, 0
    RRF temp2, F
    MOVF temp2, W
    ADDWF temp, F

    MOVF y, W
    MOVWF temp2
    BCF STATUS, 0
    RRF temp2, F
    MOVF temp2, W
    ADDWF temp, F

    MOVF z, W
    MOVWF temp2
    BCF STATUS, 0
    RRF temp2, F
    BCF STATUS, 0
    RRF temp2, F
    MOVF temp2, W
    ADDWF temp, F

    MOVF temp, W
    MOVWF r3

; =================================================
; r4 = (3*x - y - 3*z)*2 - 30
; =================================================
    CLRF temp
    MOVLW 3
    MOVWF counter
r4_loop1:
    MOVF x, W
    ADDWF temp, F
    DECFSZ counter, F
    GOTO r4_loop1

    MOVF y, W
    SUBWF temp, F

    CLRF temp2
    MOVLW 3
    MOVWF counter
r4_loop2:
    MOVF z, W
    ADDWF temp2, F
    DECFSZ counter, F
    GOTO r4_loop2

    MOVF temp2, W
    SUBWF temp, F

    BCF STATUS, 0
    RLF temp, F

    MOVLW 30
    SUBWF temp, F

    MOVF temp, W
    MOVWF r4

; =================================================
; r = 3*r1 + 2*r2 - r3/2 - r4
; =================================================
    CLRF r

    CLRF temp
    MOVLW 3
    MOVWF counter
r_loop1:
    MOVF r1, W
    ADDWF temp, F
    DECFSZ counter, F
    GOTO r_loop1
    MOVF temp, W
    ADDWF r, F

    MOVF r2, W
    ADDWF r2, W
    ADDWF r, F

    MOVF r3, W
    MOVWF temp2
    BCF STATUS, 0
    RRF temp2, F
    MOVF temp2, W
    SUBWF r, F

    MOVF r4, W
    SUBWF r, F

; ===== OUTPUT RESULT =====
    MOVF r, W
    MOVWF PORTD

; ===== INFINITE LOOP =====
LOOP:
    GOTO LOOP

END
