module alu_control (
    input wire [2:0] alu_op,       
    input wire [2:0] funct3,       
    input wire       bit30,        
    
    output reg [3:0] alu_ctrl_out,
    output reg       illegal       
);

    always @(*) begin
        illegal = 1'b0;
        case (alu_op)
            // 3'b000: lw, sw -> soma
            3'b000: alu_ctrl_out = 4'b0010;

            // 3'b001: beq, bne -> subtração
            3'b001: alu_ctrl_out = 4'b0110;

            // 3'b010: Tipo-R (bit30 diferencia ADD de SUB)
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

                    default: begin
                        alu_ctrl_out = 4'b0000;
                        illegal      = 1'b1; // funct3 desconhecido no Tipo-R
                    end
                endcase
            end

            // 3'b011: Tipo-I (ignora bit30 no funct3 000; addi sempre soma)
            3'b011: begin
                case (funct3)
                    3'b000: alu_ctrl_out = 4'b0010; // ADDI
                    3'b111: alu_ctrl_out = 4'b0000; // ANDI
                    3'b110: alu_ctrl_out = 4'b0001; // ORI
                    3'b100: alu_ctrl_out = 4'b0011; // XORI
                    3'b010: alu_ctrl_out = 4'b0111; // SLTI

                    default: begin
                        alu_ctrl_out = 4'b0000;
                        illegal      = 1'b1; // funct3 desconhecido no Tipo-I
                    end
                endcase
            end

            3'b100: alu_ctrl_out = 4'b1000; // LUI -> passa o imediato (operando B)

            default: begin
                alu_ctrl_out = 4'b0010;
                illegal      = 1'b1; // alu_op desconhecido
            end
        endcase
    end
endmodule
