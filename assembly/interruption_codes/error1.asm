# Encender leds rojos intercalados 682 = 1010101010 Error 
# Error en la pila
bucle:
nop
li R1 682
store R1 0xFFFE
j bucle