	component lab61_soc is
		port (
			clk_clk          : in    std_logic                     := 'X';             -- clk
			led_wire_export  : out   std_logic_vector(7 downto 0);                     -- export
			reset_reset_n    : in    std_logic                     := 'X';             -- reset_n
			sdram_wire_addr  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n : out   std_logic;                                        -- cas_n
			sdram_wire_cke   : out   std_logic;                                        -- cke
			sdram_wire_cs_n  : out   std_logic;                                        -- cs_n
			sdram_wire_dq    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm   : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n : out   std_logic;                                        -- ras_n
			sdram_wire_we_n  : out   std_logic;                                        -- we_n
			sw_wire_export   : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			acc_wire_export  : in    std_logic                     := 'X';             -- export
			sdram_clk_clk    : out   std_logic                                         -- clk
		);
	end component lab61_soc;

	u0 : component lab61_soc
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --        clk.clk
			led_wire_export  => CONNECTED_TO_led_wire_export,  --   led_wire.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --      reset.reset_n
			sdram_wire_addr  => CONNECTED_TO_sdram_wire_addr,  -- sdram_wire.addr
			sdram_wire_ba    => CONNECTED_TO_sdram_wire_ba,    --           .ba
			sdram_wire_cas_n => CONNECTED_TO_sdram_wire_cas_n, --           .cas_n
			sdram_wire_cke   => CONNECTED_TO_sdram_wire_cke,   --           .cke
			sdram_wire_cs_n  => CONNECTED_TO_sdram_wire_cs_n,  --           .cs_n
			sdram_wire_dq    => CONNECTED_TO_sdram_wire_dq,    --           .dq
			sdram_wire_dqm   => CONNECTED_TO_sdram_wire_dqm,   --           .dqm
			sdram_wire_ras_n => CONNECTED_TO_sdram_wire_ras_n, --           .ras_n
			sdram_wire_we_n  => CONNECTED_TO_sdram_wire_we_n,  --           .we_n
			sw_wire_export   => CONNECTED_TO_sw_wire_export,   --    sw_wire.export
			acc_wire_export  => CONNECTED_TO_acc_wire_export,  --   acc_wire.export
			sdram_clk_clk    => CONNECTED_TO_sdram_clk_clk     --  sdram_clk.clk
		);

