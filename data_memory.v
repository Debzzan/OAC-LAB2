module data_memory ( 
    input wire        clock,        
    input wire [31:0] ALUOut,       
    input wire [31:0] WriteData,    
    input wire        MemWrite,     
    input wire        MemRead,      // Mantemos a porta declarada para não quebrar os fios do Top-Level
    output reg [31:0] MemOut        
);

    // Vetor com as 32768 posições exigidas!
    (* ram_init_file = "UnicicloData.mif" *) reg [31:0] mem [0:32767];

    // Leitura SÍNCRONA CONTÍNUA na borda de DESCIDA (sem if/else)
    // Isso garante 100% de inferência dos blocos de RAM do Quartus
    always @(negedge clock) begin
        MemOut <= mem[ALUOut[16:2]];
    end

    // Escrita SÍNCRONA na borda de SUBIDA (padrão)
    always @(posedge clock) begin
        if (MemWrite)
            mem[ALUOut[16:2]] <= WriteData;
    end

endmodule