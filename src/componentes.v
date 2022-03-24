`timescale 1 ns / 10 ps
//Componentes varios

//Banco de registros de dos salidas y una entrada
module regfile(input  wire        clk, 
               input  wire        we3,           //se�al de habilitaci�n de escritura
               input  wire [3:0]  ra1, ra2, wa3, //direcciones de regs leidos y reg a escribir
               input  wire [15:0]  wd3, 			 //dato a escribir
               output wire [15:0]  rd1, rd2);     //datos leidos

  reg [15:0] regb[0:15]; //memoria de 16 registros de 16 bits de ancho

  initial
  begin
    $readmemb("regfile.dat",regb); // inicializa los registros a valores conocidos
  end  
  
  // El registro 0 siempre es cero
  // se leen dos reg combinacionalmente
  // y la escritura del tercero ocurre en flanco de subida del reloj
  
  always @(posedge clk)
    if (we3) regb[wa3] <= wd3;	
  
  assign rd1 = (ra1 != 0) ? regb[ra1] : 0;
  assign rd2 = (ra2 != 0) ? regb[ra2] : 0;


endmodule

//modulo sumador  
module sum(input wire signed [9:0] a, b, output wire [9:0] y);

  assign y = a + b;

endmodule

//modulo registro para modelar el PC, cambia en cada flanco de subida de reloj o de reset
module registro #(parameter WIDTH = 8)
              (input wire             clk, reset,
               input wire [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;

endmodule

//modulo multiplexor, si s=1 sale d1, s=0 sale d0
module mux2 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] d0, d1, 
              input  wire             s, 
              output wire [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 

endmodule

//modulo multiplexor, si s=1 sale d1, s=0 sale d0
module mux4 #(parameter WIDTH = 8)
             (input  wire [WIDTH-1:0] d0, d1, d3, d4,
              input  wire [1:0] s, 
              output wire [WIDTH-1:0] y);

  assign y = s == 2'b00 ? d0 : s == 2'b01 ? d1 : s == 2'b10 ? d3 : d4; 

endmodule


//Biestable para el flag de cero
//Biestable tipo D s�ncrono con reset as�ncrono por flanco y entrada de habilitaci�n de carga
module ffd(input wire clk, reset, d, carga, output reg q);

  always @(posedge clk, posedge reset)
    if (reset)
	    q <= 1'b0;
	  else
	    if (carga)
	      q <= d;

endmodule 

module max_bit #(parameter WIDTH = 8) (input wire [WIDTH-1:0] a, output reg [WIDTH-1:0] b);

  initial
    b <= 0;

  integer i;
  always @(a)
  begin
    for (i = WIDTH - 1; i >= 0; i = i - 1)
    begin
      if (i == WIDTH - 1)
        b = 0; 
      if (a[i])
      begin
        b[i] = 1'b1;
        i = 0;
      end
      else
        b[i] = 1'b0;
    end
  end

endmodule
    