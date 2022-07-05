# Encender leds rojos 992 = 1111100000 
# Error en la overflow alu
bucle:
nop
li R1 992
store R1 0xFFFE 
j bucle