jcall pepe
li r7 -32768
subi r3 r7 1
c2i r4 1
c2 r5 r7
jne end2
j end

pepe: jcall anabel
li r1 1
jret

anabel:
li r2 2
jret

end:
nop
j end

end2:
li r8 8
j end