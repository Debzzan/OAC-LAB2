module alu_control (
    input wire [1:0] alu_op,       
    input wire [2:0] funct3,       
    input wire       bit30,        
    
    output reg [3:0] alu_ctrl_out  
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl_out = 4'b0010; // lw, sw -> SOMA
            2'b01: alu_ctrl_out = 4'b0110; // beq, bne -> SUBTRAÇÃO
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if (bit30 == 1'b1)
                            alu_ctrl_out = 4'b0110; // SUB
                        else
                            alu_ctrl_out = 4'b0010; // ADD (add, addi)
                    end
                    3'b111: alu_ctrl_out = 4'b0000; // AND / andi
                    3'b110: alu_ctrl_out = 4'b0001; // OR / ori
                    3'b100: alu_ctrl_out = 4'b0011; // XOR / xori
                    3'b010: alu_ctrl_out = 4'b0111; // SLT / slti                    
                    3'b001: alu_ctrl_out = 4'b0100; // SLL (Deslocamento à esquerda)
                    3'b101: alu_ctrl_out = 4'b0101; // SRL (Deslocamento à direita)
                    
                    default: alu_ctrl_out = 4'b0000;
                endcase
            end
            default: alu_ctrl_out = 4'b0000;
        endcase
    end
endmodule