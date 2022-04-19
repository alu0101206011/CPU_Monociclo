
start:
load R1 0xFFFD # en principio 1110
subi R2 R1 14  # si es boton 1
jz boton1  

subi R2 R1 13 # si es boton 2 1101
jz boton2 

subi R2 R1 11 # si es boton 3 1011
jz boton1 

subi R2 R1 7 # si es boton 3 0111
jz boton1 

j start 

boton1:
load R2 0xFFFD # 1111
subi R2 R2 15
jnz start 


j start 

boton2:
load R2 0xFFFD # 1111
subi R2 R2 15
jnz start 
li R4 2
store R4 0xFFFE
j start 

apagarleds:
store R0 0xFFFE
j start

encenderleds:
store R1 0xFFFE
j start 