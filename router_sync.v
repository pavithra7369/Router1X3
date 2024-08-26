`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 19:01:25
// Design Name: 
// Module Name: router_sync
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


module router_sync(
input clk,rst,detect_add,we_reg,re0,re1,re2,empty0,empty1,empty2,full0,full1,full2,
input [1:0]din,
output reg[2:0]we,
output reg fifo_full,sr0,sr1,sr2,
output vout0,vout1,vout2);

reg [1:0]fifo_addr; //temporary vafriable for talking in the data_in based on detect_add
reg [4:0]fifo0_count;
reg [4:0]fifo1_count;
reg [4:0]fifo2_count;

always@(posedge clk)
begin
if(!rst)
fifo_addr<=0;
else if(detect_add)   //if detect_add is 1 then load the din value to fifo_addr
fifo_addr<=din;
end

always@(*)
begin
 //if write enable is 1, then chcek dinand based on din pass fifo_full
case(fifo_addr)
2'b00:fifo_full=full0;
2'b01:fifo_full=full1;
2'b10:fifo_full=full2;
endcase
end

always@(*)
begin
if(we_reg)
case(fifo_addr)
2'b00:we=3'b001;
2'b01:we=3'b010;
2'b10:we=3'b100;
default: we=3'b000;

endcase
else
we=3'b000;
end

assign vout0=(!empty0)? 1:0; //valid is created by fiifo status
assign vout1=(!empty1)? 1:0; //if tht fifo is not empty then tht fifo is valid
assign vout2=(!empty2)? 1:0;


always@(posedge clk)
begin
if(!rst)
begin
sr0<=0;
fifo0_count<=0;
end

else if(!vout0)
begin
sr0<=0;
fifo0_count<=0;
end

else if(fifo0_count==5'd29) //chcek the 30 clk cycles
begin
sr0<=1;
fifo0_count<=0;
end

else
begin
sr0<=0;
fifo0_count<=fifo0_count+1; //count to 30 clk cycles
end

end

always@(posedge clk)
begin

if(!rst)
begin
sr1<=0;
fifo1_count<=0;
end
else if(!vout1)
begin
sr1<=0;
fifo1_count<=0;
end
else if(fifo1_count==5'd29)
begin
sr1<=1;
fifo1_count<=0;
end
else
begin
sr1<=0;
fifo1_count<=fifo1_count+1;
end
end

always@(posedge clk)
begin
if(!rst)
begin
sr2<=0;
fifo2_count<=0;
end
else if(!vout2)
begin
sr2<=0;
fifo2_count<=0;
end
else if(fifo2_count==5'd29)
begin
sr2<=1;
fifo2_count<=0;
end
else
begin
sr2<=0;
fifo2_count<=fifo2_count+1;
end
end 

endmodule




