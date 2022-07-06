library verilog;
use verilog.vl_types.all;
entity cu is
    generic(
        NEW_INTER       : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0);
        ERROR_INTER     : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0);
        ALU_R           : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        ALU_I           : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        LOAD            : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        LOADR           : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        STORE           : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        STORER          : vl_logic_vector(0 to 10) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        AB_JUMP         : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        REL_JUMP        : vl_logic_vector(0 to 10) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        NOP             : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        CALL            : vl_logic_vector(0 to 10) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        \RETURN\        : vl_logic_vector(0 to 10) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0)
    );
    port(
        opcode          : in     vl_logic_vector(7 downto 0);
        z               : in     vl_logic;
        c               : in     vl_logic;
        overflow_ALU    : in     vl_logic;
        overflow_Stack  : in     vl_logic;
        min_bit_s       : in     vl_logic_vector(7 downto 0);
        min_bit_a       : in     vl_logic_vector(7 downto 0);
        int_a           : in     vl_logic_vector(7 downto 0);
        s_rel           : out    vl_logic;
        s_inm           : out    vl_logic;
        s_stack         : out    vl_logic;
        s_data          : out    vl_logic;
        we3             : out    vl_logic;
        wez             : out    vl_logic;
        push            : out    vl_logic;
        pop             : out    vl_logic;
        oe              : out    vl_logic;
        s_inc           : out    vl_logic_vector(1 downto 0);
        op_alu          : out    vl_logic_vector(2 downto 0);
        s_calli         : out    vl_logic_vector(7 downto 0);
        s_reti          : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NEW_INTER : constant is 1;
    attribute mti_svvh_generic_type of ERROR_INTER : constant is 1;
    attribute mti_svvh_generic_type of ALU_R : constant is 1;
    attribute mti_svvh_generic_type of ALU_I : constant is 1;
    attribute mti_svvh_generic_type of LOAD : constant is 1;
    attribute mti_svvh_generic_type of LOADR : constant is 1;
    attribute mti_svvh_generic_type of STORE : constant is 1;
    attribute mti_svvh_generic_type of STORER : constant is 1;
    attribute mti_svvh_generic_type of AB_JUMP : constant is 1;
    attribute mti_svvh_generic_type of REL_JUMP : constant is 1;
    attribute mti_svvh_generic_type of NOP : constant is 1;
    attribute mti_svvh_generic_type of CALL : constant is 1;
    attribute mti_svvh_generic_type of \RETURN\ : constant is 1;
end cu;
