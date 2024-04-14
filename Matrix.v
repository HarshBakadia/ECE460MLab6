`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2024 03:02:47 PM
// Design Name: 
// Module Name: Matrix
// Project Name: Matrix Multiplier with Floatting Point presentation
// Description: This is main module the miltiplier module and floating point representation
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Connect all together
module Matrix_DUT(input clk, input reset,
                  input[7:0] a00, a01, a02, a10, a11, a12, a20, a21, a22,
                  input[7:0] b00, b01, b02, b10, b11, b12, b20, b21, b22,
                  output[7:0] M1_out, M2_out, M3_out, M4_out, M5_out, M6_out, M7_out, M8_out, M9_out, 
                  output reg done);
    
    //interconnect between MACs              
    wire[7:0] a1_2, a2_3, a4_5, a5_6, a7_8, a8_9;
    wire[7:0] b1_4, b2_5, b3_6, b4_7, b5_8, b6_9;
    
    reg[7:0] a1, a2, a3;
    reg[7:0] b1, b2, b3;
    reg[3:0] state;
    reg[3:0] next_State;
    
    reg en1, en2, en3, en4, en5;                  
    
    initial begin
        state = 0;
        next_State = 0;
        done = 0;
        
        a1 = 0;
        a2 = 0;
        a3 = 0;
        b1 = 0;
        b2 = 0;
        b3 = 0;
        en1 = 0;
        en2 = 0;
        en3 = 0;
        en4 = 0;
        en5 = 0;
    end
    
    parameter t0 = 0, t1 = 1, t2 = 2,
              t3 = 3, t4 = 4, t5 = 5,
              t6 = 6, t7 = 7, tend = 8;     
              
    always @(posedge clk) begin
    
        if(reset) begin
            state = 0;
            next_State = 0;
            done = 0;
            
            a1 = 0;
            a2 = 0;
            a3 = 0;
            b1 = 0;
            b2 = 0;
            b3 = 0;
            en1 = 0;
            en2 = 0;
            en3 = 0;
            en4 = 0;
            en5 = 0;
        end
        else begin
            state = next_State;
            case(state)
                t0: begin
                    a1 = a00;
                    a2 = 0;
                    a3 = 0;
                    b1 = b00;
                    b2 = 0;
                    b3 = 0;
                    en1 = 1;
                    next_State = t1;
                end
                t1: begin
                    a1 = a01;
                    a2 = a10;
                    a3 = 0;
                    b1 = b10;
                    b2 = b01;
                    b3 = 0;
                    en2 = 1;
                    next_State = t2;
                end
                t2: begin
                    a1 = a02;
                    a2 = a11;
                    a3 = a20;
                    b1 = b20;
                    b2 = b11;
                    b3 = b02;
                    en3 = 1;
                    next_State = t3;
                end
                t3: begin
                    a1 = 0;
                    a2 = a12;
                    a3 = a21;
                    b1 = 0;
                    b2 = b21;
                    b3 = b12;
                    en4 = 1;
                    next_State = t4;
                end
                t4: begin
                    a1 = 0;
                    a2 = 0;
                    a3 = a22;
                    b1 = 0;
                    b2 = 0;
                    b3 = b22;
                    en1 = 0;
                    en5 = 1;
                    next_State = t5;
                end
                t5: begin
                    a1 = 0;
                    a2 = 0;
                    a3 = 0;
                    b1 = 0;
                    b2 = 0;
                    b3 = 0;
                    en2 = 0;
                    next_State = t6;
                end
                t6: begin
                    a1 = 0;
                    a2 = 0;
                    a3 = 0;
                    b1 = 0;
                    b2 = 0;
                    b3 = 0;
                    en3 = 0;
                    next_State = t7;
                end
                t7: begin
                    a1 = 0;
                    a2 = 0;
                    a3 = 0;
                    b1 = 0;
                    b2 = 0;
                    b3 = 0;
                    en4 = 0;
                    next_State = tend;
                end
                tend: begin
                    a1 = 0;
                    a2 = 0;
                    a3 = 0;
                    b1 = 0;
                    b2 = 0;
                    b3 = 0;
                    en5 = 0;
                    done = 1;
                end
             
          endcase 
        end   
    end
    
 MAC m1 (.clk(clk), .reset(reset), .en(en1), .in_a(a1), .in_b(b1), .out_a(a1_2), .out_b(b1_4), .out_c(M1_out));
 MAC m2 (.clk(clk), .reset(reset), .en(en2), .in_a(a1_2), .in_b(b2), .out_a(a2_3), .out_b(b2_5), .out_c(M2_out));
 MAC m3 (.clk(clk), .reset(reset), .en(en3), .in_a(a2_3), .in_b(b3), .out_a(), .out_b(b3_6), .out_c(M3_out));
 
 MAC m4 (.clk(clk), .reset(reset), .en(en2), .in_a(a2), .in_b(b1_4), .out_a(a4_5), .out_b(b4_7), .out_c(M4_out));
 MAC m5 (.clk(clk), .reset(reset), .en(en3), .in_a(a4_5), .in_b(b2_5), .out_a(a5_6), .out_b(b5_8), .out_c(M5_out));
 MAC m6 (.clk(clk), .reset(reset), .en(en4), .in_a(a5_6), .in_b(b3_6), .out_a(), .out_b(b6_9), .out_c(M6_out));
 
 MAC m7 (.clk(clk), .reset(reset), .en(en3), .in_a(a3), .in_b(b4_7), .out_a(a7_8), .out_b(), .out_c(M7_out));
 MAC m8 (.clk(clk), .reset(reset), .en(en4), .in_a(a7_8), .in_b(b5_8), .out_a(a8_9), .out_b(), .out_c(M8_out));
 MAC m9 (.clk(clk), .reset(reset), .en(en5), .in_a(a8_9), .in_b(b6_9), .out_a(), .out_b(), .out_c(M9_out));

            
endmodule
