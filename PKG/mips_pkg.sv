package mips_pkg;

    //Global variables
    longint instruction_int;
    bit [31:0] instruction_32_bin;
    int converted;
    
    //Variables for decoding
    //For R-Type and I-Type Formats
    bit [5:0] op_code;
    logic signed [4:0] rs;
    logic signed [4:0] rt;
    logic signed [4:0] rd;
    logic signed [31:0] data_rs;
    logic signed [31:0] data_rt;
    bit [4:0] shamt;
    bit [5:0] funct;
    shortint signed immediate_offset;      
    int signed immediate_32_bits;      
    logic r_type_or_i_type;             //0=R-Type, 1=I-Type

    longint pc = 0;                     //Program Counter
    longint idx = 0;                    //Memory index
    longint target_line = 0;
    longint instruction_cnt = 1;

    // Register Files
    bit [31:0] reg_files [0:31];        //Register files from $0 to $31, all are 32-bits wide

    // Memory
    logic [31:0] memory [$];

    // Load/Store temp registers
    logic signed [31:0] mem_data_reg;
    logic [31:0] effective_addr;

    // ALU local variable
    logic signed [31:0] alu_result;

    function int signed sign_extend(shortint signed offset_16_bits);

        if(offset_16_bits[15] == 1)
            return {16'hFFFF, offset_16_bits};
        else
            return {16'h0000, offset_16_bits};

    endfunction

    function void fetch_instruction_32_bit(string line);

        //pc to memory index calculation
        idx = pc/4;

        //Cast to 32-bit binary representation
        instruction_32_bin = memory[idx];

        $display("\n Current PC: %0d => Fetched Instruction = Hex: %h, Bin: %032b", pc, instruction_32_bin, instruction_32_bin);

        pc = pc + 4;

    endfunction: fetch_instruction_32_bit

    function void detect_opcode();

        op_code = instruction_32_bin[31:26];

        case(op_code)

            //Arithmetic Instructions
            6'b000000   :   begin
                                $display("It's ADD Instruction");
                                r_type_or_i_type = 0;
                            end
            6'b000001   :   begin
                                $display("It's ADDI Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b000010   :   begin
                                $display("It's SUB Instruction");
                                r_type_or_i_type = 0;
                            end 
            6'b000011   :   begin
                                $display("It's SUBI Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b000100   :   begin
                                $display("It's MUL Instruction");
                                r_type_or_i_type = 0;
                            end
            6'b000101   :   begin
                                $display("It's MULI Instruction");
                                r_type_or_i_type = 1;
                            end

            //Logical Instructions
            6'b000110   :   begin
                                $display("It's OR Instruction");
                                r_type_or_i_type = 0;
                            end
            6'b000111   :   begin
                                $display("It's ORI Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b001000   :   begin
                                $display("It's AND Instruction");
                                r_type_or_i_type = 0;
                            end
            6'b001001   :   begin
                                $display("It's ANDI Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b001010   :   begin
                                $display("It's XOR Instruction");
                                r_type_or_i_type = 0;
                            end
            6'b001011   :   begin
                                $display("It's XORI Instruction");
                                r_type_or_i_type = 1;
                            end

            //Memory Access Instructions
            6'b001100   :   begin
                                $display("It's LWD Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b001101   :   begin
                                $display("It's STW Instruction");
                                r_type_or_i_type = 1;
                            end

            //Control Flow Instructions
            6'b001110   :   begin
                                $display("It's BZ Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b001111   :   begin
                                $display("It's BEQ Instruction");
                                r_type_or_i_type = 1;
                            end
            6'b010000   :   begin
                                $display("It's JR Instruction");
                                r_type_or_i_type = 0;
                            end 
            6'b010001   :   begin
                                $display("It's HALT Instruction");
                                $finish;
                            end

        endcase

    endfunction

    function void decode_instruction(bit [31:0] instruction_32_bin);

        detect_opcode();

        if(!r_type_or_i_type)   //If R-Type
        begin
            {op_code, rs, rt, rd, shamt, funct} = instruction_32_bin;
            $display("-------------------------------------------");
            $display("                   R-TYPE                  ");
            $display("-------------------------------------------");
            $display("\tOPCODE: %b (Dec: %0d)\t\t\t", op_code, op_code);
            $display("\tRs:     %b (Dec: %0d)\t\t\t", rs, rs);
            $display("\tRt:     %b (Dec: %0d)\t\t\t", rt, rt);
            $display("\tRd:     %b (Dec: %0d)\t\t\t", rd, rd);
            $display("\tShamt:  %b (Dec: %0d)\t\t\t", shamt, shamt);
            $display("\tFunct:  %b (Dec: %0d)\t\t\t", funct, funct);
            $display("-------------------------------------------");
            data_rs = reg_files[rs];
            data_rt = reg_files[rt];
        end
        else                    //If I-Type
        begin
            {op_code, rs, rt, immediate_offset} = instruction_32_bin;
            $display("-------------------------------------------");
            $display("                   I-TYPE                  ");
            $display("-------------------------------------------");
            $display("\tOPCODE: %b (Dec: %0d)\t\t\t", op_code, op_code);
            $display("\tRs:     %b (Dec: %0d)\t\t\t", rs, rs);
            $display("\tRt:     %b (Dec: %0d)\t\t\t", rt, rt);
            $display("\tImm.:   %b (Dec: %0d)\t\t\t", immediate_offset, immediate_offset);
            $display("-------------------------------------------");
            data_rs = reg_files[rs];
            data_rt = reg_files[rt];
            immediate_32_bits = sign_extend(immediate_offset);
        end

    endfunction: decode_instruction

    function void execute_instruction();

        case(op_code)

            //Arithmetic Instructions
            6'b000000   :   begin
                                alu_result = data_rs + data_rt;
                            end
            6'b000001   :   begin
                                alu_result = data_rs + (immediate_32_bits);
                            end
            6'b000010   :   begin
                                alu_result = data_rs - data_rt;
                            end 
            6'b000011   :   begin
                                alu_result = data_rs - (immediate_32_bits);
                            end
            6'b000100   :   begin
                                alu_result = data_rs * data_rt;
                            end
            6'b000101   :   begin
                                alu_result = data_rs * (immediate_32_bits);
                            end

            //Logical Instructions
            6'b000110   :   begin
                                alu_result = data_rs | data_rt;
                            end
            6'b000111   :   begin
                                alu_result = data_rs | (immediate_32_bits);
                            end
            6'b001000   :   begin
                                alu_result = data_rs & data_rt;
                            end
            6'b001001   :   begin
                                alu_result = data_rs & (immediate_32_bits);
                            end
            6'b001010   :   begin
                                alu_result = data_rs ^ data_rt;
                            end
            6'b001011   :   begin
                                alu_result = data_rs ^ (immediate_32_bits);
                            end

            //Memory Access Instructions
            6'b001100   :   begin
                                effective_addr = (data_rs + (immediate_32_bits))/4;
                                $display("LWD: Effective Address = %0d", effective_addr);
                            end
            6'b001101   :   begin
                                effective_addr = (data_rs + (immediate_32_bits))/4;
                                $display("STW: Effective Address = %0d", effective_addr);
                            end

            //Control Flow Instructions
            6'b001110   :   begin
                                if(data_rs == 0)
                                begin
                                    // pc = pc + 4 + (immediate_32_bits << 2)
                                    pc = pc + (immediate_32_bits << 2);         //Here, pc already contains pc+4 from fetch function
                                    $display("BZ condition is satisfied, Next Target Address is: %0d", pc);
                                end
                                else
                                begin
                                    $display("BZ condition is not-satisfied, Next Target Address is: %0d", pc);
                                end
                            end
            6'b001111   :   begin
                                if(data_rs == data_rt)
                                begin
                                    // pc = pc + 4 + (immediate_32_bits << 2)
                                    pc = pc + (immediate_32_bits << 2);         //Here, pc already contains pc+4 from fetch function
                                    $display("BEQ condition is satisfied, Next Target Address is: %0d", pc);
                                end
                                else
                                begin
                                    $display("BEQ condition is not-satisfied, Next Target Address is: %0d", pc);
                                end
                            end
            6'b010000   :   begin
                                pc = data_rs;
                            end 
            6'b010001   :   begin
                                $display("It's HALT Instruction");
                                $stop;
                            end

        endcase

    endfunction

    function void memory_access(logic [31:0] effective_addr);

        if(op_code == 6'b001100)                        //For LW
            mem_data_reg = memory[effective_addr];
        else if(op_code == 6'b001101)                   //For SW
            memory[effective_addr] = data_rt;

    endfunction

    function void write_back(logic signed [31:0] register);
        
        if(op_code == 6'b001100)                        //For LW
            reg_files[register] = mem_data_reg;
        else                                            //For R-Type
            reg_files[register] = alu_result;

    endfunction

endpackage: mips_pkg