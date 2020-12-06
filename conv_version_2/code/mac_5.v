`timescale 1ns / 1ps

module mac_5 #(parameter data_size = 8,parameter output_size = 24)(
    input clk,
    input [data_size*5 -1:0] i_1,
    input [data_size*5 -1:0] i_2,
    input [data_size*5 -1:0] i_3,
    input [data_size*5 -1:0] i_4,
    input [data_size*5 -1:0] i_5,
    input [data_size*5 -1:0] w_1,
    input [data_size*5 -1:0] w_2,
    input [data_size*5 -1:0] w_3,
    input [data_size*5 -1:0] w_4,
    input [data_size*5 -1:0] w_5,
    output [output_size -1:0] out_data
    );
    wire[output_size-1:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25;
    mult8 m1(.CLK(clk), .A(i_1[data_size*1-1:0]),           .B(w_1[data_size*1-1:0]),           .P(d1));
    mult8 m2(.CLK(clk), .A(i_1[data_size*2-1:data_size]),   .B(w_1[data_size*2-1:data_size]),   .P(d2));
    mult8 m3(.CLK(clk), .A(i_1[data_size*3-1:data_size*2]), .B(w_1[data_size*3-1:data_size*2]), .P(d3));
    mult8 m4(.CLK(clk), .A(i_1[data_size*4-1:data_size*3]), .B(w_1[data_size*4-1:data_size*3]), .P(d4));
    mult8 m5(.CLK(clk), .A(i_1[data_size*5-1:data_size*4]), .B(w_1[data_size*5-1:data_size*4]), .P(d5));
    
    mult8 m6(.CLK(clk), .A(i_2[data_size*1-1:0]),           .B(w_2[data_size*1-1:0]),           .P(d6));
    mult8 m7(.CLK(clk), .A(i_2[data_size*2-1:data_size]),   .B(w_2[data_size*2-1:data_size]),   .P(d7));
    mult8 m8(.CLK(clk), .A(i_2[data_size*3-1:data_size*2]), .B(w_2[data_size*3-1:data_size*2]), .P(d8));
    mult8 m9(.CLK(clk), .A(i_2[data_size*4-1:data_size*3]), .B(w_2[data_size*4-1:data_size*3]), .P(d9));
    mult8 m10(.CLK(clk), .A(i_2[data_size*5-1:data_size*4]), .B(w_2[data_size*5-1:data_size*4]), .P(d10));
    
    mult8 m11(.CLK(clk), .A(i_3[data_size*1-1:0]),           .B(w_3[data_size*1-1:0]),           .P(d11));
    mult8 m12(.CLK(clk), .A(i_3[data_size*2-1:data_size]),   .B(w_3[data_size*2-1:data_size]),   .P(d12));
    mult8 m13(.CLK(clk), .A(i_3[data_size*3-1:data_size*2]), .B(w_3[data_size*3-1:data_size*2]), .P(d13));
    mult8 m14(.CLK(clk), .A(i_3[data_size*4-1:data_size*3]), .B(w_3[data_size*4-1:data_size*3]), .P(d14));
    mult8 m15(.CLK(clk), .A(i_3[data_size*5-1:data_size*4]), .B(w_3[data_size*5-1:data_size*4]), .P(d15));
    
    mult8 m16(.CLK(clk), .A(i_4[data_size*1-1:0]),           .B(w_4[data_size*1-1:0]),           .P(d16));
    mult8 m17(.CLK(clk), .A(i_4[data_size*2-1:data_size]),   .B(w_4[data_size*2-1:data_size]),   .P(d17));
    mult8 m18(.CLK(clk), .A(i_4[data_size*3-1:data_size*2]), .B(w_4[data_size*3-1:data_size*2]), .P(d18));
    mult8 m19(.CLK(clk), .A(i_4[data_size*4-1:data_size*3]), .B(w_4[data_size*4-1:data_size*3]), .P(d19));
    mult8 m20(.CLK(clk), .A(i_4[data_size*5-1:data_size*4]), .B(w_4[data_size*5-1:data_size*4]), .P(d20));
    
    mult8 m21(.CLK(clk), .A(i_5[data_size*1-1:0]),           .B(w_5[data_size*1-1:0]),           .P(d21));
    mult8 m22(.CLK(clk), .A(i_5[data_size*2-1:data_size]),   .B(w_5[data_size*2-1:data_size]),   .P(d22));
    mult8 m23(.CLK(clk), .A(i_5[data_size*3-1:data_size*2]), .B(w_5[data_size*3-1:data_size*2]), .P(d23));
    mult8 m24(.CLK(clk), .A(i_5[data_size*4-1:data_size*3]), .B(w_5[data_size*4-1:data_size*3]), .P(d24));
    mult8 m25(.CLK(clk), .A(i_5[data_size*5-1:data_size*4]), .B(w_5[data_size*5-1:data_size*4]), .P(d25));
    
    assign out_data =  d1+d2+d3+d4+d5+d6+d7+d8+d9+d10+d11+d12+d13+d14+d15+d16+d17+d18+d19+d20+d21+d22+d23+d24+d25;
    
    
endmodule
