-- This file is part of the ethernet_mac_test project.
--
-- For the full copyright and license information, please read the
-- LICENSE.md file that was distributed with this source code.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ethernet_mac;
use ethernet_mac.ethernet_types.all;

entity ethernet_mac_test is
	port(
		clock_125_i    : in    std_ulogic;

		phy_reset_o    : out   std_ulogic;
		mdc_o          : out   std_ulogic;
		mdio_io        : inout std_ulogic;

		mii_tx_clk_i   : in    std_ulogic;
		mii_tx_er_o    : out   std_ulogic;
		mii_tx_en_o    : out   std_ulogic;
		mii_txd_o      : out   std_ulogic_vector(7 downto 0);
		mii_rx_clk_i   : in    std_ulogic;
		mii_rx_er_i    : in    std_ulogic;
		mii_rx_dv_i    : in    std_ulogic;
		mii_rxd_i      : in    std_ulogic_vector(7 downto 0);
		gmii_gtx_clk_o : out   std_ulogic;

		led_o          : out   std_ulogic_vector(3 downto 0);
		user_led_o     : out   std_ulogic_vector(1 downto 0)
	);
end entity;

architecture rtl of ethernet_mac_test is
	signal clock      : std_ulogic;
	signal clock_inv  : std_ulogic;
	signal dcm_locked : std_ulogic;
	signal reset      : std_ulogic;

	signal speed          : t_ethernet_speed;
	signal speed_detected : t_ethernet_speed;
	signal link_up        : std_ulogic;

	signal rx_empty         : std_ulogic;
	signal rx_rd_en         : std_ulogic;
	signal rx_data          : t_ethernet_data;
	signal clock_unbuffered : std_ulogic;

	signal copy_reset : std_ulogic;

	signal tx_data  : t_ethernet_data;
	signal tx_wr_en : std_ulogic;
	signal tx_full  : std_ulogic;

	type t_test_mode is (
		TEST_LOOPBACK,
		TEST_TX
	);
	-- Set to desired test
	constant TEST_MODE : t_test_mode := TEST_TX;

--	constant TEST_MODE_TX_PACKET_SIZE : positive             := 1514;
	constant TEST_MODE_TX_PACKET_SIZE : positive             := 57;

    signal mac_dst      : std_ulogic_vector(47  downto 0) := x"4c_cc_6a_49_6b_65";
    signal mac_src      : std_ulogic_vector(47  downto 0) := x"0e0e0e0e0e0b";
    signal eth_type     : std_ulogic_vector(15  downto 0) := x"0800";
    signal ver          : std_ulogic_vector(7   downto 0) := "01000101";
    signal serv         : std_ulogic_vector(7   downto 0) := x"00";
    signal tot_len      : std_ulogic_vector(15  downto 0) := x"002b";               -- IP length to 0x002b = 43
    signal id           : std_ulogic_vector(15  downto 0) := x"0000";
    signal flags        : std_ulogic_vector(15  downto 0) := "0100000000000000";
    signal ttl          : std_ulogic_vector(7   downto 0) := "01000000";
    signal protocol     : std_ulogic_vector(7   downto 0) := "00010001";
    signal hdr_checksum : std_ulogic_vector(15  downto 0) := x"0000";               -- check this
    signal ip_src       : std_ulogic_vector(31  downto 0) := x"c0a83601";           -- 192.168.54.1;
    -- signal ip_dst       : std_ulogic_vector(31  downto 0) := x"c0a83664";           -- 192.168.54.100
    signal ip_dst       : std_ulogic_vector(31  downto 0) := x"ffffffff";           -- broadcast?
    signal prt_src      : std_ulogic_vector(15  downto 0) := x"1f40";               --8000
    signal prt_dst      : std_ulogic_vector(15  downto 0) := x"2711";               --10001
    signal len          : std_ulogic_vector(15  downto 0) := x"0017";               -- UDP length field to 0x0017 = 23
    signal checksum     : std_ulogic_vector(15  downto 0) := x"0000";
    signal data         : std_ulogic_vector(119 downto 0) := (others=>'1');

    signal l_band_freq  : std_ulogic_vector(15  downto 0) := x"1405";
    signal x_band_freq  : std_ulogic_vector(15  downto 0) := x"3421";
    signal pol          : std_ulogic_vector(7  downto 0) := x"00";

    type t_data_array is array (0 to TEST_MODE_TX_PACKET_SIZE -1) of std_ulogic_vector(7 downto 0);
    signal data_array: t_data_array;
    signal clk_slow  : std_ulogic := '0';
    signal send_packet      : std_ulogic := '0';
    signal sending_packet  : std_ulogic := '0';
    signal rst_delay  : std_ulogic := '0';

	type t_test_tx_state is (
		TX_WAIT,
		TX_WRITE_SIZE_HI,
		TX_WRITE_SIZE_LO,
		TX_WRITE_DATA
	);
	signal test_tx_state      : t_test_tx_state;
	signal test_tx_data_count : integer range 0 to TEST_MODE_TX_PACKET_SIZE;
	signal test_tx_skip_next  : std_ulogic := '0';

