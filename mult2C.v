`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UT Austin
// Engineer: Harsh Bakadia
// 
// Create Date: 04/07/2024 11:40:52 PM
// Design Name: 
// Module Name: mult2C
// Project Name: Matrix multiplication
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

module mult2C (input[7:0] a, input[7:0] b, output reg[7:0] c);

    reg sign;
    reg[2:0] exponent;
    reg[3:0] mantissa;
    reg[9:0] result;
    
    //Initialise to zero, might be unnecessary as FPGA does this
    initial begin
        c = 0;
        sign = 0;
        exponent = 0;
        mantissa = 0;
        result = 0;
    end
    
    always @(*) begin
        //If either a or b is 0
        if(a == 0 || b == 0)
            c = 0;
        else if((a[7] == 1 && a[6:0] == 0) || (b[7] == 1 && b[6:0] == 0)) begin
            c = 0;
        end 
        else begin
            //sign bit, if same give 0 else 1
            sign = ((a[7] & !b[7]) || (!a[7] & b[7]))? 1: 0;
            
            //exponent, -3 as otherwise it will be twice the bias
            exponent = (a[6:4] + b[6:4]) - 3;
            
            //multiplication of 2 5 bit(1 for sign 4 for fraction) values is 10
            result = {1, a[3:0]} * {1, b[3:0]}; //first 1 in both is implied
            
            //mantissa
            //decides based on the top 2 bit values as 1 < 1.frac*1.frac < 4
            if(result[9]) begin
                mantissa = result[8:5];
                exponent = exponent + 1;
            end
            else begin
                mantissa = result[7:4];
            end
            
            c = {sign, exponent, mantissa};
        end
    end
    
endmodule