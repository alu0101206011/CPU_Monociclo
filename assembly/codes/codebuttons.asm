start:
load R1 0xFFFD
subi R1 R1 0
jnz nextstate 
j start 

nextstate:
load R2 0xFFFD
sub R3 R1 R2
jnz botones 
j start 

botones:
store R1 0xFFFE
j start 