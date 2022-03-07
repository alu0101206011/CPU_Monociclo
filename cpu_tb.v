`timescale 1 ns / 10 ps

module cpu_tb;


reg clk, reset;
integer idx;

// generación de reloj clk
always //siempre activo, no hay condición de activación
begin
  clk = 1'b1;
  #30;
  clk = 1'b0;
  #30;
end

// instanciación del procesador
cpu cpumono(clk, reset);

initial
begin
  $dumpfile("cpu_tb.vcd");
  $dumpvars;
  for (idx = 1; idx < 4; idx = idx + 1) $dumpvars(0,cpu_tb.cpumono.camino_datos.banco_registros.regb[idx]);  
  reset = 1;  //a partir del flanco de subida del reset empieza el funcionamiento normal
  #10;
  reset = 0;  //bajamos el reset 
end

initial
begin

  #(12*60);  //Esperamos 12 ciclos o 12 instrucciones
  $write("%d + %d = %d\n", cpu_tb.cpumono.camino_datos.banco_registros.regb[1], cpu_tb.cpumono.camino_datos.banco_registros.regb[2], cpu_tb.cpumono.camino_datos.banco_registros.regb[3]);
  $finish;
end

endmodule