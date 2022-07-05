# encender y apagar led verde
li R15 0xFF
load R14 0xFFFF
#li R14 0
bne R14 R15 encender_leds_verdes

# apaga
store R0 0xFFFF
reti

encender_leds_verdes:
store R15 0xFFFF
#li R15 0xF0
#nop
#store R15 0xFFFF
#li R15 0x0F
#nop
#store R15 0xFFFF
reti