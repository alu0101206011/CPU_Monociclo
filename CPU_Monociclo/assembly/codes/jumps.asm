li R1 6
li R2 2

bgt R1 R2 victoria

infiniteloop:
  nop
jrel infiniteloop


victoria:
li R7 7
j infiniteloop