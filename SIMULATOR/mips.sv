module mips;

    // Declare variables
    string file_name;
    string full_path;
    int input_file_open;
    string line;
    bit clk;
    longint instruction_cnt = 1;

    initial
    begin
        clk = 0;
        forever
        begin
            #10 clk = ~clk;
        end
    end

    initial begin

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

        // Read and display file contents line by line
        while(!$feof(input_file_open))
        begin
            @(posedge clk);
            void'($fgets(line, input_file_open));
            $display("------------------ Instruction Count: %0d ------------------\n", instruction_cnt);
            $display("Fetched Instruction: %s", line);
            instruction_cnt++;
        end

        // Close file
        $fclose(input_file_open);
        $display("File closed...");

        $finish;

    end

endmodule : mips
