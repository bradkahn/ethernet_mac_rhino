<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="GIGE_nRESET" />
        <signal name="GIGE_MDC" />
        <signal name="GIGE_TX_ER" />
        <signal name="GIGE_TX_EN" />
        <signal name="GIGE_GTX_CLK" />
        <signal name="user_led_o(1:0)" />
        <signal name="led_o(7:4)" />
        <signal name="GIGE_MDIO" />
        <signal name="GIGE_RX_ER" />
        <signal name="GIGE_RX_DV" />
        <signal name="GIGE_RXD(7:0)" />
        <signal name="XLXN_25" />
        <signal name="i_CLK_P" />
        <signal name="i_CLK_N" />
        <signal name="GIGE_TX_CLK" />
        <signal name="GIGE_RX_CLK" />
        <signal name="GIGE_TXD(7:0)" />
        <port polarity="Output" name="GIGE_nRESET" />
        <port polarity="Output" name="GIGE_MDC" />
        <port polarity="Output" name="GIGE_TX_ER" />
        <port polarity="Output" name="GIGE_TX_EN" />
        <port polarity="Output" name="GIGE_GTX_CLK" />
        <port polarity="Output" name="user_led_o(1:0)" />
        <port polarity="Output" name="led_o(7:4)" />
        <port polarity="BiDirectional" name="GIGE_MDIO" />
        <port polarity="Input" name="GIGE_RX_ER" />
        <port polarity="Input" name="GIGE_RX_DV" />
        <port polarity="Input" name="GIGE_RXD(7:0)" />
        <port polarity="Input" name="i_CLK_P" />
        <port polarity="Input" name="i_CLK_N" />
        <port polarity="Input" name="GIGE_TX_CLK" />
        <port polarity="Input" name="GIGE_RX_CLK" />
        <port polarity="Output" name="GIGE_TXD(7:0)" />
        <blockdef name="clk_wiz_v3_6">
            <timestamp>2018-10-2T11:3:50</timestamp>
            <rect width="544" x="32" y="32" height="1056" />
            <line x2="32" y1="112" y2="112" x1="0" />
            <line x2="32" y1="144" y2="144" x1="0" />
            <line x2="576" y1="80" y2="80" x1="608" />
        </blockdef>
        <blockdef name="ethernet_mac_test">
            <timestamp>2018-10-2T11:0:35</timestamp>
            <rect width="320" x="64" y="-576" height="576" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-448" y2="-448" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-256" y2="-256" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-76" height="24" />
            <line x2="0" y1="-64" y2="-64" x1="64" />
            <line x2="448" y1="-544" y2="-544" x1="384" />
            <line x2="448" y1="-480" y2="-480" x1="384" />
            <line x2="448" y1="-416" y2="-416" x1="384" />
            <line x2="448" y1="-352" y2="-352" x1="384" />
            <line x2="448" y1="-288" y2="-288" x1="384" />
            <rect width="64" x="384" y="-236" height="24" />
            <line x2="448" y1="-224" y2="-224" x1="384" />
            <rect width="64" x="384" y="-172" height="24" />
            <line x2="448" y1="-160" y2="-160" x1="384" />
            <rect width="64" x="384" y="-108" height="24" />
            <line x2="448" y1="-96" y2="-96" x1="384" />
            <line x2="448" y1="-32" y2="-32" x1="384" />
        </blockdef>
        <block symbolname="clk_wiz_v3_6" name="XLXI_2">
            <blockpin signalname="i_CLK_P" name="CLK_IN_P" />
            <blockpin signalname="i_CLK_N" name="CLK_IN_N" />
            <blockpin signalname="XLXN_25" name="CLK_125" />
        </block>
        <block symbolname="ethernet_mac_test" name="XLXI_5">
            <blockpin signalname="XLXN_25" name="clock_125_i" />
            <blockpin signalname="GIGE_TX_CLK" name="mii_tx_clk_i" />
            <blockpin signalname="GIGE_RX_CLK" name="mii_rx_clk_i" />
            <blockpin signalname="GIGE_RX_ER" name="mii_rx_er_i" />
            <blockpin signalname="GIGE_RX_DV" name="mii_rx_dv_i" />
            <blockpin signalname="GIGE_RXD(7:0)" name="mii_rxd_i(7:0)" />
            <blockpin signalname="GIGE_nRESET" name="phy_reset_o" />
            <blockpin signalname="GIGE_MDC" name="mdc_o" />
            <blockpin signalname="GIGE_TX_ER" name="mii_tx_er_o" />
            <blockpin signalname="GIGE_TX_EN" name="mii_tx_en_o" />
            <blockpin signalname="GIGE_GTX_CLK" name="gmii_gtx_clk_o" />
            <blockpin signalname="GIGE_MDIO" name="mdio_io" />
            <blockpin signalname="GIGE_TXD(7:0)" name="mii_txd_o(7:0)" />
            <blockpin signalname="user_led_o(1:0)" name="user_led_o(1:0)" />
            <blockpin signalname="led_o(7:4)" name="led_o(3:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <branch name="GIGE_nRESET">
            <wire x2="2352" y1="992" y2="992" x1="2160" />
        </branch>
        <branch name="GIGE_MDC">
            <wire x2="2352" y1="1056" y2="1056" x1="2160" />
        </branch>
        <branch name="GIGE_TX_ER">
            <wire x2="2352" y1="1120" y2="1120" x1="2160" />
        </branch>
        <branch name="GIGE_TX_EN">
            <wire x2="2352" y1="1184" y2="1184" x1="2160" />
        </branch>
        <branch name="GIGE_GTX_CLK">
            <wire x2="2352" y1="1248" y2="1248" x1="2160" />
        </branch>
        <branch name="user_led_o(1:0)">
            <wire x2="2176" y1="1312" y2="1312" x1="2160" />
            <wire x2="2368" y1="1312" y2="1312" x1="2176" />
        </branch>
        <branch name="led_o(7:4)">
            <wire x2="2352" y1="1440" y2="1440" x1="2160" />
        </branch>
        <branch name="GIGE_MDIO">
            <wire x2="2352" y1="1504" y2="1504" x1="2160" />
        </branch>
        <branch name="GIGE_RX_ER">
            <wire x2="1712" y1="1280" y2="1280" x1="1696" />
        </branch>
        <branch name="GIGE_RX_DV">
            <wire x2="1712" y1="1376" y2="1376" x1="1696" />
        </branch>
        <branch name="GIGE_RXD(7:0)">
            <wire x2="1712" y1="1472" y2="1472" x1="1696" />
        </branch>
        <iomarker fontsize="28" x="1696" y="1280" name="GIGE_RX_ER" orien="R180" />
        <iomarker fontsize="28" x="1696" y="1376" name="GIGE_RX_DV" orien="R180" />
        <iomarker fontsize="28" x="1696" y="1472" name="GIGE_RXD(7:0)" orien="R180" />
        <instance x="656" y="912" name="XLXI_2" orien="R0">
        </instance>
        <branch name="XLXN_25">
            <wire x2="1712" y1="992" y2="992" x1="1264" />
        </branch>
        <branch name="i_CLK_P">
            <wire x2="656" y1="1024" y2="1024" x1="624" />
        </branch>
        <iomarker fontsize="28" x="624" y="1024" name="i_CLK_P" orien="R180" />
        <branch name="i_CLK_N">
            <wire x2="656" y1="1056" y2="1056" x1="624" />
        </branch>
        <iomarker fontsize="28" x="624" y="1056" name="i_CLK_N" orien="R180" />
        <branch name="GIGE_TX_CLK">
            <wire x2="1712" y1="1088" y2="1088" x1="1696" />
        </branch>
        <iomarker fontsize="28" x="1696" y="1088" name="GIGE_TX_CLK" orien="R180" />
        <branch name="GIGE_RX_CLK">
            <wire x2="1712" y1="1184" y2="1184" x1="1696" />
        </branch>
        <iomarker fontsize="28" x="1696" y="1184" name="GIGE_RX_CLK" orien="R180" />
        <iomarker fontsize="28" x="2352" y="992" name="GIGE_nRESET" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1056" name="GIGE_MDC" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1120" name="GIGE_TX_ER" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1184" name="GIGE_TX_EN" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1248" name="GIGE_GTX_CLK" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1376" name="GIGE_TXD(7:0)" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1440" name="led_o(7:4)" orien="R0" />
        <iomarker fontsize="28" x="2352" y="1504" name="GIGE_MDIO" orien="R0" />
        <instance x="1712" y="1536" name="XLXI_5" orien="R0">
        </instance>
        <branch name="GIGE_TXD(7:0)">
            <wire x2="2352" y1="1376" y2="1376" x1="2160" />
        </branch>
        <iomarker fontsize="28" x="2368" y="1312" name="user_led_o(1:0)" orien="R0" />
    </sheet>
</drawing>