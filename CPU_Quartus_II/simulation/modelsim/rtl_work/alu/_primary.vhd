library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        WIDTH           : integer := 16
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        s_inm           : in     vl_logic;
        interruption    : in     vl_logic;
        op_alu          : in     vl_logic_vector(2 downto 0);
        y               : out    vl_logic_vector;
        carry           : out    vl_logic;
        carry_intr      : out    vl_logic;
        overflow        : out    vl_logic;
        zero            : out    vl_logic;
        zero_intr       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WIDTH : constant is 1;
end alu;
