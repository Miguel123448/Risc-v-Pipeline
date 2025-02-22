`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic Jump,
    input logic JumpReg,
    input logic Halt,
    input logic [31:0] AluResult,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic [31:0] PC_Full;

  assign PC_Full = {23'b0, Cur_PC};

  assign PC_Imm = (JumpReg) ? AluResult : PC_Full + Imm; // JumpReg -> AluResult (if is a jalr instruction, then the instruction add is called); Otherwise, PC_Full + Imm
  assign PC_Four = PC_Full + 32'b100;
  assign Branch_Sel = (Branch && AluResult[0]) || Jump;  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Branch_Sel) ? PC_Imm : ((Halt) ? PC_Full : 0);  // Branch -> PC+Imm   // Otherwise, If halt -> PC_Full (brake pc) // otherwise, 0
  assign PcSel = Branch_Sel || Halt || Jal;  // 1:branch is taken; 0:branch is not taken(choose pc+4)


endmodule


