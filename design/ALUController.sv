`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

    // os 4 bits de cada instrução estão em alu.sv
always_comb begin 
    case (ALUOp)
        2'b01: begin

            case(Funct3)

                3'b000: begin //beq
                    Operation = 4'b1011; end
                3'b001:begin //bne
                    Operation = 4'b1100; end
                3'b100: begin // blt
                    Operation = 4'b1101; end
                3'b101: begin //bge
                    Operation = 4'b1110;  end 
                default: begin end

            endcase end

        2'b10: begin
            case(Funct3) 
                3'b000: begin

                    case(Funct7)

                        0: begin //add
                            Operation = 0; end
                        7'b0100000: begin // sub
                            Operation = 4'b0001; end
                        default: begin// addi 
                            Operation = 4'b1010; end

                    endcase end

                3'b010: begin

                    case(Funct7)

                        0: begin //slt
                            Operation = 4'b1001; end
                        default: begin // slti
                            Operation = 4'b1000; end

                    endcase end

                3'b001: begin

                    case(Funct7)

                        0: begin //slli
                            Operation = 4'b0101; end
                        default begin end

                    endcase end

                3'b101: begin

                    case(Funct7)

                        0: begin // srli
                            Operation = 4'b0110; end
                        7'b0100000: begin //srai
                            Operation = 4'b0111; end
                        default begin end

                    endcase end

                3'b100: begin

                    Operation = 4'b0100; end //xor

                3'b110: begin

                    Operation = 4'b0011; end //or

                3'b111: begin

                    Operation = 4'b0010; end //and

            endcase end

        2'b11: begin //lui

            Operation = 4'b1111; end

        default begin end  

    endcase
 
end
endmodule
