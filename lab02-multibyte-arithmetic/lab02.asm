#include <xc.inc>

;================ RESET VECTOR =================
PSECT resetVec, class=CODE, delta=2
resetVec:
    GOTO main


;================ VARIABLE DEFINITIONS =================
; BANK 0
templow  EQU     0x20
tempmid  EQU     0x21
temphigh EQU     0x22
counter  EQU     0x23

; BANK 1
xlow     EQU     0xA0
xmid     EQU     0xA1
xhigh    EQU     0xA2

; BANK 2
ylow     EQU     0x120
ymid     EQU     0x121
yhigh    EQU     0x122

; BANK 3
zlow     EQU     0x1A0
zmid     EQU     0x1A1
zhigh    EQU     0x1A2


;================ MAIN CODE =================
PSECT code, class=CODE, delta=2
main:

;----- PORTD OUTPUT -----
    BSF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    CLRF    TRISD

    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    CLRF    PORTD


;================ SET X =================
; x = 0x202020 (example student number)
    BSF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVLW   0x20
    MOVWF   xlow
    MOVLW   0x20
    MOVWF   xmid
    MOVLW   0x20
    MOVWF   xhigh


;================ SET Y =================
; y = 0x505050
    BCF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVLW   0x50
    MOVWF   ylow
    MOVLW   0x50
    MOVWF   ymid
    MOVLW   0x50
    MOVWF   yhigh


;================ z = 16 * x =================
; copy x -> z
    BSF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVF    xlow, W
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVWF   zlow

    BSF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVF    xmid, W
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVWF   zmid

    BSF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVF    xhigh, W
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVWF   zhigh


; shift left 4 times
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVLW   4
    MOVWF   counter

SHIFT_X_LOOP:
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    BCF     STATUS, STATUS_C_POSITION
    RLF     zlow, F
    RLF     zmid, F
    RLF     zhigh, F
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    DECFSZ  counter, F
    GOTO    SHIFT_X_LOOP


;================ temp = 8 * y =================
; copy y -> temp
    BCF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVF    ylow, W
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVWF   templow

    BCF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVF    ymid, W
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVWF   tempmid

    BCF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    MOVF    yhigh, W
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVWF   temphigh


; shift left 3 times
    MOVLW   3
    MOVWF   counter

SHIFT_Y_LOOP:
    BCF     STATUS, STATUS_C_POSITION
    RLF     templow, F
    RLF     tempmid, F
    RLF     temphigh, F
    DECFSZ  counter, F
    GOTO    SHIFT_Y_LOOP


;================ z = z + temp =================
; low byte
    MOVF    templow, W
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    ADDWF   zlow, F

; mid byte
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVF    tempmid, W
    BTFSC   STATUS, STATUS_C_POSITION
    ADDLW   1
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    ADDWF   zmid, F

; high byte
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVF    temphigh, W
    BTFSC   STATUS, STATUS_C_POSITION
    ADDLW   1
    BSF     STATUS, STATUS_RP0_POSITION
    BSF     STATUS, STATUS_RP1_POSITION
    ADDWF   zhigh, F


;================ OUTPUT =================
; show MSB on PORTD
    MOVF    zhigh, W
    BCF     STATUS, STATUS_RP0_POSITION
    BCF     STATUS, STATUS_RP1_POSITION
    MOVWF   PORTD


;================ ENDLESS LOOP =================
LOOP:
    GOTO LOOP

END
