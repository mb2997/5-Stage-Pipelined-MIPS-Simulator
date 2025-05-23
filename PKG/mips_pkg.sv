package mips_pkg;

    //Global variables
    longint instruction_int;
    bit [31:0] instruction_32_bin;
    int converted;
    
    //Variables for decoding
    //For R-Type and I-Type Formats
    bit [5:0] op_code;
    bit [4:0] rs;
    bit [4:0] rt;
    bit [4:0] rd;
    bit [4:0] shamt;
    bit [5:0] funct;
    bit [15:0] immediate;
    logic r_type_or_i_type;       //0=R-Type, 1=I-Type

    function void fetch_instruction_32_bit(string line);

        //Convert hex string to longint using %h
        converted = $sscanf(line, "%h", instruction_int);
        if (converted != 1) begin
            $display("Error: could not convert line to integer.");
            return;
        end

        //Cast to 32-bit binary representation
        instruction_32_bin = instruction_int[31:0];

        $display("inst_int  = %0d", instruction_int);
        $display("inst_bin  = %032b", instruction_32_bin);

    endfunction: fetch_instruction_32_bit

    function void decode_instruction(bit [31:0] instruction_32_bin);
        
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
                                r_type_or_i_type = 0;
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

        if(!r_type_or_i_type)   //If R-Type
        begin
            {op_code, rs, rt, rd, shamt, funct} = instruction_32_bin;
            $display("-------------------------------------------");
            $display("                   R-TYPE                  ");
            $display("-------------------------------------------");
            $display("\t\tOPCODE: %b\t\t\t", op_code);
            $display("\t\tRs:     %b\t\t\t", rs);
            $display("\t\tRt:     %b\t\t\t", rt);
            $display("\t\tRd:     %b\t\t\t", rd);
            $display("\t\tShamt:  %b\t\t\t", shamt);
            $display("\t\tFunct:  %b\t\t\t", funct);
            $display("-------------------------------------------");
        end
        else                    //If I-Type
        begin
            {op_code, rs, rt, immediate} = instruction_32_bin;
            $display("-------------------------------------------");
            $display("                   I-TYPE                  ");
            $display("-------------------------------------------");
            $display("\t\tOPCODE: %b\t\t\t", op_code);
            $display("\t\tRs:     %b\t\t\t", rs);
            $display("\t\tRt:     %b\t\t\t", rt);
            $display("\t\tImm.:   %b\t\t\t", immediate);
            $display("-------------------------------------------");
        end

    endfunction: decode_instruction

endpackage : mips_pkg
