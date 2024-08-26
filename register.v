`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 18:59:21
// Design Name: 
// Module Name: register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register(clk,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,lfd_state,laf_state,full_state,rst_int_reg,err,parity_done,low_packet_valid,dout);

input clk,resetn,pkt_valid,fifo_full,detect_add,ld_state,full_state,lfd_state,rst_int_reg,laf_state;
input [7:0]data_in;
output reg err,parity_done,low_packet_valid;
output reg [7:0]dout;
reg [7:0]header,int_reg,int_parity,ext_parity;
//data out

always@(posedge clk)
begin
	if(!resetn)
	begin
		dout<=0;
		header<=0;
		int_reg<=0;
	end
	else if(detect_add &&pkt_valid &&data_in[1:0]!=2'b11)
		header<=data_in;
	else if(lfd_state)
		dout<=header;
	else if(ld_state&&!fifo_full)
		dout<=data_in;
	else if(ld_state&&fifo_full)
		int_reg<=data_in;
	else if(laf_state)
		dout<=int_reg;
end

//low packet valid logic

always@(posedge clk)
begin
	if(!resetn)
		low_packet_valid<=0;
	else if(rst_int_reg)
		low_packet_valid<=0;
	else if(ld_state&&!pkt_valid)
		low_packet_valid<=1;
end

//parity done logic
always@(posedge clk)
begin
	if(!resetn)
		parity_done<=0;
	else if(detect_add)
		parity_done<=0;
	else if((ld_state&&!fifo_full&&!pkt_valid)||(laf_state&&low_packet_valid&&!parity_done))
		parity_done<=1;
end
	//parity calculate logic

	always@(posedge clk)
begin
	if(!resetn)
		int_parity<=1'b0;
	else if(detect_add)
		int_parity<=1'b0;
	else if(lfd_state&&pkt_valid)
		int_parity <= int_parity ^ data_in;
	else
		int_parity <= int_parity;
end

//error logic
  always@(posedge clk)
  begin
	  if(!resetn)
		  err<=0;
	  else if(parity_done)
	  begin
		  if(int_parity==ext_parity)
			  err<=0;
		  else
			  err<=1;
	  end
	  else
		  err<=0;
  end
//external parity logic
  
  always@(posedge clk)
  begin
	  if(!resetn)
		  ext_parity<=0;
	  else if(detect_add)
		  ext_parity<=0;
	  else if((ld_state&&!fifo_full&&!pkt_valid)||(laf_state&&!parity_done&&low_packet_valid))
		  ext_parity<=data_in;
  end
  
  endmodule 
