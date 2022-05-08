`timescale 1 ns / 10 ps

module timer #(parameter M = 8000000, WIDTH = 8) (input  wire clk, reset, //2500000 = 50 ms | 250000 = 5 ms | 25000 = 500 us | 50000 = 1 ms
                                                output wire[WIDTH-1:0] pulse);

localparam N = $clog2(M);
reg [N-1:0] count;
wire [N-1:0] count_next;

always@(posedge clk, posedge reset)
begin
	if(reset)
		count <= 0;
	else 
		count <= count_next;
end

assign count_next = (count == M-1) ? 0 : count + 1;
assign pulse = (count == M-1) ?  2**(WIDTH-1) : 0;

endmodule