// Memória de instruções 
module im (
	input wire clk,
	input wire [ 31 : 0 ] addr,  // Endereço da próxima instrução (vindo do pc)
	output reg [ 31 : 0 ] inst   // Instrução atual carregada pelo endereço
);

    // DEPTH = 32768 palavras ( .mif gerado no Lab 1).
    // 32768 = 2^15  ->  usa 15 bits.
    parameter DEPTH = 32768;

    // Inicializacao da memoria 
    (* ram_init_file = "UnicicloInst.mif" *) reg [ 31 : 0 ] inst_mem [ 0 : DEPTH-1 ];

	 
    always @(negedge clk) begin
        // CORREÇÃO: Usando <= para bloco síncrono e extraindo exatos 15 bits (16 até 2)
        inst <= inst_mem[addr[ 16 : 2 ]];
    end

endmodule