library verilog;
use verilog.vl_types.all;
entity i_o_manager is
    generic(
        LED_RED         : vl_logic_vector(0 to 6) := (Hi1, Hi0, HiX, Hi1, HiX, HiX, HiX);
        LED_GREEN       : vl_logic_vector(0 to 6) := (Hi0, Hi1, HiX, Hi1, HiX, HiX, HiX);
        NOP             : vl_logic_vector(0 to 6) := (Hi0, Hi0, HiX, Hi1, HiX, HiX, HiX);
        MEMORY_STORE    : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, HiX, Hi0, Hi0);
        MEMORY_LOAD     : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        oe              : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        buttons         : in     vl_logic_vector(3 downto 0);
        switches        : in     vl_logic_vector(8 downto 0);
        led_g           : out    vl_logic_vector(7 downto 0);
        control_mem     : out    vl_logic_vector(4 downto 0);
        data            : inout  vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LED_RED : constant is 1;
    attribute mti_svvh_generic_type of LED_GREEN : constant is 1;
    attribute mti_svvh_generic_type of NOP : constant is 1;
    attribute mti_svvh_generic_type of MEMORY_STORE : constant is 1;
    attribute mti_svvh_generic_type of MEMORY_LOAD : constant is 1;
end i_o_manager;
