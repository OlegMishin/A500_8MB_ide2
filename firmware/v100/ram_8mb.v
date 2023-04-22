module ram_8mb( 
	input [23:1] cpu_a, 
	input cpu_nas,
	input cpu_nlds,
	input cpu_nuds,
	input cpu_clk, 
	input cpu_rw, 
	input [7:5] ram_base_addr, // TODO
	input ram_nconfigured,
   output reg dram_nras = 1'b1, 
	output reg dram_nlcas = 1'b1, 
	output reg dram_nucas = 1'b1, 
	output reg [11:0] dram_ma, 
	output dram_wrn, 
	output dram_oen,
	output reg ram_ndtack = 1'b1,
	output reg ram_selected = 1'b0
	
  	);

	reg    mux_switch; // address MUXing

	wire [7:0] high_addr;
//	wire [5:0] low_addr;

	reg rfsh_ras,rfsh_cas; // refresh /RAS, /CAS generators (POSITIVE assertion)

	reg access_ras,access_cas; // normal access /RAS, /CAS generators (POSITIVE assertion)
/*
	reg read_cycle; // if current cycle is read cycle
	reg write_cycle;
*/	
//	reg autoconf_on;
//	reg cpu_nas_z; // 1 cycle later

	reg [1:0] rfsh_select; // for cycling refresh over every of four chips

	reg mode_8mb = 1, mode_4mb = 0, mode_slow = 0, mode_slow4mb = 0; // modes of operation


	assign high_addr = cpu_a[23:16];
//	assign low_addr  = cpu_a[6:1];
	
	// chip selector decoder
	always @*
	begin

//		{which_ras[0],which_ras[1],which_ras[2],which_ras[3]} = 4'b0000; // default decoder state
		ram_selected = 1'b0;
		
		
		casex( high_addr )

		8'b001xxxxx: // $200000-$3fffff
		begin
			if( mode_8mb==1'b1 || mode_4mb==1'b1 || mode_slow4mb==1'b1 )
			begin
//				which_ras[0] = 1'b1;
				ram_selected = 1'b1;
			end
		end

		8'b010xxxxx: // $400000-$5fffff
		begin
			if( mode_8mb==1'b1 || mode_4mb==1'b1 || mode_slow4mb==1'b1 )
			begin
//				which_ras[1] = 1'b1;
				ram_selected = 1'b1;
			end
		end
		
		8'b011xxxxx: // $600000-$7fffff
		begin
			if( mode_8mb==1'b1 )
			begin
//				which_ras[2] = 1'b1;
				ram_selected = 1'b1;
			end
		end
		
		8'b100xxxxx: // $800000-$9fffff
		begin
			if( mode_8mb==1'b1 )
			begin
//				which_ras[3] = 1'b1;
				ram_selected = 1'b1;
			end
		end

		8'b110xxxxx:  // c00000-d7ffff - slow memory mapping
		begin
			if( (mode_slow==1'b1 || mode_slow4mb==1'b1) && ( high_addr[4:3]==2'b00 || high_addr[4:3]==2'b01 || high_addr[4:3]==2'b10 ) )
			begin
//				which_ras[2] = 1'b1;
				ram_selected = 1'b1;
			end
		end
		
		default: begin end
		
		endcase
	end


	// normal cycle generator
	always @(posedge cpu_clk,posedge cpu_nas)
	begin
		if( cpu_nas==1 )
		begin // /AS=1
			access_ras <= 0;
			access_cas <= 0;
		end
		else
		begin // /AS=0, positive clock
			access_ras <= 1;
			access_cas <= access_ras; // one clock later
		end
	end




	// refresh cycle generator
	always @(negedge cpu_clk)
	begin
		if( cpu_nas==1 ) // /AS negated
		begin
			rfsh_cas <= ~rfsh_cas;
		end
		else // /AS asserted
		begin
			rfsh_cas <= 0;
		end

		if( (rfsh_cas == 1'b0) && (cpu_nas==1) )
		begin
			rfsh_select <= rfsh_select + 2'b01;
		end
	end

	always @*
	begin
		rfsh_ras <= rfsh_cas & cpu_clk;
	end



	// output signals generator
	always @*
	begin
		dram_nras <= ~( ( access_ras ) | ((rfsh_select==2'b00)?rfsh_ras:1'b0) );
		dram_nlcas <= ~( ( ~cpu_nlds & access_cas & ram_selected ) | rfsh_cas );
		dram_nucas <= ~( ( ~cpu_nuds & access_cas & ram_selected ) | rfsh_cas );
	end






	// MUX switcher generator
	always @(negedge cpu_clk,negedge access_ras)
	begin
		if( access_ras==0 )
		begin // reset on no access_ras
			mux_switch <= 0;
		end
		else
		begin // set to 1 on negedge after beginning of access_ras
			mux_switch <= 1;
		end
	end

	// DRAM MAx multiplexor
	always @*
	begin
		if( mux_switch==0 )
			dram_ma[11:0] <= cpu_a[22:11];
		else // mux_switch==1
		 begin
			dram_ma[9:0] <= cpu_a[10:1];
			dram_ma[11:10] <= 2'b00;
		 end	
	end




/*
	// make clocked cpu_nas_z
	always @(posedge cpu_clk)
	begin
		cpu_nas_z <= cpu_nas;
	end
*/	
/*
	// detect if current cycle is read or write cycle
	always @(posedge cpu_clk, posedge cpu_nas)
	begin
		if( cpu_nas==1 ) // async reset on end of /AS strobe
		begin
			read_cycle  <= 0; // end of cycles
			write_cycle <= 0;
		end
		else // sync beginning of cycle
		begin
			if( cpu_nas==0 && cpu_nas_z==1 ) // beginning of /AS strobe
			begin
				if( (cpu_nlds&cpu_nuds)==0 )
					read_cycle <= 1;
				else
					write_cycle <= 1;
			end
		end
	end
*/

	
assign dram_wrn = cpu_rw | (~ram_selected);
assign dram_oen = ram_nconfigured;

	
always @(posedge cpu_clk or posedge cpu_nas) begin

    if (cpu_nas) begin
        ram_ndtack <= 1'b1;
    end else begin
        ram_ndtack <= !ram_selected;
    end
end

endmodule
