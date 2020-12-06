`timescale 1ns / 1ps

module address_controller #(parameter image_size = 8'h1C)(
    //image_size = input_img_size - Kernel_size +1 = output Image_size
    input start,
    input clk,
    input[9:0] img_addr,
    input[7:0] w_addr,
    output reg[9:0] out_img,
    output reg[7:0] out_w,
    output d_ena,
    output data_in_ena,
    output data_out_ena,
    output reg  data_in_done
    );
    
    
    reg[2:0] state;
    reg[2:0] line_state;
    reg[2:0] d_ena_reg;
    localparam idle = 3'b000, s_1 = 3'b001,s_2 = 3'b010,s_3 = 3'b011,s_4 = 3'b100,s_5= 3'b101;
    assign d_ena = |d_ena_reg;
    assign data_in_ena = d_ena_reg[0];
    assign data_out_ena = d_ena_reg[2];  
    always @(posedge clk) begin
        d_ena_reg[1] <= d_ena_reg[0];
        d_ena_reg[2] <= d_ena_reg[1];
        case(state)
            idle: begin
                if(start ==1'b1) begin
                    state <= s_1;
                    out_img <= img_addr;
                    out_w <= w_addr;
                    d_ena_reg[0]<=1'b1;
                    data_in_done <=1'b0;
                    
                    line_state <= 3'b000;
                end
                else begin
                    state <= idle;
                    out_img <= img_addr;
                    out_w <= w_addr;
                    d_ena_reg[0]<=1'b0;
                    data_in_done <=1'b0; 
                    
                    line_state <= 3'b000;
                end
            end
            s_1 : begin
                state <= s_2;
                out_img <= out_img + 1'b1;
                out_w <= out_w + 1'b1;
                d_ena_reg[0]<=1'b1;
                data_in_done <=1'b0;    
            end
            s_2 : begin
                state <= s_3;
                out_img <= out_img + 1'b1;
                out_w <= out_w + 1'b1;
                d_ena_reg[0]<=1'b1;
                data_in_done <=1'b0;
            end
            s_3 : begin
                state <= s_4;
                out_img <= out_img + 1'b1;
                out_w <= out_w + 1'b1;
                d_ena_reg[0]<=1'b1;
                data_in_done <=1'b0;               
            end
            s_4 : begin
                if(line_state == 3'b100) data_in_done <=1;
                else data_in_done <=0;
                state <= s_5;
                out_img <= out_img + 1'b1;
                out_w <= out_w + 1'b1;
                d_ena_reg[0]<=1'b1;            
            end
            s_5 : begin
                if(line_state == 3'b100) begin
                    out_img <= img_addr;
                    out_w <= w_addr;

                    state <= idle;
                    line_state <= 3'b000;
                    d_ena_reg[0]<=1'b0;
                    data_in_done <=1'b0;
                end
                else begin
                    state <= s_1;
                    line_state <= line_state +1'b1;
                    out_img <= out_img + image_size;
                    out_w <= out_w + 1'b1;
                    d_ena_reg[0]<=1;
                    data_in_done <=0;
                end                    
            end
            default : begin
                if (start ==1'b1) begin
                    state <= s_1;
                    out_img <= img_addr;
                    out_w <= w_addr;
                    d_ena_reg[0]<=1;
                    data_in_done <=0;               
                end
                else begin
                    state <= idle;
                    out_img <= img_addr;
                    out_w <= w_addr;
                    d_ena_reg[0]<=0;
                    data_in_done <=0;
                end
            end
        endcase
    end
endmodule

