`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
        // adicionar operacoes condicionais e aritmeticas
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0010:        // ADD
                    ALUResult = SrcA + SrcB;
            4'b1000:        // BEQ
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
        /*
            OR = 0011
            XOR = 0100
            SRAI = 0101
            SLLI = 0110
            SLT E SLTI = 0111
            SRLI = 1001
            BGE = 1010
            BLT = 1011
            BNE = 1100
            LUI = 1101
        */
            default:
                    ALUResult = 0;
            endcase
        end
endmodule

