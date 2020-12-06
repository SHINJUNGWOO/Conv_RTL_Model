`timescale 1ns / 1ps

module top_module#(parameter img_size = 128,out_img_size =(img_size-4)*(img_size-4),img_address_size = 14, weight_address_size = 8,out_address_size = 17)(
    input clk,
    input start,
    output [23:0] out_data_pin,
    output data_validity_pin,
    output img_end_pin,
    output reg done
    );
    
    reg start_calc;
    wire [7:0] img_data,weight_data;
    wire [img_address_size-1:0] img_address;
    wire[7:0] weight_address;
    wire img_data_ena,weight_data_ena;
    wire[out_address_size-1:0] out_address;
    wire[23:0] out_data;
    wire data_validity;
    wire done_calc;
    
    reg[7:0] weight_address_add;
    reg[out_address_size-1:0] out_address_add;
    wire[7:0] weight_address_mul;
    wire[out_address_size-1:0] out_address_mul;
    
    //////////////////////////////////////
    //img_test
    assign out_data_pin = out_data;
    assign data_validity_pin = data_validity;
    assign  img_end_pin = done_calc;    
    /////////////////////////////////////
    
    queue_mac_controller #(.img_address_size(img_address_size), .out_address_size(out_address_size), .img_size(img_size) ) QMC(
    .clk(clk),
    .start(start_calc),
    .img_data(img_data),
    .weight_data(weight_data),
    .img_address(img_address),
    .weight_address(weight_address),
    .img_data_ena(img_data_ena),
    .weight_data_ena(weight_data_ena),
    .data_validity(data_validity),
    .done(done_calc),
    .out_address(out_address),
    .out_data(out_data)
    );
    
    img_x img_t(
        .clkb(clk),    // input wire clkb
        .enb(img_data_ena),      // input wire enb
        .addrb(img_address),  // input wire [9 : 0] addrb
        .doutb(img_data)  // output wire [7 : 0] doutb
    );
    
    weight weight_t(
        .clkb(clk),    // input wire clkb
        .enb(weight_data_ena),      // input wire enb
        .addrb(weight_address + weight_address_add),  // input wire [9 : 0] addrb
        .doutb(weight_data)  // output wire [7 : 0] doutb
    );
    output_data_controller ODC_t(
    .clk(clk),
    .data_validity(data_validity),
    .data(out_data),
    .address(out_address + out_address_add)
    );
    //assign weight_address_mul = weight_address + weight_address_add; 
    //assign out_address_mul = out_address + out_address_add; 
    
    reg[2:0] state;
    always @(posedge clk) begin
        case(state)
            3'b000: begin
                if (start ==1'b1) begin
                    state <= 3'b001;
                    start_calc <=1'b1;
                    weight_address_add <= 0;
                    out_address_add <= 0;
                    done <=1'b0;
                end
                else begin
                    state <= 3'b000;
                    weight_address_add <= 0;
                    out_address_add <= 0;
                    start_calc <=1'b0;
                    done <=1'b0;
                end 
            end
            3'b001: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b010;
                    start_calc <=1'b1;
                    weight_address_add <= weight_address_add + 5'b11001;
                    out_address_add <= out_address_add + out_img_size;
                end
                else begin
                    state <= 3'b001;
                    start_calc <=1'b0;
                end
            end
            3'b010: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b011;
                    start_calc <=1'b1;
                    weight_address_add <= weight_address_add + 5'b11001;
                    out_address_add <= out_address_add + out_img_size;
                end
                else begin
                    state <= 3'b010;
                    start_calc <=1'b0;
                end
            end
            3'b011: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b100;
                    start_calc <=1'b1;
                    weight_address_add <= weight_address_add + 5'b11001;
                    out_address_add <= out_address_add + out_img_size;
                end
                else begin
                    state <= 3'b011;
                    start_calc <=1'b0;
                end
            end
            3'b100: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b101;
                    start_calc <=1'b1;
                    weight_address_add <= weight_address_add + 5'b11001;
                    out_address_add <= out_address_add + out_img_size;
                end
                else begin
                    state <= 3'b100;
                    start_calc <=1'b0;
                end
            end
            3'b101: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b110;
                    start_calc <=1'b1;
                    weight_address_add <= weight_address_add + 5'b11001;
                    out_address_add <= out_address_add + out_img_size;
                end
                else begin
                    state <= 3'b101;
                    start_calc <=1'b0;
                end
            end
            3'b110: begin
                if (done_calc== 1'b1) begin
                    state <= 3'b000;
                    done <=1'b1;
                end
                else begin
                    state <= 3'b110;
                    start_calc <=1'b0;
                end
            end
            default : state <=3'b000;                    
        endcase
    end
    

endmodule
