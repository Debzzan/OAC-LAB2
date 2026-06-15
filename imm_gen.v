// imm_gen - Gerador de Imediato 
// ----------------------------------------------------------------------------
// Recebe a instrucao de 32 bits (InstrOut) e produz o imediato de 32 bits
// (ImmOut) com extensao de sinal, montando os campos conforme o formato da
// instrucao (identificado pelo opcode em InstrOut[6:0]).
//
// Formatos suportados: I, S, B, U e J.
module imm_gen (
    input  [31:0] InstrOut,   // instrucao
    output reg [31:0] ImmOut  // saida com sinal e considerando o bit shift do branch
);

    wire [6:0] opcode = InstrOut[6:0];

    // Tabela pagina 126 do Paterson + Reference guide Vidal
    always @(*) begin
        case (opcode)

            // ---- Formato I ----
            // lw / lhu (0000011), ALU imediato addi/slti/andi/ori/xori (0010011),
            // jalr (1100111). Imediato = 20*InstrOut[31]::InstrOut[31:20]
            // Usa func7 e rs2
            7'b0000011,
            7'b0010011,
            7'b1100111:
                ImmOut = {{20{InstrOut[31]}}, InstrOut[31:20]};

            // ---- Formato S ----
            // sw (0100011). Imediato = 20*InstrOut[31]::InstrOut[31:25]::InstrOut[11:7]
            // Usa func7 e rd
            7'b0100011:
                ImmOut = {{20{InstrOut[31]}}, InstrOut[31:25], InstrOut[11:7]};

            // ---- Formato B ----
            // beq / bne (1100011). Imediato (offset de desvio) deslocado de 1 bit:
            // 20*InstrOut[31] InstrOut[7]::InstrOut[30:25]::InstrOut[11:8]::0
            // Usa func7 e rd
            7'b1100011:
                ImmOut = {{20{InstrOut[31]}}, InstrOut[7],
                          InstrOut[30:25], InstrOut[11:8], 1'b0};

            // ---- Formato U ----
            // lui (0110111) e auipc (0010111)(reference guide). Imediato = InstrOut[31:12]::12*0
            // Usa func7, rs2, rs1 e func3
            7'b0110111,
            7'b0010111:
                ImmOut = {InstrOut[31:12], 12'b0};

            // ---- Formato J ----
            // jal (1101111). Imediato deslocado de 1 bit:
            // {InstrOut[31], InstrOut[19:12], InstrOut[20], InstrOut[30:21], 0}
            // Usa func7, rs2, rs1 e func3
            7'b1101111:
                ImmOut = {{12{InstrOut[31]}}, InstrOut[19:12],
                          InstrOut[20], InstrOut[30:21], 1'b0};

            // ---- Demais casos (ex.: formato R, sem imediato) ----
            default:
                ImmOut = 32'b0;

        endcase
    end

endmodule
