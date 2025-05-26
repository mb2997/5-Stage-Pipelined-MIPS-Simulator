onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_pkg::instruction_int
add wave -noupdate /mips_pkg::instruction_32_bin
add wave -noupdate /mips_pkg::converted
add wave -noupdate /mips_pkg::op_code
add wave -noupdate /mips_pkg::rs
add wave -noupdate /mips_pkg::rt
add wave -noupdate /mips_pkg::rd
add wave -noupdate /mips_pkg::data_rs
add wave -noupdate /mips_pkg::data_rt
add wave -noupdate /mips_pkg::shamt
add wave -noupdate /mips_pkg::funct
add wave -noupdate /mips_pkg::immediate_offset
add wave -noupdate /mips_pkg::immediate_32_bits
add wave -noupdate /mips_pkg::r_type_or_i_type
add wave -noupdate /mips_pkg::pc
add wave -noupdate /mips_pkg::idx
add wave -noupdate /mips_pkg::target_line
add wave -noupdate /mips_pkg::instruction_cnt
add wave -noupdate /mips_pkg::mem_data_reg
add wave -noupdate /mips_pkg::effective_addr
add wave -noupdate /mips_pkg::alu_result
add wave -noupdate /mips_pkg::sign_extend/sign_extend
add wave -noupdate /mips_pkg::sign_extend/offset_16_bits
add wave -noupdate /mips_pkg::decode_instruction/instruction_32_bin
add wave -noupdate /mips_pkg::memory_access/effective_addr
add wave -noupdate /mips_pkg::write_back/register
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 296
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1984400 ps} {1989600 ps}
