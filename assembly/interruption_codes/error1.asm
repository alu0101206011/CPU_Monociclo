# Encender leds rojos intercalados 682 = 1010101010 Error 
bucle:
nop
li R1 682
store R1 0xFFFE
j bucle