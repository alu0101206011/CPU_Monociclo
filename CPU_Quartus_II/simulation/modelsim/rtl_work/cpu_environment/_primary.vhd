library verilog;
use verilog.vl_types.all;
entity cpu_environment is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        switches        : in     vl_logic_vector(8 downto 0);
        buttons         : in     vl_logic_vector(3 downto 0);
        led_r           : out    vl_logic_vector(9 downto 0);
        led_g           : out    vl_logic_vector(7 downto 0);
        addresses       : out    vl_logic_vector(17 downto 0);
        control_mem     : out    vl_logic_vector(4 downto 0);
        data            : inout  vl_logic_vector(15 downto 0)
    );
end cpu_environment;
