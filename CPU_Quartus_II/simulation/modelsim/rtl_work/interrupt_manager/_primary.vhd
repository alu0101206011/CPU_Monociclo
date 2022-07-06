library verilog;
use verilog.vl_types.all;
entity interrupt_manager is
    generic(
        WIDTH           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        int_e           : in     vl_logic_vector;
        s_calli         : in     vl_logic_vector;
        s_reti          : in     vl_logic_vector;
        s_interr        : out    vl_logic;
        min_bit_s       : out    vl_logic_vector;
        min_bit_a       : out    vl_logic_vector;
        int_a           : out    vl_logic_vector;
        int_s           : out    vl_logic_vector;
        data_a          : out    vl_logic_vector;
        data_s          : out    vl_logic_vector;
        addr            : out    vl_logic_vector(9 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end interrupt_manager;
