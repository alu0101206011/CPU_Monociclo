# Encender leds rojos intercalados 992 = 1111100000 
# Error en la alu
bucle:
nop
li R1 992
store R1 0xFFFE 
j bucle