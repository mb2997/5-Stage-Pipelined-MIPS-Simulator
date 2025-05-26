`timescale 1ns/1ps

import mips_pkg::*;

module mips;

    // Declare variables
    string file_name;
    string full_path;
    int input_file_open;
    string line;
    bit clk;
    
    longint last_idx;

    initial
    begin
        clk = 0;
        forever
        begin
            #10 clk = ~clk;
        end
    end

    initial
    begin

        // Handle command line input
        if($value$plusargs("FILE=%s", file_name))
        begin
            $display("Input file name provided: %s", file_name);
        end
        else
        begin
            file_name = "trial.txt";
            $display("No input file provided, using default: %s", file_name);
        end

        // Construct full path assuming file is in parent directory
        full_path = $sformatf("../%s", file_name);
        $display("Attempting to open file at path: %s", full_path);

        // Try to open the file
        input_file_open = $fopen(full_path, "r");
        if(!input_file_open)
        begin
            $error("ERROR! Could not open file at path: %s", full_path);
            $finish;
        end

        $display("File opened successfully!");

        // // Initialized register files
        // foreach(reg_files[i])
        // begin
        //     reg_files[i] = 'h0;
        // end

        //Read Memory Image
        while(!$feof(input_file_open))
        begin
            void'($fgets(line, input_file_open));
            //Convert hex string to longint using %h
            converted = $sscanf(line, "%h", instruction_int);
            if (converted != 1)
            begin
                $display("Error: could not convert line to integer.");
            end
            else
                memory.push_back(instruction_int);
        end

        last_idx = memory.size()-1;


        // Close file
        $fclose(input_file_open);
        $display("File closed...");

        // Processing Loop
        repeat(last_idx+1)
        //repeat(20)
        begin

            @(posedge clk);
            fetch_instruction_32_bit(line);

            @(posedge clk);
            decode_instruction(instruction_32_bin);

            @(posedge clk);
            execute_instruction();
            
            @(posedge clk);
            if(op_code == 6'b001100 || op_code == 6'b001101)
                memory_access(effective_addr);
            
            @(posedge clk);
            if(r_type_or_i_type == 1)
            begin
                if(op_code != 6'b001101 && op_code != 6'b001110 && op_code != 6'b001111 && op_code != 6'b010000 && op_code != 6'b010001)
                    write_back(rt);
            end
            else if(r_type_or_i_type == 0)
                write_back(rd);

            instruction_cnt++;

        end
        $finish;

    end

    final
    begin
        foreach(reg_files[i])
        begin
            $display("REG_FILES[%0d] = %0d", i, reg_files[i]);
        end
        $display("Total Instructions = %0d", instruction_cnt);
        // foreach(memory[i])
        // begin
        //     $display("MEMORY[%0d] = %h", i, memory[i]);
        // end
    end

endmodule: mips
