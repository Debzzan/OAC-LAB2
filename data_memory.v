module data_memory ( 
    input wire        clock,        
    input wire [31:0] ALUOut,       
    input wire [31:0] WriteData,    
    input wire        MemWrite,     
    input wire        MemRead,      
    output reg [31:0] MemOut       // <-- VOLTOU PARA REG
);

    (* ram_init_file = "UnicicloData.mif" *) reg [31:0] mem [0:32767];

    // LEITURA NA BORDA DE DESCIDA (meio do ciclo)
    always @(negedge clock) begin
        MemOut <= mem[ALUOut[14:2]];
    end

    // ESCRITA NA BORDA DE SUBIDA (início/fim do ciclo)
    always @(posedge clock) begin
        if (MemWrite)
            mem[ALUOut[14:2]] <= WriteData;
    end

endmodule