begin

    data        <= x"0d00_0000_0000_0400_0300" & l_band_freq & x_band_freq & pol;
    data_array  <= (mac_dst(47 downto 40),      mac_dst(39 downto 32),      mac_dst(31 downto 24),      mac_dst(23 downto 16),
                    mac_dst(15 downto 8),       mac_dst(7 downto 0),        mac_src(47 downto 40),      mac_src(39 downto 32),
                    mac_src(31 downto 24),      mac_src(23 downto 16),      mac_src(15 downto 8),       mac_src(7 downto 0),
                    eth_type(15 downto 8),      eth_type(7 downto 0),       ver,                        serv,
                    tot_len(15 downto 8),       tot_len(7 downto 0),        id(15 downto 8),            id(7 downto 0),
                    flags(15 downto 8),         flags(7 downto 0),          ttl,                        protocol,
                    hdr_checksum(15 downto 8),  hdr_checksum(7 downto 0),   ip_src(31 downto 24),       ip_src(23 downto 16),
                    ip_src(15 downto 8),        ip_src(7 downto 0),         ip_dst(31 downto 24),       ip_dst(23 downto 16),
                    ip_dst(15 downto 8),        ip_dst(7 downto 0),         prt_src(15 downto 8),       prt_src(7 downto 0),
                    prt_dst(15 downto 8),       prt_dst(7 downto 0),        len(15 downto 8),           len(7 downto 0),
                    checksum(15 downto 8),      checksum(7 downto 0),       data(119 downto 112),       data(111 downto 104),
                    data(103 downto 96),        data(95 downto 88),         data(87 downto 80),         data(79 downto 72),
                    data(71 downto 64),         data(63 downto 56),         data(55 downto 48),         data(47 downto 40),
                    data(39 downto 32),         data(31 downto 24),         data(23 downto 16),         data(15 downto 8),
                    data(7 downto 0)
                    );

    process (clock)
    variable prescaler    : integer := 0;
    begin
        if rising_edge(clock) then
            if prescaler = 62500000 then
                clk_slow <= not clk_slow;
                prescaler := 0;
            else
                prescaler := prescaler + 1;
            end if;
        end if;
    end process;

    process(clk_slow, rst_delay)
    variable delay_count : integer range 0 to 4 := 0;
    begin
        if rst_delay = '1' then
            delay_count := 0;
            send_packet <= '0';
        elsif rising_edge(clk_slow) then
            if delay_count = 4 then
                send_packet <= '1';
            else
                send_packet <= '0';
                delay_count := delay_count + 1;
            end if;
        end if;
    end process;

	-- From left to right above the Ethernet connector
	led_o <= (not link_up) & (not speed) & "1";

	phy_reset_o <= not reset;
	-- user_led_o  <= reset;
	user_led_o(0)  <= clk_slow;
	user_led_o(1)  <= send_packet;

	speed <= speed_detected;

	test_proc : process(clock)
	begin
		if rising_edge(clock) then
			tx_wr_en <= '0';
			rx_rd_en <= '0';
			if copy_reset = '1' then
				test_tx_state     <= TX_WAIT;
				test_tx_skip_next <= '0';
			else
				case TEST_MODE is
					when TEST_LOOPBACK =>
						if rx_empty = '0' then
							rx_rd_en <= '1';
							if rx_rd_en = '1' then
								-- If we are fast enough, the TX FIFO should never overflow
								tx_wr_en <= '1';
								tx_data  <= rx_data;
							end if;
						end if;
					when TEST_TX =>
						if tx_full = '0' then
							if test_tx_skip_next = '1' then
								test_tx_skip_next <= '0';
								-- Write remaining byte
								if test_tx_state /= TX_WAIT then
									tx_wr_en <= '1';
								end if;
							else
								case test_tx_state is
									when TX_WAIT =>
                                        rst_delay <= '0';
										if send_packet = '1' then
										test_tx_state <= TX_WRITE_SIZE_HI;
			                            end if;
									when TX_WRITE_SIZE_HI =>
										tx_wr_en      <= '1';
										tx_data       <= std_ulogic_vector(to_unsigned(TEST_MODE_TX_PACKET_SIZE, 16)(15 downto 8));
										test_tx_state <= TX_WRITE_SIZE_LO;
									when TX_WRITE_SIZE_LO =>
										tx_wr_en           <= '1';
										tx_data            <= std_ulogic_vector(to_unsigned(TEST_MODE_TX_PACKET_SIZE, 16)(7 downto 0));
										test_tx_state      <= TX_WRITE_DATA;
										test_tx_data_count <= 0;
									when TX_WRITE_DATA =>
										tx_wr_en <= '1';
