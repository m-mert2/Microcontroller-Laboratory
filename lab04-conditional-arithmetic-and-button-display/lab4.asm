#include <xc.inc>

PSECT resetVec, class=CODE, delta=2
ORG 0x00

BSF     STATUS, STATUS_RP0_POSITION
MOVLW   0xFF
MOVWF   TRISB
CLRF    TRISD
BCF     STATUS, STATUS_RP0_POSITION
CLRF    PORTD
GOTO    main

arg1            EQU 0x70
arg2            EQU 0x71
math_temp       EQU 0x74 
mul_res_L       EQU 0x78
mul_res_H       EQU 0x79
loop_i          EQU 0x7A
div_rem         EQU 0x7B

x               EQU 0x20
y               EQU 0x21
N               EQU 0x22
count           EQU 0x23
sum             EQU 0x24
array_index     EQU 0x27

ARRAY_START     EQU 0x30 

Multiply:
    CLRF mul_res_H
    CLRF mul_res_L
    MOVLW 8
    MOVWF loop_i
    MOVF  arg1, W   
Mul_BitLoop:
    RRF   arg2, F   
    BTFSS STATUS, STATUS_C_POSITION
    GOTO  Mul_SkipAdd
    ADDWF mul_res_H, F 
Mul_SkipAdd:
    RRF   mul_res_H, F 
    RRF   mul_res_L, F
    DECFSZ loop_i, F
    GOTO  Mul_BitLoop
    BCF     STATUS, STATUS_C_POSITION
    RLF     mul_res_L, W    
    ADDWF   mul_res_H, W    
    RETURN

GenerateNumbers:
    MOVLW   0               
    MOVWF   count
    MOVLW   ARRAY_START
    MOVWF   FSR             

Gen_WhileLoop:
    MOVF    N, W
    SUBWF   x, W            
    BTFSS   STATUS, STATUS_C_POSITION 
    GOTO    Gen_LoopBody    
    MOVF    N, W
    SUBWF   y, W            
    BTFSS   STATUS, STATUS_C_POSITION 
    GOTO    Gen_LoopBody    
    GOTO    Gen_End         

Gen_LoopBody:
    MOVF    x, W
    ADDWF   y, W
    MOVWF   math_temp       
    BTFSS   math_temp, 0    
    GOTO    Gen_Else        

    MOVF    x, W
    MOVWF   arg1
    MOVF    y, W
    MOVWF   arg2
    CALL    Multiply        
    MOVWF   INDF            
    INCF    count, F        
    INCF    FSR, F          
    INCF    x, F            
    GOTO    Gen_WhileLoop

Gen_Else:
    MOVF    math_temp, W    
    MOVWF   div_rem
    CLRF    math_temp       
Div_Loop:
    MOVLW   3
    SUBWF   div_rem, W      
    BTFSS   STATUS, STATUS_C_POSITION 
    GOTO    Div_Done
    MOVWF   div_rem         
    INCF    math_temp, F    
    GOTO    Div_Loop
Div_Done:
    MOVF    math_temp, W    
    MOVWF   INDF            
    INCF    count, F        
    INCF    FSR, F          
    MOVLW   3
    ADDWF   y, F
    GOTO    Gen_WhileLoop

Gen_End:
    MOVF    count, W        
    RETURN

AddNumbers:
    CLRF    sum             
    MOVLW   ARRAY_START
    MOVWF   FSR             
    MOVF    arg2, W         
    MOVWF   loop_i          
Add_Loop:
    MOVF    loop_i, F       
    BTFSC   STATUS, STATUS_Z_POSITION
    GOTO    Add_End         
    MOVF    INDF, W         
    ADDWF   sum, F          
    INCF    FSR, F          
    DECF    loop_i, F       
    GOTO    Add_Loop
Add_End:
    MOVF    sum, W          
    RETURN

main:
    MOVLW   7
    MOVWF   x
    MOVLW   11
    MOVWF   y
    MOVLW   23
    MOVWF   N
    
    CALL    GenerateNumbers
    MOVWF   count           
    
    MOVF    count, W
    MOVWF   arg2            
    CALL    AddNumbers
    MOVWF   sum             

    MOVF    sum, W
    MOVWF   PORTD
    
    CLRF    array_index     

Main_Infinite_Loop:
    
Wait_RB3_Press:
    BTFSC   PORTB, 2
    GOTO    Wait_RB3_Press

Wait_RB3_Release:
    BTFSS   PORTB, 2
    GOTO    Wait_RB3_Release
    
    MOVLW   5
    SUBWF   array_index, W
    
    BTFSC   STATUS, STATUS_Z_POSITION
    GOTO    Reset_To_Sum

Show_Next_Array_Element:
    MOVLW   ARRAY_START
    ADDWF   array_index, W
    MOVWF   FSR
    
    MOVF    INDF, W
    MOVWF   PORTD
    
    INCF    array_index, F
    GOTO    Main_Infinite_Loop

Reset_To_Sum:
    MOVF    sum, W
    MOVWF   PORTD
    CLRF    array_index
    GOTO    Main_Infinite_Loop

END