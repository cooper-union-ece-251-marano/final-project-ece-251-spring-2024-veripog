//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Jaeho Cho & Malek Haddad
// 
//     Create Date: 2023-02-07
//     Module Name: adder
//     Description: simple behavorial adder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef ADDER
`define ADDER

`timescale 1ns / 100ps

module adder #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input Cin,
    output reg [WIDTH-1:0] Sum,
    output reg Cout,
    input EN,              // Enable signal
    input RST              // Reset signal
);

    wire [WIDTH-1:0] internal_sum;
    wire [WIDTH:0] carry; // Extend carry to hold intermediate and final carry out
    assign carry[0] = Cin;

    // Instantiating the full adders
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : full_adder_loop
            full_adder fa (
                .A(A[i]),
                .B(B[i]),
                .Cin(carry[i]),
                .Sum(internal_sum[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    always @* begin
        if (RST) begin
            Sum = 0;
            Cout = 0;
        end else if (EN) begin
            Sum = internal_sum;
            Cout = carry[WIDTH];
        end else begin
            Sum = {WIDTH{1'b0}};
            Cout = 1'b0;
        end
    end

endmodule

module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

`endif
