jcall pepe
li r7 32767
addi r3 r7 32767
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