li R5 0xFFFB # dir_mem max
li R1 1
li R2 2
li R5 4
li R3 0xFF
li R4 4



start:
load R6 0xFFFD      # R3 = estado botones
nop
beq R6 R1 readstart # if botones = 1 salta a readstart
beq R6 R2 stopread  # if botones = 2 salta a stopread
beq R6 R5 showred   # if botones = 3 salta a showred
j start

readstart:
li R15 1
j start

stopread:
li R15 0
j start

showred:
li R15 2
j start


