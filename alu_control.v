module alu_control (
    input wire [2:0] alu_op,       
    input wire [2:0] funct3,       
    input wire       bit30,        
    
    output reg [3:0] alu_ctrl_out  
);

    always @(*) begin
        case (alu_op)
            // ----------------------------------------------------
            // 3'b000: lw, sw -> FORÇA SOMA
            // ----------------------------------------------------
            3'b000: alu_ctrl_out = 4'b0010; 
            
            // ----------------------------------------------------
            // 3'b001: beq, bne -> FORÇA SUBTRAÇÃO
            // ----------------------------------------------------
            3'b001: alu_ctrl_out = 4'b0110; 
            
            // ----------------------------------------------------
            // 3'b010: TIPO-R (add, sub, and, or...) 
            // Usa o bit30 para diferenciar ADD de SUB
            // ----------------------------------------------------
            3'b010: begin
                case (funct3)
                    3'b000: begin
                        if (bit30 == 1'b1)
                            alu_ctrl_out = 4'b0110; // SUB (Subtração)
                        else
                            alu_ctrl_out = 4'b0010; // ADD (Soma)
                    end
                    3'b111: alu_ctrl_out = 4'b0000; // AND
                    3'b110: alu_ctrl_out = 4'b0001; // OR
                    3'b100: alu_ctrl_out = 4'b0011; // XOR
                    3'b010: alu_ctrl_out = 4'b0111; // SLT                  
                    3'b001: alu_ctrl_out = 4'b0100; // SLL
                    3'b101: alu_ctrl_out = 4'b0101; // SRL
                    
                    default: alu_ctrl_out = 4'b0000;
                endcase
            end

            // ----------------------------------------------------
            // 3'b011: TIPO-I (addi, andi, ori...)
            // IGNORA o bit30 no funct3 == 000 para SEMPRE SOMAR!
            // ----------------------------------------------------
            3'b011: begin
                case (funct3)
                    3'b000: alu_ctrl_out = 4'b0010; // ADDI -> SOMA SEMPRE!
                    
                    3'b111: alu_ctrl_out = 4'b0000; // ANDI
                    3'b110: alu_ctrl_out = 4'b0001; // ORI
                    3'b100: alu_ctrl_out = 4'b0011; // XORI
                    3'b010: alu_ctrl_out = 4'b0111; // SLTI                  
                    3'b001: alu_ctrl_out = 4'b0100; // SLLI
                    3'b101: alu_ctrl_out = 4'b0101; // SRLI
                    
                    default: alu_ctrl_out = 4'b0000;
                endcase
            end

            // ----------------------------------------------------
            // Default de segurança
            // ----------------------------------------------------
            default: alu_ctrl_out = 4'b0010; // Default para SOMA
        endcase
    end
endmodule