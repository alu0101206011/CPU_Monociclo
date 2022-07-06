library verilog;
use verilog.vl_types.all;
entity request_manager is
    generic(
        WIDTH           : integer := 8
    );
    port(
        int_e           : in     vl_logic_vector;
        int_s           : in     vl_logic_vector;
        s_reti          : in     vl_logic_vector;
        data_s          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end request_manager;
