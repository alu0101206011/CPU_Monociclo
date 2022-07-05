beq R14 R1 comprobation
beq R15 R1 readmode  # Modo leer 1
beq R15 R2 showmode  # Modo mostrar 2
j idel

comprobation:
li R14 0
beq R15 R1 savemode
reti

readmode: 
load R9 0xFFFC
load R8 0xFFFF          # Miramos si los leds están encendidos
beq R3 R8 turnoffgled
store R3 0xFFFF         # Si no encendemos
reti

savemode:
#beq R11 R5 errormem   # Si llegamos al maximo de la memoria no podemos guardar más
#storer R9 R11 0
#addi R11 R11 1
store R9 1
load R13 0xFFFF          # Miramos si los leds están encendidos
beq R12 R13 turnoffgled
store R12 0xFFFF         # Si no encendemos
reti


showmode:
#beq R11 R0 idel         # Si llegamos al minimo de la memoria no podemos mostrar más
#subi R11 R11 1
load R12 1
#load R8 0xFFFE          # Miramos si los leds están encendidos ROJO
#beq R9 R8 turnoffrled
store R12 0xFFFE         # Si no encendemos

load R10 0xFFFF          # Miramos si los leds están encendidos
beq R1 R10 turnoffgled
store R1 0xFFFF         # Si no encendemos
reti

idel:
store R0 0xFFFF
store R0 0xFFFE
reti

turnoffgled:
store R0 0xFFFF
reti

turnoffrled:
store R0 0xFFFE
reti

errormem:
li R1 0x3FF
store R1 0xFFFE
li R1 0xFF
store R1 0xFFFF
j errormem
