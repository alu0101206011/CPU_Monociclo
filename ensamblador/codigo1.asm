j main
pepe:  addi R1 R1 2
jcall jaime
jret 
j main  # No se ejecuta nunca
jaime2: addi R8 R8 4
jret
main: addi R2 R2 1
jcall pepe
j end
end: addi R7 R7 7 # 7 de la victoria
end2: nop
j end2
jaime: addi R6 R6 3
jcall jaime2
jret