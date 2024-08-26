`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 18:55:01
// Design Name: 
// Module Name: fifo_router
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


module fifo_router(input clk,rst,we,re,soft_rst,input [7:0]d,input lfd_state,output empty,full,output reg [7:0]y);

reg [4:0]rptr,wptr;//read pointer and write pointer
integer i;
reg [8:0]mem[0:15]; //memory 16X9
reg lfd_states; //temp variable
reg [6:0]fifo_count;//7 bit fifo count

//delaying 1 clock cycle for lfd state
always@(posedge clk)
begin
	if(!rst)
		lfd_states<=0;
	else
		lfd_states<=lfd_state;		
end

//incrementing write pointer
always@(posedge clk)
begin
	if(!rst || soft_rst)
		{wptr,rptr}<=1'b0;
	else if(we&&!full)//if write enable is high and fifo is not full
		wptr<=wptr+1'b1;//increment write pointer
	else if(re&&!empty)// if read enable is high and fifo is not empty
		rptr<=rptr+1'b1;// increment read pointer
end 

//FIFO write
always@(posedge clk)
begin
	if(!rst || soft_rst)
		for(i=0;i<16;i=i+1)
			mem[i]<=0;
	else if(we &&!full)
		mem[wptr]<={lfd_state,d};//writing into fifo, lfd_state followed by data in
end
//FIFO downcounting
always@(posedge clk)
begin
	if(!rst || soft_rst)
		fifo_count<=7'd0;
	else if(re && !empty)
begin
if(mem[rptr][8]==1'b1)
fifo_count<=mem[rptr][7:2]+1;
else if(fifo_count!=0)
fifo_count<=fifo_count-1'b1;
end
end
//FIFO read
always@(posedge clk)
begin
if(!rst)
y<=0;
else if(soft_rst)
y<=8'bz;
else if (fifo_count==0&&y==0)
y<=8'bz;
else if(re && !empty)
y<=mem[rptr];

end

assign full=(wptr==5'd16)?1'b1:1'b0;
assign empty=(wptr==rptr)?1'b1:1'b0;

endmodule