# Encender leds rojos intercalados 992 = 1111100000 
bucle:
nop
li R1 992
store R1 0xFFFE 
j bucle