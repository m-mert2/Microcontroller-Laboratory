#include <xc.inc>

;================ CONFIGURATION ================
CONFIG FOSC = XT
CONFIG WDTE = OFF
CONFIG PWRTE = ON
CONFIG CP = OFF

;================ RAM DEFINITIONS ================
BLOCK_VAR   EQU 0x20
loop_cnt    EQU 0x21 
ARRAY_BASE  EQU 0x30 ; Array starts here

; Delay counters
d1          EQU 0x70
d2          EQU 0x71
d3          EQU 0x72

;================ START VECTORS ================
PSECT resetVec, class=CODE, delta=2
ORG 0x00
    GOTO    MAIN

;================ MAIN LOGIC ====================
PSECT code, class=CODE, delta=2
MAIN:
    ; --- Basic I/O setup ---
    BSF     STATUS, 5   ; Switch to Bank 1
    CLRF    TRISD       ; Set PORTD as all outputs
    BCF     STATUS, 5   ; Back to Bank 0
    CLRF    PORTD       ; Clear LEDs initially

    ; --- Populate Array: A[i] = 2^i ---
    MOVLW   ARRAY_BASE
    MOVWF   FSR         ; Pointer to start of array
    MOVLW   1
    MOVWF   INDF        ; First element is 2^0 = 1
    
    MOVLW   7           ; Need 7 more values
    MOVWF   loop_cnt    
FILL_LOOP:
    BCF     STATUS, 0   ; Clear carry before shifting
    RLF     INDF, W     ; Multiply previous value by 2
    INCF    FSR, F      ; Move to next RAM address
    MOVWF   INDF        ; Store the new power of 2
    DECFSZ  loop_cnt, F
    GOTO    FILL_LOOP

; ==============================================
;           LED SCANNING SEQUENCE
; ==============================================
MAIN_LOOP:
    ; --- STEP 1: Far Right LED (Bit 0) ---
    MOVLW   ARRAY_BASE  ; Reset pointer to 0x30
    MOVWF   FSR
    MOVF    INDF, W
    MOVWF   PORTD
    CALL    Delay500ms  ; Hold at the corner (per lab manual)

    ; --- STEP 2: Move Left (Bit 1 to 6) ---
    MOVLW   6           
    MOVWF   loop_cnt
FORWARD_LOOP:
    INCF    FSR, F      ; Point to next LED value
    MOVF    INDF, W
    MOVWF   PORTD
    CALL    Delay200ms  ; Normal transition speed
    DECFSZ  loop_cnt, F
    GOTO    FORWARD_LOOP

    ; --- STEP 3: Far Left LED (Bit 7) ---
    INCF    FSR, F      ; Final array address (0x37)
    MOVF    INDF, W
    MOVWF   PORTD
    CALL    Delay500ms  ; Hold at the other corner

    ; --- STEP 4: Move Right (Bit 6 to 1) ---
    MOVLW   6   
    MOVWF   loop_cnt
BACKWARD_LOOP:
    DECF    FSR, F      ; Go back one address
    MOVF    INDF, W
    MOVWF   PORTD
    CALL    Delay200ms  ; Normal transition speed
    DECFSZ  loop_cnt, F
    GOTO    BACKWARD_LOOP

    GOTO    MAIN_LOOP   ; Repeat forever


; ==============================================
;                DELAY ROUTINES
; ==============================================

; Approx 200ms delay for 4MHz clock
Delay200ms:
    MOVLW   2
    MOVWF   d3
D200_L:
    MOVLW   200
    MOVWF   d2
D200_L2:
    MOVLW   165
    MOVWF   d1
D200_L3:
    DECFSZ  d1, F
    GOTO    D200_L3
    DECFSZ  d2, F
    GOTO    D200_L2
    DECFSZ  d3, F
    GOTO    D200_L
    RETURN

; Approx 500ms delay for 4MHz clock
Delay500ms:
    MOVLW   5           
    MOVWF   d3
D500_L:
    MOVLW   200
    MOVWF   d2
D500_L2:
    MOVLW   165
    MOVWF   d1
D500_L3:
    DECFSZ  d1, F
    GOTO    D500_L3
    DECFSZ  d2, F
    GOTO    D500_L2
    DECFSZ  d3, F
    GOTO    D500_L
    RETURN

END
