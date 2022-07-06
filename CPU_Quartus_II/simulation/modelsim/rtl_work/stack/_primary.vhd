library verilog;
use verilog.vl_types.all;
entity stack is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        interrupt       : in     vl_logic;
        pc_addr         : in     vl_logic_vector(9 downto 0);
        \out\           : out    vl_logic_vector(9 downto 0);
        underflow       : out    vl_logic;
        overflow        : out    vl_logic
    );
end stack;
