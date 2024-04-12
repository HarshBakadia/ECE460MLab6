`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UT Austin
// Engineer: Harsh Bakadia
// 
// Create Date: 04/10/2024 02:42:51 PM
// Design Name: 
// Module Name: add2c
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


module add2c(input [7:0] x, input [7:0] y, output reg[7:0] z);
    
    reg[7:0] Big;
    reg[7:0] Small;
    reg[2:0] shift;
    reg[9:0] big_Num;
    reg[9:0] small_Num;
    reg[9:0] result;
    
    reg sign;
    reg[2:0] exponent;
    reg[3:0] fraction;
    
    initial begin
        z = 0;
        Big = 0;
        Small = 0;
        shift = 0;
        big_Num = 0;
        small_Num = 0;
        result = 0;
    end
    
    always @(*) begin
        //If either a or b is 0
        if(x[6:0] == 0 || y[6:0] == 0) begin
            if(x[6:0] != 0)         z=x;    //only y is 0
            else if(y[6:0] != 0)    z=y;    //only x is 0
            else                    z=0;    //both are 0
        end
        else begin
            //Comparison for sign assignment and exponent based on larger
            if(x[6:0] > y[6:0]) begin
                Big = x;
                Small = y;
            end
            else begin
                Small = x;
                Big = y;
            end
            
            //sign and inital exponent assigned based on larger
            sign = Big[7];
            exponent = Big[6:4];
            
            //assigning value before shift
            big_Num = {1'b1, Big[3:0], 5'b0};
            small_Num = {1'b1, Small[3:0], 5'b0};
            
            //Matching the exponents, alligning the fraction
            shift = Big[6:4] - Small[6:4];
            small_Num = small_Num >> shift;
            
            //If negative + positive magnitude decreases else magnitude increases
            if(Big[7] == Small[7]) 
                result = big_Num + small_Num;
            else
                result = big_Num - small_Num;
            
            //Normalize by findind leftmost 1 and shifting
            //
            if(result[10] == 1) begin
                fraction = result[9:6];
                exponent = exponent + 1; //shift number one to left 
            end 
            else if(result[9] == 1) begin
                fraction = result[8:5];
            end
            else if(result[8] == 1) begin
                fraction = result[7:4];
                exponent = exponent - 1;
            end
            else if(result[7] == 1) begin
                fraction = result[6:3];
                exponent = exponent - 2;
            end
            else if(result[6] == 1) begin
                fraction = result[5:2];
                exponent = exponent - 3;
            end
            else if(result[5] == 1) begin
                fraction = result[4:1];
                exponent = exponent - 4;
            end
            else if(result[4] == 1) begin
                fraction = result[3:0];
                exponent = exponent - 5;
            end
            else begin
                fraction = 0;
                exponent = 0;
            end
            z = {sign, exponent, fraction};
        end
    end
endmodule
