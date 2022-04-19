subi R2 R1 1
jz detection
li R2 1
# Si led encendido apagalo

# Si no enciende
store R0 0xFFFE
store R2 0xFFFF
reti

detection:
li R2 1 
store R2 0xFFFE
store R0 0xFFFF
reti