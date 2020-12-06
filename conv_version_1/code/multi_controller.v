`timescale 1ns / 1ps

module multi_controller(
    input start,          //start
    input clk,            // clk
    input[9:0] s_img_addr,// start address
    input[7:0] s_w_addr,  // start address
    input[7:0] img_data,  // data from ram
    input[7:0] w_data,    // data from ram
    output[9:0] img_addr, // address for ram
    output[7:0] w_addr,   // address for ram
    output d_ena,         // data_ena for ram
    output data_in_ena,         
    output reg[23:0] calc_data, // calculated data
    output reg done,             // don Flag
    output data_in_done
    );
 /*
 multi_controller instance(
    .start(start),          // start
    .clk(clk),              // clk
    .s_img_addr(s_img_addr),// [9:0] start address
    .s_w_addr(s_w_addr),    // [7:0] start address
    .img_data(img_data),    // [8:0] data from ram
    .w_data(w_data),        // [8:0] data from ram
    .img_addr(img_addr),    // [9:0] address for ram
    .w_addr(w_addr),        // [7:0] address for ram
    .d_ena(d_ena),          // data_ena for ram
    .calc_data(calc_data),  // [23:0]calculated data
    .done(done),            // done Flag
    .test(mult)
    );
   */
    wire[23:0] tmp_calc;
    wire data_out_ena;
    address_controller A_C(
    .start(start),
    .clk(clk),
    .img_addr(s_img_addr),
    .w_addr(s_w_addr),
    .out_img(img_addr),
    .out_w(w_addr),
    .d_ena(d_ena),
    .data_in_ena(data_in_ena),
    .data_in_done(data_in_done),
    .data_out_ena(data_out_ena)
    );
    mult Mult (
    .CLK(clk),  // input wire CLK
    .A(img_data),      // input wire [7 : 0] A
    .B(w_data),      // input wire [7 : 0] B
    .P(tmp_calc)      // output wire [23 : 0] P
    );
    reg state;
    reg calc_state;
    always @(posedge clk) begin
        calc_state <= data_out_ena;
        if (calc_state == 1'b1) begin
            calc_data <= calc_data + tmp_calc;
            state <= 1'b1;
            if(data_out_ena == 1'b0) done<=1'b1;
            else done<=1'b0;
        end
        else begin
            calc_data <= 24'h000000;
            done <= 1'b0;
        end
    end
endmodule
