library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_system is
    port(
        clk 	: in std_logic;
        reset 	: in std_logic;
        
        rc		: out std_logic;
        yc		: out std_logic;
        gc		: out std_logic;
        rp		: out std_logic;
        gp		: out std_logic;
        display	: out std_logic_vector(6 downto 0)
    );
end traffic_light_system;

architecture Structure of traffic_light_system is

    component traffic_light is
        port(
            clk     : in  std_logic;
            reset   : in  std_logic;

            rc		: out std_logic;
            yc		: out std_logic;
            gc		: out std_logic;
            rp		: out std_logic;
            gp		: out std_logic;
            cd_time	: out std_logic_vector(3 downto 0)
        );
    end component;
	
    component bcd_to_7seg is
        port(
            digit   : in    std_logic_vector(3 downto 0);
            display : out   std_logic_vector(6 downto 0)
        );
    end component;
	
    signal connection_traffic_light_with_bcd_to_7seg : std_logic_vector(3 downto 0);

begin
    TRAFFIC_LIGHTT: traffic_light port map(	
                                            clk => clk, 
                                            reset => reset, 
                                            rc => rc,
                                            yc => yc,
                                            gc => gc,
                                            rp => rp,
                                            gp => gp,
                                            cd_time => connection_traffic_light_with_bcd_to_7seg
                                        );
													
    BCD_TO_7SEGG: bcd_to_7seg port map(
                                        digit => connection_traffic_light_with_bcd_to_7seg,
                                        display => display
                                    );
end Structure;