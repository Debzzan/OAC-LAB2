module riscv_cpu (
    input wire clk,
    input wire reset
);

    // -------------------------------------------------------------------------
    // Fios de interconexão (Wires internos)
    // -------------------------------------------------------------------------
    wire [31:0] pc_atual, pc_proximo, pc_mais_4, pc_branch_target;
    wire [31:0] instrucao;
    wire [31:0] lido_reg1, lido_reg2, dado_escrita_reg;
    wire [31:0] imediato;
    wire [31:0] operando_b_alu, resultado_alu;
    wire [31:0] dado_lido_mem;
    wire [3:0]  controle_alu_fio;
    
    // Fios de Controle gerados pela control_unit
    wire branch, mem_read, mem_write, alu_src, reg_write;
    wire [1:0] mem_to_reg; // Declarado com 2 bits baseado nos seus comentários
    wire [2:0] alu_op;     
    wire zero;
    wire pc_src;

    // -------------------------------------------------------------------------
    // 1. Program Counter (PC)
    // -------------------------------------------------------------------------
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_addr(pc_proximo),
        .current_addr(pc_atual)
    );

    // -------------------------------------------------------------------------
    // 2. Somador PC + 4
    // -------------------------------------------------------------------------
    ADDER somador_pc4 (
        .A(pc_atual),
        .B(32'd4),
        .Y(pc_mais_4)
    );

    // -------------------------------------------------------------------------
    // 3. Somador de Branch/Jump (PC + Imediato)
    // -------------------------------------------------------------------------
    ADDER somador_branch (
        .A(pc_atual),
        .B(imediato),
        .Y(pc_branch_target)
    );

    // -------------------------------------------------------------------------
    // 4. Memória de Instruções
    // -------------------------------------------------------------------------
    im mem_instrucoes (
        .addr(pc_atual),
        .inst(instrucao)
    );

    // -------------------------------------------------------------------------
    // 5. Unidade de Controle Principal
    // -------------------------------------------------------------------------
    control_unit controle_principal (
        .opcode(instrucao[6:0]),
        // Saídas
        .Branch(branch),
        .MemRead(mem_read),
        .MemtoReg(mem_to_reg),
        .ALUOp(alu_op),
        .MemWrite(mem_write),
        .ALUSrc(alu_src),
        .RegWrite(reg_write)
    );

    // -------------------------------------------------------------------------
    // 6. Banco de Registradores
    // -------------------------------------------------------------------------
    REGISTERS banco_registradores (
        .clk(clk),
        .reset(reset),
        .RegWrite(reg_write),
        .ReadReg1(instrucao[19:15]),
        .ReadReg2(instrucao[24:20]),
        .WriteReg(instrucao[11:7]),
        .WriteData(dado_escrita_reg),
        .readData_1(lido_reg1),
        .readData_2(lido_reg2)
    );

    // -------------------------------------------------------------------------
    // 7. Gerador de Imediatos
    // -------------------------------------------------------------------------
    imm_gen gerador_imediato (
        .InstrOut(instrucao),
        .ImmOut(imediato)
    );

    // -------------------------------------------------------------------------
    // 8. MUX da entrada B da ULA (ALUSrc)
    // -------------------------------------------------------------------------
    mux2_1 #(32) mux_alu_src (
        .in0(lido_reg2),
        .in1(imediato),
        .sel(alu_src),
        .out(operando_b_alu)
    );

    // -------------------------------------------------------------------------
    // 9. Controle da ULA
    // -------------------------------------------------------------------------
    alu_control controle_da_alu (
        .alu_op(alu_op[ 1 : 0 ]),      
        .funct3(instrucao[ 14 : 12 ]),
        .bit30(instrucao[ 30 ]), // <-- Trinta com espaço para não sumir
        .alu_ctrl_out(controle_alu_fio)
    );

    // -------------------------------------------------------------------------
    // 10. ULA
    // -------------------------------------------------------------------------
    alu ula_principal (
        .readData_1(lido_reg1),
        .readData_2(operando_b_alu),
        .alu_control(controle_alu_fio),
        .alu_result(resultado_alu),
        .zero(zero)
    );

    // -------------------------------------------------------------------------
    // 11. Memória de Dados
    // -------------------------------------------------------------------------
    data_memory mem_dados (
        .clock(clk),
        .ALUOut(resultado_alu),
        .RegOut({32'b0, lido_reg2}), // ATENÇÃO: Ajuste explicado nas observações
        .MemWrite(mem_write),
        .MemRead(mem_read),
        .MemOut(dado_lido_mem)
    );

    // -------------------------------------------------------------------------
    // 12. MUXes de Write Back (MemtoReg de 2 bits)
    // -------------------------------------------------------------------------
    wire [31:0] wb_mux_intermediario;
    
    // Seleciona entre ALU (0) e Memória (1)
    mux2_1 #(32) mux_wb_0 (
        .in0(resultado_alu),
        .in1(dado_lido_mem),
        .sel(mem_to_reg[ 0 ]), // <-- Bit zero com espaço para não sumir
        .out(wb_mux_intermediario)
    );

    // Seleciona entre o resultado anterior (0) e PC+4 (1)
    mux2_1 #(32) mux_wb_1 (
        .in0(wb_mux_intermediario),
        .in1(pc_mais_4),
        .sel(mem_to_reg[ 1 ]), // <-- Bit um com espaço para não sumir
        .out(dado_escrita_reg)
    );

    // -------------------------------------------------------------------------
    // 13. Porta AND do Branch e MUX do Program Counter
    // -------------------------------------------------------------------------
    assign pc_src = branch & zero;

    mux2_1 #(32) mux_pc_next (
        .in0(pc_mais_4),
        .in1(pc_branch_target),
        .sel(pc_src),
        .out(pc_proximo)
    );

endmodule