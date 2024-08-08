# RESUMO

Segue o detalhamento de cada alteração feita para implementação das instruções.

---

## Arquivos alterados

- [`ALUController.sv`](/design/ALUController.sv)
- [`BranchUnit.sv`](/design/BranchUnit.sv)
- [`Controller.sv`](/design/Controller.sv)
- [`Datapath.sv`](/design/Datapath.sv)
- [`RISC_V.sv`](/design/RISC_V.sv)
- [`RegPack.sv`](/design/RegPack.sv)
- [`alu.sv`](/design/alu.sv)
- [`datamemory.sv`](/design/datamemory.sv)
- [`imm_Gen.sv`](/design/imm_Gen.sv)
- [`assembler.py`](/verif/assembler.py)

---

## Instruções aritméticas
add, sub, addi, or, and, xor, slt, slti, srai, slli, srli, beq, bge, blt, bne

### Arquivos modificados

[`ALUController.sv`](/design/ALUController.sv)
[`alu.sv`](/design/alu.sv)
[`imm_Gen.sv`](/design/imm_Gen.sv)
[`Controller.sv`](/design/Controller.sv)

### Modificações feitas

-alu.sv

  -Dentro de alu.sv, em um always comb, cada operação é selecionada com base em um registrador de 4 bits (a escolha dos 4 bits para cada instrução foi feita de forma aleatória, sem seguir um padrão)
  
-ALUController.sv

  -Aqui é feito um always comb para passar cada instrução para sua devida operação.
  -Inicialmente faz um case de ALUOp. ALUOp = 00: LOAD-STORE, ALUOp = 01: Branch, ALUOp = 10: Rtype, Itype, ALUOp = 11: Jump, Lui
  -O funct3 e o funct7 de cada instrução está nesse link [`isa`](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html?authuser=0#lui)
  -O funct7 e o funct3 são os bits, 31-25 e 14-12, respectivamente.
  
-imm_Gen

  -Nesse arquivo precisamos adicionar o imm_out do I-type (sinceramente, de tudo, foi a única coisa que eu não entendi).
  
-Controller.sv

  -Aqui foi feito o assign de escrita de registrador, leitura, desvio, ALUOp, etc.
  -Se ALUSrc estiver definido para 1, o segundo operando será um valor imediato, que vem da própria instrução.
  -MemtoReg deve ser definido para 1 quando algum registrador precisar ser escrito por um valor da memória (Load).
  -RegWrite deve ser definido para 1 sempre que houver escrita de registrador.
  -MemRead deve ser definido para 1 quando a memória precisar ser lida.
  -MemWrite deve ser definido para 1 quando a memória precisar ser escrita.
  -As duas seguintes definem o valor de ALUOp.
  
  obs: O Opcode são os bits 6-0 de cada instrução em [`isa`](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html?authuser=0#lui)

---

# Instruções de Load-Store
lw,lh,lb,lbu,sw,sh,sb

### Arquivos modificados

[`Controller.sv`](/design/Controller.sv)
[`datamemory.sv`](/design/datamemory.sv)

### Modificações feitas

-datamemory.sv

  -Dentro do always, se MemRead for 1, as instruções de load são chamadas, caso MemWrite seja 1, as instruções de store são chamadas.
  -É utilizado o funct3 de cada instrução.
  -O wd nas instruções de store, significa quantos bits serão escritos, por exemplo: no SW, todos os bits são escritos, então wd = 4'b1111. No SB, apenas 8 bits são escritos, então wd = 4'b0001.
  
---

# Instruções de jump, jump-register e halt
jal, jalr, halt

### Arquivos modificados

[`BranchUnit.sv`](/design/BranchUnit.sv)
[`Controller.sv`](/design/Controller.sv)
[`Datapath.sv`](/design/Datapath.sv)
[`RISC_V.sv`](/design/RISC_V.sv)
[`RegPack.sv`](/design/RegPack.sv)
[`assembler.py`](/verif/assembler.py)

### Modificações feitas

-BranchUnit.sv

  -Pc_Imm foi alterado para que, caso seja uma instrução jalr, Pc_Imm seja ALUResult (instrução addi é chamada para fazer a soma do registrador com o imediato), se não Pc_Imm = PC_Full + Imm.
  -Branch_sel foi alterado para considerar também, o caso de ser uma instrução jal.
  -O halt é implementado aqui. Caso não seja uma instrução de branch, é verificado se é a instrução Halt, caso seja, o Pc é travado.
  -Pc_sel foi alterado para considerar caso seja uma instrução halt, nesse caso branch é tomado, e o código é finalizado.
  
-Datapath.sv

  -As entradas lógicas jump, jumpreg e halt foram adicionadas 
  
-RISC_V

  -Jump, Jumpreg e halt foram passados como input nos módulos.
  
-RegPack.sv

  -Jump, JumpReg, e Halt foram adicionados aos pacotes de registradores, porém apenas Jump é adicionado no C e no D.
  
-Controller.sv

  -Foi feito o assign do Jump, JumpReg e do halt.

-assembler.py

  -Como a instrução halt não faz parte do conjunto de instruções do RV32I, o assembler não reconhecia a instrução, e consequentemente não dava pra testar. Portanto eu adicionei o halt ao conjunto de instruções no assembler.
  -Associei Halt ao Opcode 7'b1111111
  -O binário é criado a partir de imm que é um binário de 25 bits zerado + Opcode.
  
  obs: Por algum motivo, quando é utilizado apenas o halt, o assembler não reconhece como uma função válida, então o halt é utilizado com um registrador logo após (unused)
  ex. halt x0 || halt x5
  
  


