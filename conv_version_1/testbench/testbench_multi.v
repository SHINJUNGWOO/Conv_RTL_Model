`timescale 1ns / 1ps

module testbench_multi();
reg[9:0] s_img_addr;
reg[7:0] s_w_addr;
reg start;
wire clk;
wire[9:0] img_addr;
wire[7:0] w_addr;
wire d_ena;
wire[7:0] img_data;
wire[7:0] w_data;
wire[23:0] calc_data;
wire done;
clock_gen Clock_gen(clk);
    
multi_controller MC(
    .start(start),          //start
    .clk(clk),            // clk
    .s_img_addr(s_img_addr),// start address
    .s_w_addr(s_w_addr),  // start address
    .img_data(img_data),  // data from ram
    .w_data(w_data),    // data from ram
    .img_addr(img_addr),
    .w_addr(w_addr), // address for ram
    .d_ena(d_ena),         // data_ena for ram
    .calc_data(calc_data), // calculated data
    .done(done)        // don Flag
  
  );  
    
img_x img(
  .clkb(clk),    // input wire clkb
  .enb(d_ena),      // input wire enb
  .addrb(img_addr),  // input wire [9 : 0] addrb
  .doutb(img_data)  // output wire [7 : 0] doutb
);
weight_w weight(
  .clkb(clk),    // input wire clkb
  .enb(d_ena),      // input wire enb
  .addrb(w_addr),  // input wire [9 : 0] addrb
  .doutb(w_data)  // output wire [7 : 0] doutb
);

initial begin
#100;

start =0;
#125;
s_img_addr = 10'b0000000000;
s_w_addr = 8'b00000000;
start =1;
#50;
start =0;
end
endmodule
