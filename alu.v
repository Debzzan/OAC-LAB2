module alu (
    input wire [31:0] operando_a,   
    input wire [31:0] operando_b,   
    input wire [3:0]  alu_control,  
    
    output reg [31:0] resultado,    
    output wire       zero          
);

    always @(*) begin
        case (alu_control)
            4'b0000: resultado = operando_a & operando_b; // AND 
            4'b0001: resultado = operando_a | operando_b; // OR 
            4'b0010: resultado = operando_a + operando_b; // SOMA 
            4'b0110: resultado = operando_a - operando_b; // SUBTRAÇÃO 
            4'b0011: resultado = operando_a ^ operando_b; // XOR (Ou exclusivo)
            // Para deslocamentos no RISC-V32I, usamos apenas os 5 bits menos significativos do operando B
            4'b0100: resultado = operando_a << operando_b[4:0]; // SLL
            4'b0101: resultado = operando_a >> operando_b[4:0]; // SRL
				
            // SLT (Set on Less Than)
            4'b0111: begin
                if ($signed(operando_a) < $signed(operando_b))
                    resultado = 32'b1;
                else
                    resultado = 32'b0;
            end
            
            default: resultado = 32'b0; 
        endcase
    end

    assign zero = (resultado == 32'b0) ? 1'b1 : 1'b0;

endmodule