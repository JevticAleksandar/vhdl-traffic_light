library ieee;
use ieee.std_logic_1164.all;

entity traffic_light is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;

        rc      : out std_logic;
        yc	: out std_logic;
        gc	: out std_logic;
        rp      : out std_logic;
        gp      : out std_logic;
        cd_time : out std_logic_vector(3 downto 0)
    );
end traffic_light;

architecture Behavioral of traffic_light is

    constant C_SECOND   : integer := 8;
    
    signal C_DURATION   : integer range 1 to 10;
    signal counter      : integer := 1;
    
    shared variable temp: integer := 0;
	
    type State is (st_redRed1, st_redGreen, st_redRed2, st_redYellowRed, st_greenRed, st_yellowRed);             
    signal state_reg, next_state : State;

begin
    STATE_TRANSITION: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= st_redRed1;
            elsif counter = 1 then
                state_reg <= next_state;
            else
                state_reg <= state_reg;
            end if;
        end if;
    end process STATE_TRANSITION;
	
    CNT_PROCESS: process(clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                counter <= 2 + 1;
            else
                if temp = C_SECOND then
                counter <= counter - 1;
                temp := 0;
                elsif counter = 1 then
                    counter <= C_DURATION;
                    temp := temp + 1;
                else
                    temp := temp + 1;
                end if;
            end if;
        end if;
    end process CNT_PROCESS;
	
    NEXT_STATE_LOGIC: process(state_reg)
    begin
        case state_reg is
            when st_redRed1      => next_state <= st_redGreen;     C_DURATION <= 7 + 1;
            when st_redGreen     => next_state <= st_redRed2;      C_DURATION <= 2 + 1;
            when st_redRed2      => next_state <= st_redYellowRed; C_DURATION <= 1 + 1;
            when st_redYellowRed => next_state <= st_greenRed;     C_DURATION <= 9 + 1;
            when st_greenRed     => next_state <= st_yellowRed;    C_DURATION <= 1 + 1;
            when st_yellowRed    => next_state <= st_redRed1;      C_DURATION <= 2 + 1;
        end case;
    end process NeXT_STATE_LOGIC;
	
    OUTPUT_LOGIC: process(state_reg, counter)
    begin
        case state_reg is
            when st_redRed1 =>
                rc <= '1';
                rp <= '1';
                yc <= '0';
                gc <= '0';
                gp <= '0';
                cd_time <= "1111";
            when st_redGreen =>
                rc <= '1';
                rp <= '0';
                yc <= '0';
                gc <= '0';
                gp <= '1';
                cd_time <= "1111";
            when st_redRed2 =>
                rc <= '1';
                rp <= '1';
                yc <= '0';
                gc <= '0';
                gp <= '0';
                cd_time <= "1111";
            when st_redYellowRed =>
                rc <= '1';
                rp <= '1';
                yc <= '1';
                gc <= '0';
                gp <= '0';
                cd_time <= "1111";
            when st_greenRed =>
                rc <= '0';
                rp <= '1';
                yc <= '0';
                gc <= '1';
                gp <= '0';
                case counter is
                    when 10 => cd_time <= "1001";
                    when 9  => cd_time <= "1000";
                    when 8  => cd_time <= "0111";
                    when 7  => cd_time <= "0110";
                    when 6  => cd_time <= "0101";
                    when 5  => cd_time <= "0100";
                    when 4  => cd_time <= "0011";
                    when 3  => cd_time <= "0010";
                    when 2  => cd_time <= "0001";
                    when others => cd_time <= "1111";
                end case;
            when st_yellowRed =>
                rc <= '0';
                rp <= '1';
                yc <= '1';
                gc <= '0';
                gp <= '0';
                cd_time <= "1111";
        end case;
    end process OUTPUT_LOGIC;
end Behavioral;
