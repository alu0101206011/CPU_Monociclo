library verilog;
use verilog.vl_types.all;
entity transceiver is
    generic(
        WIDTH           : integer := 16
    );
    port(
        oe              : in     vl_logic;
        \in\            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector;
        bidir           : inout  vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end transceiver;
