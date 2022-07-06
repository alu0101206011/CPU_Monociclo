li R5 0xFFFB # dir_mem max
li R1 1
li R2 2
li R3 0xFF
li R11 1
li R12 0xAA             # 10101010 para mostrar que se leyó


start:
load R6 0xFFFD      # R3 = estado botones
nop
beq R6 R1 readstart # if botones = 1 salta a readstart
beq R6 R2 stopread  # if botones = 2 salta a stopread
li R4 4
beq R6 R4 showred   # if botones = 4 salta a showred
li R4 8
beq R6 R4 saveread  # if botones = 8 salta a showred
j start

readstart:
li R15 1
j start

stopread:
li R15 0
li R14 0
j start

showred:
li R15 2
j start

saveread:
li R14 1
j start