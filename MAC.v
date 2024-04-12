`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2024 08:01:05 PM
// Design Name: 
// Module Name: MAC
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


module MAC(input clk, input reset, input en, input[7:0] in_a, input[7:0] in_b,
            output reg[7:0] out_a, output reg[7:0] out_b, output reg[7:0] out_c);
           
        wire[7:0] result_m;
        wire[7:0] result_a;
               
        initial begin
            out_a = 0;
            out_b = 0;
            out_c = 0;
        end
        
        mult2C m(.a(in_a), .b(in_b), .c(result_m));
        add2C a(.x(out_c), .y(result_m), .z(result_a));
        
        always @(posedge clk) begin
            if(reset) begin
                out_a = 0;
                out_b = 0;
                out_c = 0;
            end
            else begin
                if(en) begin
                    out_c = result_a;
                end
                
                out_a = in_a;
                out_b = in_b;
            end
        end
           
endmodule