--										tx_data  <= "11111111";
										tx_data  <= data_array(test_tx_data_count);
										if test_tx_data_count = TEST_MODE_TX_PACKET_SIZE - 1 then
											-- test_tx_state <= TX_WRITE_SIZE_HI;
											test_tx_state <= TX_WAIT;
                                            rst_delay <= '1';
										end if;
										test_tx_data_count <= test_tx_data_count + 1;
								end case;
							end if;
						else
							test_tx_skip_next <= '1';
						end if;
				end case;
			end if;
		end if;
	end process;

	reset_generator_inst : entity work.reset_generator
		-- pragma translate_off
		generic map(
			RESET_DELAY => 10
		)
		-- pragma translate_on
		port map(
			clock_i  => clock,
			locked_i => dcm_locked,
			reset_o  => reset
		);

	clock_generator_inst : entity work.clock_generator
		port map(
			reset_i                => reset,
			clock_125_i            => clock_125_i,
			clock_125_o            => clock,
			clock_125_unbuffered_o => clock_unbuffered,
			clock_125_inv_o        => clock_inv,
			clock_50_o             => open,
			locked_o               => dcm_locked
		);

	ethernet_with_fifos_inst : entity ethernet_mac.ethernet_with_fifos
		generic map(
			MIIM_PHY_ADDRESS      => "00001",
			MIIM_RESET_WAIT_TICKS => 1250000 -- 10 ms at 125 MHz clock, minimum: 5 ms
		)
		port map(
			clock_125_i    => clock_unbuffered,
			reset_i        => reset,
			rx_reset_o     => copy_reset, -- Identical to tx_reset_o
			mii_tx_clk_i   => mii_tx_clk_i,
			mii_tx_er_o    => mii_tx_er_o,
			mii_tx_en_o    => mii_tx_en_o,
			mii_txd_o      => mii_txd_o,
			mii_rx_clk_i   => mii_rx_clk_i,
			mii_rx_er_i    => mii_rx_er_i,
			mii_rx_dv_i    => mii_rx_dv_i,
			mii_rxd_i      => mii_rxd_i,
			gmii_gtx_clk_o => gmii_gtx_clk_o,
			rgmii_tx_ctl_o => open,
			rgmii_rx_ctl_i => '0',
			miim_clock_i   => clock,
			mdc_o          => mdc_o,
			mdio_io        => mdio_io,
			link_up_o      => link_up,
			speed_o        => speed_detected,
			rx_clock_i     => clock,
			rx_empty_o     => rx_empty,
			rx_rd_en_i     => rx_rd_en,
			rx_data_o      => rx_data,
			tx_clock_i     => clock,
			tx_data_i      => tx_data,
			tx_wr_en_i     => tx_wr_en,
			tx_full_o      => tx_full
-- Force 1000 Mbps/GMII in simulation only
-- pragma translate_off
, speed_override_i         => SPEED_1000MBPS
		-- pragma translate_on
		);

end architecture;
