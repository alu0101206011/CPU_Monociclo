LI R1 5
LI R2 1
loop: SUB R1 R1 R2
      jz endloop
      j loop

otraetiqueta:
      c2i R4 0
      addi R3 R2 1
      jnz main

main: 
      LI R5 7 # El 7 de la victoria

endloop:
      jrel otraetiqueta