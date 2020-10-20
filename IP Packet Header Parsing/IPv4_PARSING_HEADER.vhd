LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY IPv4_PARSING_HEADER IS
    PORT ( PACKET : IN  STD_LOGIC_VECTOR(511 DOWNTO 0);
           MAC_SRC: OUT  STD_LOGIC_VECTOR(47 DOWNTO 0);
			  MAC_DST: OUT  STD_LOGIC_VECTOR(47 DOWNTO 0);
           MAC_BROADCAST : OUT  STD_LOGIC;
			  IPv4_VALID : OUT STD_LOGIC;
			  IPv4_SRC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IPv4_DST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IPv4_CLASS_A : OUT STD_LOGIC;
		     IPv4_CLASS_B : OUT STD_LOGIC;
			  IPv4_CLASS_C : OUT STD_LOGIC;
			  IPv4_BROADCAST : OUT STD_LOGIC;
			  IPv4_TTL: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			  );
END IPv4_PARSING_HEADER;

ARCHITECTURE arch_IPv4_PARSING_HEADER OF IPv4_PARSING_HEADER IS
	SIGNAL  mac_izvora        : STD_LOGIC_VECTOR(47 DOWNTO 0);
	SIGNAL  mac_odredista     : STD_LOGIC_VECTOR(47 DOWNTO 0);
	SIGNAL  ip_verzija        : STD_LOGIC_VECTOR( 3 DOWNTO 0);
   SIGNAL  ip_duzina_zag     : STD_LOGIC_VECTOR( 3 DOWNTO 0);
   SIGNAL  ip_type           : STD_LOGIC_VECTOR( 7 DOWNTO 0);
   SIGNAL  ip_identif        : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL  ip_duzina         : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL  ip_flagsifrag     : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL  ip_ttl            : STD_LOGIC_VECTOR( 7 DOWNTO 0);
   SIGNAL  ip_protocol       : STD_LOGIC_VECTOR( 7 DOWNTO 0);
   SIGNAL  ip_checksum       : STD_LOGIC_VECTOR(15 DOWNTO 0);
   SIGNAL  ip_adr_izvora     : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL  ip_adr_odredista  : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL  ip_checksum1      : UNSIGNED(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL  ip_checksum2      : UNSIGNED(15 DOWNTO 0) := (OTHERS => '0');


BEGIN

	mac_odredista    <= PACKET(511 DOWNTO 464);
	mac_izvora       <= PACKET(463 DOWNTO 416);
	ip_verzija       <= PACKET(399 DOWNTO 396);
	ip_duzina_zag    <= PACKET(395 DOWNTO 392);
	ip_type          <= PACKET(391 DOWNTO 384);
   ip_duzina        <= PACKET(383 DOWNTO 368);
	ip_identif       <= PACKET(367 DOWNTO 352);
	ip_flagsifrag    <= PACKET(351 DOWNTO 336);
   ip_ttl           <= PACKET(335 DOWNTO 328);
   ip_protocol      <= PACKET(327 DOWNTO 320);
   ip_checksum      <= PACKET(319 DOWNTO 304);
   ip_adr_izvora    <= PACKET(303 DOWNTO 272);
   ip_adr_odredista <= PACKET(271 DOWNTO 240);
	
	MAC_DST <= mac_odredista;
	MAC_SRC <= mac_izvora;
	
	MAC_BROADCAST <= '1' WHEN mac_odredista = "111111111111111111111111111111111111111111111111" ELSE '0';
	
	IPv4_SRC <= ip_adr_izvora;
	IPv4_DST <= ip_adr_odredista;
	
	IPv4_BROADCAST <= '1' WHEN ip_adr_odredista = "11111111111111111111111111111111" ELSE '0';
	
	IPv4_TTL <= ip_ttl;
	
	
	ip_checksum1 <= TO_UNSIGNED(0,32) 
                 + UNSIGNED(ip_verzija & ip_duzina_zag & ip_type)
                 + UNSIGNED(ip_identif)
                 + UNSIGNED(ip_duzina)
					  + UNSIGNED(ip_checksum)
                 + UNSIGNED(ip_flagsifrag)
                 + UNSIGNED(ip_ttl & ip_protocol)
                 + UNSIGNED(ip_adr_izvora(31 DOWNTO 16))
                 + UNSIGNED(ip_adr_izvora(15 DOWNTO  0))
                 + UNSIGNED(ip_adr_odredista(31 DOWNTO 16))
                 + UNSIGNED(ip_adr_odredista(15 DOWNTO  0));
   ip_checksum2 <= ip_checksum1(31 DOWNTO 16) + ip_checksum1(15 DOWNTO 0);
	
	IPv4_VALID <= '1' WHEN ip_checksum2 = "1111111111111111" ELSE '0';
	
	IPv4_CLASS_A <= '1' WHEN ip_adr_odredista(31) = '0' ELSE '0';
	IPv4_CLASS_B <= '1' WHEN ip_adr_odredista(31) = '1' AND ip_adr_odredista(30) = '0' ELSE '0';
	IPv4_CLASS_C <= '1' WHEN (ip_adr_odredista(31) = '1' AND ip_adr_odredista(30) = '1' AND ip_adr_odredista(29) = '0') ELSE '0';
	
END ARCHITECTURE;



