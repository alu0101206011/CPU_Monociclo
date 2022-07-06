library verilog;
use verilog.vl_types.all;
entity regfile is
    generic(
        REG_SEL         : integer := 4;
        WIDTH           : integer := 16
    );
    port(
        clk             : in     vl_logic;
        we3             : in     vl_logic;
        ra1             : in     vl_logic_vector;
        ra2             : in     vl_logic_vector;
        wa3             : in     vl_logic_vector;
        wd3             : in     vl_logic_vector;
        rd1             : out    vl_logic_vector;
        rd2             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of REG_SEL : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end regfile;
