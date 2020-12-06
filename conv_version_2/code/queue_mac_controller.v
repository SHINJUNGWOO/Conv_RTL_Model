`timescale 1ns / 1ps

module queue_mac_controller #(parameter data_size= 8, out_data_size= 24, img_address_size = 14, weight_address_size = 8,out_address_size = 17,img_size = 128) (
    input clk,
    input start,
    input [data_size-1:0] img_data,
    input [data_size-1:0] weight_data,
    output [img_address_size -1:0] img_address,
    output [weight_address_size-1:0] weight_address,
    output img_data_ena,
    output weight_data_ena,
    output reg done,
    output reg data_validity,
    output reg [out_address_size-1:0] out_address,
    output reg [out_data_size-1:0] out_data
    );
    reg work;
    reg clear;
    reg weight_hold;
    wire img_full,weight_full;
    wire[(img_size*4+5)* data_size -1:0] img_queue;
    wire[25 * data_size -1:0] weight_queue;
    
    reg[2:0] state;
    wire [out_data_size -1:0] calc_data;
    reg [img_address_size -1: 0] line_count;
    
    
    queue #(.queue_size(img_size*4+5), .address_size(img_address_size),.img_size(img_size*img_size) ) img(
        .work(work),
        .clear(clear),
        .hold(1'b0),
        .clk(clk),
        .data(img_data),
        .address(img_address),
        .data_ena(img_data_ena),
        .queue(img_queue),
        .is_full(img_full)
    );
    queue #(.queue_size(25), .data_size(data_size), .address_size(weight_address_size),.img_size(img_size*img_size) ) weight(
        .work(work),
        .clear(clear),
        .hold(weight_hold),
        .clk(clk),
        .data(weight_data),
        .address(weight_address),
        .data_ena(weight_data_ena),
        .queue(weight_queue),
        .is_full(weight_full)
    );
    
    
    
    mac_5 #(.data_size(8),.output_size(24)) MAC(
    .clk(clk),
    .i_1(img_queue[5*data_size-1:0]),
    .i_2(img_queue[(5+img_size)*data_size-1:img_size*data_size]),
    .i_3(img_queue[(5+img_size*2)*data_size-1:img_size*data_size*2]),
    .i_4(img_queue[(5+img_size*3)*data_size-1:img_size*data_size*3]),
    .i_5(img_queue[(5+img_size*4)*data_size-1:img_size*data_size*4]),
    .w_1(weight_queue[5*data_size-1:0]),
    .w_2(weight_queue[10*data_size-1:5*data_size]),
    .w_3(weight_queue[15*data_size-1:10*data_size]),
    .w_4(weight_queue[20*data_size-1:15*data_size]),
    .w_5(weight_queue[25*data_size-1:20*data_size]),
    .out_data(calc_data)
    );
    localparam idle = 3'b111, data_clear = 3'b000, load = 3'b001,calc_wait = 3'b010, calc = 3'b011, calc_done = 3'b100;
    
    always @(*) begin
        if (state == idle) weight_hold <=1'b0;
        else if (weight_full == 1'b1) weight_hold <= 1'b1;
    end
    
    always @(posedge clk) begin
        case(state)
        idle : begin
            if (start ==1'b1) begin
                state <=data_clear;
                clear =1'b1;
                
            end
            else begin
                work <= 1'b0;
                clear <= 1'b1;
                out_data <= 0;
                out_address <=0;
                line_count <=0;
                data_validity <=1'b0;
                done <= 1'b0;
            end 
        end
        data_clear : begin
            clear =1'b0;
            state <= load;
            work <= 1'b1;
            out_data <=0;
            out_address <=0;
            data_validity <=1'b0;
            done <= 1'b0;
        end
        load : begin
            if (img_full ==1'b1) begin
                state <= calc_wait;
            end
            else state <= load;
            
        end
        calc_wait : begin
            data_validity <=1'b1;
            state <= calc;
            out_data <= calc_data;
        end
        calc : begin
            if (line_count == img_size-1'b1) begin
                line_count <=0;
                out_address <= out_address + 1'b1;
                out_data <= calc_data;
                data_validity <=1'b1;
            end
            else if (line_count > img_size  - 3'b110) begin
                line_count <= line_count +1'b1;
                data_validity <=1'b0;   
            end
            else begin
                out_data <= calc_data;
                out_address <= out_address + 1'b1;
                line_count <= line_count +1'b1;
                data_validity <=1'b1;
            end
            if (img_full ==1'b0) begin
                state <= calc_done;
            end
        end
        calc_done : begin
            state <= idle;
            out_data <=0;
            out_address <=0;
            data_validity <=1'b0;
            clear <= 1'b1;
            done <= 1'b1;
            
            
        end
        default : begin
            state <= idle;

        end
        endcase
    end
    
    
    
endmodule
