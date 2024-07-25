`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch  //0: branch is not taken; 1: branch is taken
);

  logic [6:0] R_TYPE, LOAD, STORE, BR, I_TYPE, LUI, JAL, JALR;

  assign R_TYPE = 7'b0110011;  // instrucoes reg
  assign LOAD = 7'b0000011;  // instrucoes de load
  assign STORE = 7'b0100011;  //instrucoes de store
  assign BR = 7'b1100011;  // instrucoes de branch
  assign I_TYPE = 7'b0010011; // instrucoes imediatas
  assign LUI = 7'b0110111; // instrucao lui
  assign JAL = 7'b1101111; // instrucao jump
  assign JALR = 7'b1100111


// ajustar as condicoes 
  assign ALUSrc = (Opcode == LOAD || Opcode == STORE);
  assign MemtoReg = (Opcode == LOAD);
  assign RegWrite = (Opcode == R_TYPE || Opcode == LOAD);
  assign MemRead = (Opcode == LOAD);
  assign MemWrite = (Opcode == STORE);
  assign ALUOp[0] = (Opcode == BR);
  assign ALUOp[1] = (Opcode == R_TYPE);
  assign Branch = (Opcode == BR);
endmodule
