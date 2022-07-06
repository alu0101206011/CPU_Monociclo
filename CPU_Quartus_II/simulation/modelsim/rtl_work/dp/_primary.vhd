library verilog;
use verilog.vl_types.all;
entity dp is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        s_rel           : in     vl_logic;
        s_inm           : in     vl_logic;
        s_stack         : in     vl_logic;
        s_data          : in     vl_logic;
        we3             : in     vl_logic;
        wez             : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        oe              : in     vl_logic;
        s_inc           : in     vl_logic_vector(1 downto 0);
        op_alu          : in     vl_logic_vector(2 downto 0);
        data_inout      : inout  vl_logic_vector(15 downto 0);
        int_e           : in     vl_logic_vector(7 downto 0);
        s_calli         : in     vl_logic_vector(7 downto 0);
        s_reti          : in     vl_logic_vector(7 downto 0);
        z               : out    vl_logic;
        c               : out    vl_logic;
        overflow_ALU    : out    vl_logic;
        overflow_Stack  : out    vl_logic;
        opcode          : out    vl_logic_vector(7 downto 0);
        min_bit_a       : out    vl_logic_vector(7 downto 0);
        min_bit_s       : out    vl_logic_vector(7 downto 0);
        int_a           : out    vl_logic_vector(7 downto 0);
        addresses       : out    vl_logic_vector(15 downto 0);
        program_counter : out    vl_logic_vector(9 downto 0);
        out_stack       : out    vl_logic_vector(9 downto 0)
    );
end dp;
