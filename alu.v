module alu (
    input wire [31:0] readData_1,   
    input wire [31:0] readData_2,   
    input wire [3:0]  alu_control,  
    
    output reg [31:0] alu_result,    
    output wire       zero          
);

    always @(*) begin
        case (alu_control)
            4'b0000: alu_result = readData_1 & readData_2; // AND 
            4'b0001: alu_result = readData_1 | readData_2; // OR 
            4'b0010: alu_result = readData_1 + readData_2; // SOMA 
            4'b0110: alu_result = readData_1 - readData_2; // SUBTRAÇÃO 
            4'b0011: alu_result = readData_1 ^ readData_2; // XOR (Ou exclusivo)
            4'b0100: alu_result = readData_1 << readData_2[4:0]; // SLL
            4'b0101: alu_result = readData_1 >> readData_2[4:0]; // SRL
				
            // SLT (Set on Less Than)
            4'b0111: begin
                if ($signed(readData_1) < $signed(readData_2))
                    alu_result = 32'b1;
                else
                    alu_result = 32'b0;
            end
            
            default: alu_result = 32'b0; 
        endcase
    end

    assign zero = (alu_result == 32'b0) ? 1'b1 : 1'b0;

endmodule