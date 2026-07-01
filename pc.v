// Program Counter
module pc (
	input wire clk,
	input wire reset,
	input wire halt,             
	input wire [31:0] next_addr,  // Endereço da próxima instrução (calculado pelo somador)
	output reg [31:0] current_addr  // Endereço da instrução atual (enviado para a memória de instruções)
);

// Lógica sequencial
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			current_addr <= 32'h00400000;  // Endereço de início do .text
		end
		else if (halt == 1'b1) begin
			current_addr <= current_addr;  
		end
		else begin
			current_addr <= next_addr;
	end
end

endmodule
