library ieee;
use ieee.std_logic_1164.all;

entity FSM_Reg_Despl is
	port (
			start_tx	:in std_logic;
			cont_ok	:in std_logic;
			clk		:in std_logic;
			reset_low:in std_logic;
			l_s		:out std_logic
			);
end FSM_Reg_Despl;

architecture behav of FSM_Reg_Despl is

	--Declaro los estados de la FSM.
	type FSM_states is (idle,load_shift,cont_down,finished);
	
	--Declaro las señales de la FSM.
	signal current_state, next_state : FSM_states;
	
	--Establezco el estilo de codificacion.
	attribute syn_encoding: string;
	attribute syn_encoding of FSM_States : type is "one hot";
	
begin 
	
	--Proceso de estado presente.
	cs_pr: process (clk,reset_low) 
	begin 
		if reset_low = '1' then 
			current_state <= idle;
		elsif (rising_edge(clk)) then 
			current_state <= next_state;
		end if;
	end process;
	
	--Proceso de proximo estado.
	nxp: process(current_state,start_tx,cont_ok)
	begin 
		case current_state is
		
			when idle => 
				if start_tx = '1' then 
					next_state <= load_shift;
				else 
					next_state <= idle;
				end if;
			
			when load_shift => 
				next_state <= cont_down;
			
			when cont_down =>
				if cont_ok = '1' then
					next_state <= finished;
				else 
					next_state <= cont_down;
				end if;
				
			when finished => 
				next_state <= idle;
				
		end case;
	end process;
	
	--Proceso de salida Moore.
	moore_pr: process (current_state)
	begin 
		l_s	<= '0';	--Valor por default.
		case current_state is 
			when idle => null;
			when load_shift => 
				l_s <= '1';
			when cont_down =>
				l_s <= '0';
			when finished => 
				l_s <= '0';
			when others => null;
		end case;
	end process;
	
end behav;