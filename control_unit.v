// Unidade de Controle Principal — RISC-V32I Ciclo Único
// Recebe o opcode (bits [6:0] da instrução) e gera os sinais de controle do datapath.
//
// Codificação do ALUOp (enviado para ALU_CONTROL):
//   3'b000 = ADD        (load / store / jalr / auipc)
//   3'b001 = Branch     (beq / bne — ALU_CONTROL usa funct3)
//   3'b010 = Tipo-R     (ALU_CONTROL usa funct3 + funct7[5])
//   3'b011 = Tipo-I ALU (ALU_CONTROL usa funct3)
//   3'b100 = LUI        (ALU_CONTROL deve executar operação PASSA-B)
//
// Codificação do MemtoReg (fonte do dado escrito no registrador):
//   2'b00 = Resultado da ALU   (Tipo-R / Tipo-I / auipc / lui)
//   2'b01 = Dado da memória    (load)
//   2'b10 = PC + 4             (jal / jalr — endereço de retorno)

module control_unit (
    input  [6:0] opcode,       // opcode da instrução (bits 6 a 0)
    input  [2:0] funct3,       // usado para validar instrucoes load/store/branch/jalr

    output reg        RegWrite, // habilita escrita no banco de registradores
    output reg        ALUSrc,   // 0 = usa rs2, 1 = usa imediato como 2º operando da ALU
    output reg        MemWrite, // habilita escrita na memória de dados
    output reg        MemRead,  // habilita leitura da memória de dados
    output reg [1:0]  MemtoReg, // seleciona origem do dado a escrever no registrador
    output reg        Branch,   // sinaliza desvio condicional (beq / bne)
    output reg [2:0]  ALUOp,    // informa à ALU_CONTROL qual decodificação aplicar
    output reg        Jump,     // JAL  — salto incondicional relativo ao PC
    output reg        JumpR,    // JALR — salto para rs1 + imediato
    output reg        PCtoALU,  // AUIPC: usa o PC como primeiro operando da ALU
    output reg        InstrucaoInvalida
);

    always @(*) begin
        // Valores padrão seguros (nenhuma operação ativa)
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemWrite = 1'b0;
        MemRead  = 1'b0;
        MemtoReg = 2'b00;
        Branch   = 1'b0;
        ALUOp    = 3'b000;
        Jump     = 1'b0;
        JumpR    = 1'b0;
        PCtoALU  = 1'b0;
        InstrucaoInvalida = 1'b0;

        case (opcode)
            // Tipo-R: add, sub, and, or, xor, slt, sll, srl
            // Lê dois registradores, opera na ALU, escreve resultado no rd
            7'b0110011: begin
                RegWrite = 1'b1;  // escreve resultado em rd
                ALUSrc   = 1'b0;  // segundo operando vem de rs2
                ALUOp    = 3'b010; // ALU_CONTROL decide operação via funct3/funct7
                MemtoReg = 2'b00; // resultado vem da ALU
            end

            // Tipo-I ALU: addi, andi, ori, xori, slti, slli, srli
            // Lê rs1 e um imediato, opera na ALU, escreve resultado no rd
            7'b0010011: begin
                RegWrite = 1'b1;  // escreve resultado em rd
                ALUSrc   = 1'b1;  // segundo operando é o imediato
                ALUOp    = 3'b011; // ALU_CONTROL decide operação via funct3
                MemtoReg = 2'b00; // resultado vem da ALU
            end

            // Load: lw, lhu (funct3 distingue na DATA_MEMORY)
            // Calcula endereço (rs1 + imm), lê memória, escreve dado em rd
            7'b0000011: begin
                if (funct3 == 3'b010) begin // LW
                    RegWrite = 1'b1;  // escreve dado lido em rd
                    ALUSrc   = 1'b1;  // endereço = rs1 + imediato
                    MemRead  = 1'b1;  // habilita leitura da memória
                    ALUOp    = 3'b000; // ALU faz soma para calcular endereço
                    MemtoReg = 2'b01; // dado vem da memória
                end else begin
                    InstrucaoInvalida = 1'b1;
                end
            end

            // Store: sw
            // Calcula endereço (rs1 + imm), escreve rs2 na memória
            7'b0100011: begin
                if (funct3 == 3'b010) begin // SW
                    ALUSrc   = 1'b1;  // endereço = rs1 + imediato
                    MemWrite = 1'b1;  // habilita escrita na memória
                    ALUOp    = 3'b000; // ALU faz soma para calcular endereço
                    // RegWrite = 0: não escreve em registrador
                end else begin
                    InstrucaoInvalida = 1'b1;
                end
            end

            // Branch: beq, bne (funct3 trata a condição na lógica de desvio)
            // Compara rs1 e rs2; se condição verdadeira, PC = PC + imm
            7'b1100011: begin
                if ((funct3 == 3'b000) || (funct3 == 3'b001)) begin // BEQ/BNE
                    ALUSrc   = 1'b0;  // segundo operando vem de rs2 (para comparação)
                    Branch   = 1'b1;  // sinaliza possível desvio
                    ALUOp    = 3'b001; // ALU faz subtração para comparar
                end else begin
                    InstrucaoInvalida = 1'b1;
                end
            end

            // JAL: rd = PC+4, PC = PC + imm (salto incondicional relativo)
            7'b1101111: begin
                RegWrite = 1'b1;  // salva endereço de retorno (PC+4) em rd
                Jump     = 1'b1;  // ativa salto JAL
                MemtoReg = 2'b10; // valor escrito em rd é PC+4
            end

            // JALR: rd = PC+4, PC = (rs1 + imm) & ~1 (salto incondicional absoluto)
            7'b1100111: begin
                if (funct3 == 3'b000) begin
                    RegWrite = 1'b1;  // salva endereço de retorno (PC+4) em rd
                    ALUSrc   = 1'b1;  // endereço alvo = rs1 + imediato
                    JumpR    = 1'b1;  // ativa salto JALR
                    ALUOp    = 3'b000; // ALU faz soma rs1 + imm
                    MemtoReg = 2'b10; // valor escrito em rd é PC+4
                end else begin
                    InstrucaoInvalida = 1'b1;
                end
            end

            // LUI: rd = {imm[31:12], 12'b0} (carrega imediato nos bits altos)
            7'b0110111: begin
                RegWrite = 1'b1;  // escreve imediato deslocado em rd
                ALUSrc   = 1'b1;  // operando B da ALU é o imediato
                ALUOp    = 3'b100; // ALU_CONTROL deve executar PASSA-B (só repassa imm)
                MemtoReg = 2'b00; // resultado vem da ALU
            end

            // AUIPC: rd = PC + {imm[31:12], 12'b0} (PC + imediato nos bits altos)
            7'b0010111: begin
                RegWrite = 1'b1;  // escreve resultado em rd
                ALUSrc   = 1'b1;  // operando B da ALU é o imediato
                ALUOp    = 3'b000; // ALU faz soma PC + imm
                MemtoReg = 2'b00; // resultado vem da ALU
                PCtoALU  = 1'b1;  // operando A da ALU é o PC (não rs1)
            end

            // Opcode desconhecido: mantém todos os sinais desativados
            default: begin
                RegWrite = 1'b0;
                ALUSrc   = 1'b0;
                MemWrite = 1'b0;
                MemRead  = 1'b0;
                MemtoReg = 2'b00;
                Branch   = 1'b0;
                ALUOp    = 3'b000;
                Jump     = 1'b0;
                JumpR    = 1'b0;
                PCtoALU  = 1'b0;
                InstrucaoInvalida = 1'b1;
            end
        endcase
    end

endmodule
