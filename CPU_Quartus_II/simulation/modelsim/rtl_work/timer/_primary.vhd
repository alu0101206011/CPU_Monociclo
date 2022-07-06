library verilog;
use verilog.vl_types.all;
entity timer is
    generic(
        M               : integer := 8000000;
        WIDTH           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        pulse           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of M : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end timer;
