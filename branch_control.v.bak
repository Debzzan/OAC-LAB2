module BranchControl (
    input wire Branch,         // Sinal vindo da Unidade de Controle Principal
    input wire Zero,           // Sinal vindo da ULA
    input wire [2:0] funct3,   // Bits [14:12] da instrução para saber o tipo de salto
    
    output reg PcSrc           // Sinal que vai para o MUX do PC (1 = pula, 0 = não pula)
);

    always @(*) begin
        if (Branch) begin
            case (funct3)
                3'b000: PcSrc = Zero;   // BEQ: Pula se for IGUAL (Zero == 1)
                3'b001: PcSrc = ~Zero;  // BNE: Pula se for DIFERENTE (Zero == 0)
                default: PcSrc = 1'b0;
            endcase
        end else begin
            PcSrc = 1'b0; // Se não for instrução de Branch, nunca pule
        end
    end
endmodule