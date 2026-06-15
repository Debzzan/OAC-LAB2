// data_memory - Memoria de Dados Uniciclo
// ----------------------------------------------------------------------------
// Memoria de dados (organizacao Harvard) 
// Inicializada por um arquivo .mif
//
// Como ALUOut e um endereco em BYTES, descartamos os 2 bits baixos
// (ALUOut[1:0]) para obter o indice de palavra.
//
// Escrita: sincrona (na borda de subida de clock) quando MemWrite = 1  -> sw
// Leitura: assincrona quando MemRead = 1                               -> lw/lhu
module data_memory (
    input         clock,        // escrita (sw)
    input  [31:0] ALUOut,       // endereco em bytes (resultado da ULA)
    input  [63:0] RegOut,       // saidas do banco de registradores; [63:32] = dados armazenados em rs2
    input         MemWrite,     // ativa escrita na memoria
    input         MemRead,      // ativa leitura da memoria
    output [31:0] MemOut        // dado lido da memoria
);

    // DEPTH = 32768 palavras ( .mif gerado no Lab 1).
    // 32768 = 2^15  ->  usa 15 bits.
    parameter DEPTH = 32768;

    // Inicializacao da memoria 
    (* ram_init_file = "UnicicloData.mif" *)
    reg [31:0] mem [0:DEPTH-1];

    // Converte endereco de byte (ALUOut) em indice de palavra:
    // descarta ALUOut[1:0] e usa  ALUOut[16:2].
    wire [14:0] word_index = ALUOut[16:2];

    // Escrita (sw): sincrona, somente quando MemWrite=1 ----
    always @(posedge clock) begin
        if (MemWrite)
            mem[word_index] <= RegOut[63:32];  // dado de rs2
    end

    // Leitura (lw/lhu): assincrona; quando MemRead=, caso contrario saida 0 ----
    assign MemOut = MemRead ? mem[word_index] : 32'b0;

endmodule