`timescale 1ns / 1ps

module data_out_controller(
    input clk,
    input start,
    input[23:0] data,
    input[12:0] addr
    );
    reg wea;
    reg ena,enb;
    reg [23:0] done_data;
    reg[12:0] addr_save;
    wire [23:0] save_data;
 img_y img_y (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addr_save),  // input wire [12 : 0] addra
  .dina(done_data),    // input wire [23 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(enb),      // input wire enb
  .addrb(addr_save),  // input wire [12 : 0] addrb
  .doutb(save_data)  // output wire [23 : 0] doutb
);
    reg [2:0] state;
    localparam idle = 3'b000, read_1 = 3'b001, read_2 = 3'b010, read_3 = 3'b011,write_1 = 3'b100,write_2 = 3'b101 ;
always @(posedge clk) begin
    if( state == idle) begin
        if(start ==1'b1) begin
        state <= read_1;
        addr_save <= addr;
        done_data <= data;
        enb <=1'b1;
        end
        else begin
            state <=idle;
            ena <=1'b0;
            enb <=1'b0;
            wea <=1'b0;
        end
    end
    else if(state == read_1) begin
        state <= read_2;
    end
    else if(state == read_2) begin
        state <= read_3;
    end
    else if(state == read_3) begin
        state <= write_1;
        done_data <= done_data +save_data ;
        enb <=1'b0;
        wea <=1'b1;
        ena <=1'b1;
    end
    else if(state == write_1) begin
        state <= write_2;    
    end
    else if(state == write_2) begin
        state <= idle;    
    end
    else begin
        state <=idle;
        ena <=1'b0;
        enb <=1'b0;
        wea <=1'b0;
    end
    
end
endmodule
