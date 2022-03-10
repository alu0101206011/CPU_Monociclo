LI R1 5
LI R2 1
loop: SUB R1 R1 R2
      Jz endloop
      J loop

subrutina:
      not R4 R2
      addi R3 R2 1
      jnz main

main: 
      LI R5 7 # El 7 de la victoria

endloop:
      jrel subrutina