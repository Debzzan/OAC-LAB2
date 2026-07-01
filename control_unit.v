// Unidade de controle principal. Decodifica o opcode e gera os sinais de
// controle do datapath.
//   ALUOp:    000=ADD  001=Branch  010=Tipo-R  011=Tipo-I  100=LUI
//   MemtoReg: 00=ALU   01=memória  10=PC+4

module control_unit (
    input  [6:0] opcode,

    output reg        RegWrite,
    output reg        ALUSrc,   // 0 = rs2, 1 = imediato
    output reg        MemWrite,
    output reg        MemRead,
    output reg [1:0]  MemtoReg,
    output reg        Branch,
    output reg [2:0]  ALUOp,
    output reg        Jump,     // JAL
    output reg        JumpR,    // JALR
    output reg        PCtoALU   // AUIPC usa PC como operando A
);

    always @(*) begin
        // Padrão: nenhuma operação ativa
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

        case (opcode)
            // Tipo-R: add, sub, and, or, xor, slt, sll, srl
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b0;
                ALUOp    = 3'b010;
                MemtoReg = 2'b00;
            end

            // Tipo-I ALU: addi, andi, ori, xori, slti, slli, srli
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 3'b011;
                MemtoReg = 2'b00;
            end

            // Load: lw, lhu (endereço = rs1 + imm)
            7'b0000011: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                MemRead  = 1'b1;
                ALUOp    = 3'b000;
                MemtoReg = 2'b01;
            end

            // Store: sw (endereço = rs1 + imm)
            7'b0100011: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 3'b000;
            end

            // Branch: beq, bne (funct3 decide a condição no BranchControl)
            7'b1100011: begin
                ALUSrc   = 1'b0;
                Branch   = 1'b1;
                ALUOp    = 3'b001;
            end

            // JAL: rd = PC+4, PC = PC + imm
            7'b1101111: begin
                RegWrite = 1'b1;
                Jump     = 1'b1;
                MemtoReg = 2'b10;
            end

            // JALR: rd = PC+4, PC = (rs1 + imm) & ~1
            7'b1100111: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                JumpR    = 1'b1;
                ALUOp    = 3'b000;
                MemtoReg = 2'b10;
            end

            // LUI: rd = {imm[31:12], 12'b0}
            7'b0110111: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 3'b100;
                MemtoReg = 2'b00;
            end

            // AUIPC: rd = PC + {imm[31:12], 12'b0}
            7'b0010111: begin
                RegWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp    = 3'b000;
                MemtoReg = 2'b00;
                PCtoALU  = 1'b1;
            end

            // Opcode desconhecido: tudo desativado
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
            end
        endcase
    end

endmodule
