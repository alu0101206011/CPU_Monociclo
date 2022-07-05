beq R15 R1 readmode  # Modo leer 1
beq R15 R2 showmode  # Modo mostrar 2
j idel

readmode: 
load R9 0xFFFC
load R8 0xFFFF          # Miramos si los leds están encendidos
beq R3 R8 turnoffgled
store R3 0xFFFF         # Si no encendemos
reti

showmode:
load R8 0xFFFE          # Miramos si los leds están encendidos ROJO
beq R9 R8 turnoffrled
store R9 0xFFFE         # Si no encendemos
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