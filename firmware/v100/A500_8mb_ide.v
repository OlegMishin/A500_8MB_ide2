module A500_8mb_ide(
// CPU bus
		input		CLKCPU,
		input		RESETn,

		input		[23:1] A,
		inout		[3:0] D,
		input		[7:4] DB,
        
		input		ASn,
		input		RWn,
		input		LDSn,
		input		UDSn,		
		output	DTACKn,
		
// IDE interface part		
		input  	IDEIRQn,
		input  	IDEACT,
		output 	IDERDn,
		output 	IDEWRn,
		input 	IORDY,
		output 	[1:0] IDECSn,
		output 	IDELED,

// FLASH control 		
		output 	FLASHOEn, 
		output 	FLASHWEn, 
		input  	FLASH_PROGn,
		input 	FLASH_SEL, 
		output 	FLASH_BANK, 
		
// ram chip control
		output  	RAMOEn,
		output   LCASn,
		output   UCASn,
		output   RAMWn,
		output  	RASn,
		output   [11:0] RAM_A,
// Autoconfig		
		output  	LED,
		output 	CFGOUTn,
		input 	CFGINn,
		input 	AUTOBOOTn
	
		
);

wire [7:0] IDE_BASEADR;
wire IDE_CONFIGUREDn;
wire IDE_DTACKn;
wire IDE_SELECTED;


wire [7:5] RAM_BASEADDR;
wire RAM_CONFIGUREDn;
wire RAM_DTACKn;
wire RAM_SELECTED;

wire DSn;



autoconfig_zii zorro2(
    .C7M(CLKCPU),
    .CFGIN_n(CFGINn | ~FLASH_PROGn),
    .AUTOBOOT_EN(~AUTOBOOTn),// AUTOBOOT
    .AS_CPU_n(ASn),
    .RESET_n(RESETn),
    .DS_n(DSn),
    .RW_n(RWn),
    .A_HIGH(A[23:16]),
    .A_LOW(A[6:1]),
    .D_HIGH_NYBBLE(D),
    .BASE_RAM(RAM_BASEADDR),
    .BASE_IDE(IDE_BASEADR),
    .RAM_CONFIGURED_n(RAM_CONFIGUREDn),
    .IDE_CONFIGURED_n(IDE_CONFIGUREDn),
    .CFGOUT_n(CFGOUTn)
);

ram_8mb ram( 
		.cpu_a(A), 
      .cpu_nas(ASn),
		.cpu_nlds(LDSn),
		.cpu_nuds(UDSn),
		.cpu_clk(CLKCPU),
		.cpu_rw(RWn),
		.ram_base_addr(RAM_BASEADDR),
		.ram_nconfigured(RAM_CONFIGUREDn),
      .dram_nras(RASn), 
		.dram_nlcas(LCASn),
		.dram_nucas(UCASn),
      .dram_ma(RAM_A),
		.dram_wrn(RAMWn),
		.dram_oen(RAMOEn),
		.ram_ndtack(RAM_DTACKn),
		.ram_selected(RAM_SELECTED)

);

ata a500_ide(
    .CLKCPU(CLKCPU),
    .RESET_n(RESETn),
    .A_HIGH(A[23:16]),
    .A12(A[12]),
    .A13(A[13]),
    .RW_n(RWn),
    .AS_CPU_n(ASn),
    .BASE_IDE(IDE_BASEADR[7:0]),
    .IDE_CONFIGURED_n(IDE_CONFIGUREDn),
    .ROM_OE_n(FLASH_OEn),//
    .IDE_IOR_n(IDERDn),
    .IDE_IOW_n(IDEWRn),
    .IDE_CS_n(IDECSn[1:0]),
    .IDE_ACCESS(IDE_SELECTED),
    .DTACK_n(IDE_DTACKn)
);


reg  FLASH_DTACKn = 1'b1;

//wire flash_access = (A[23:16] == 8'hEE) && !ASn && !DSn;
wire flash_access = (A[23:17] == 7'h77) && !ASn && !DSn && !FLASH_PROGn; // 128K at 0xEE0000

wire FLASH_PROG_OEn = !flash_access | !RWn;
wire FLASH_PROG_WEn = !flash_access | RWn;

//assign FLASHOEn = FLASH_PROG ? FLASH_PROG_OEn : FLASH_OEn;
//assign FLASHWEn = FLASH_PROG ? FLASH_PROG_WEn : 1'b1;

// ok
//assign FLASHOEn = FLASH_PROG_OEn & FLASH_OEn;
//assign FLASHWEn = FLASH_PROG_WEn;
assign FLASHOEn = FLASH_PROGn ? FLASH_OEn : FLASH_PROG_OEn;
assign FLASHWEn = FLASH_PROGn ? 1'b1 : FLASH_PROG_WEn;


always @(posedge CLKCPU or posedge ASn) begin

    if (CLKCPU) begin
        FLASH_DTACKn <= 1'b1;
    end else begin
        FLASH_DTACKn <= !flash_access;
    end
end



assign DTACKn = (~RAM_DTACKn | ~FLASH_DTACKn)  ? 1'b0 : 1'bz;
//assign DTACKn = (~RAM_DTACKn )  ? 1'b0 : 1'bz;

assign LED = ~(IDE_CONFIGUREDn | RAM_CONFIGUREDn);
assign IDELED = flash_access;

assign FLASH_BANK = ~FLASH_SEL;//1'b0;


endmodule