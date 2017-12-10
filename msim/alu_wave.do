onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -format Logic /tb_alu/clk_i
add wave -noupdate -format Logic /tb_alu/reset_i
add wave -noupdate -format Logic /tb_alu/op1_i
add wave -noupdate -format Logic /tb_alu/op2_i
add wave -noupdate -format Logic /tb_alu/optype_i
add wave -noupdate -format Logic /tb_alu/start_i
add wave -noupdate -format Logic /tb_alu/finished_o
add wave -noupdate -format Logic /tb_alu/overflow_o
add wave -noupdate -format Logic /tb_alu/i_alu/s_overflow
add wave -noupdate -format Logic /tb_alu/sign_o
add wave -noupdate -format Logic /tb_alu/error_o
add wave -noupdate -format Logic /tb_alu/result_o
add wave -noupdate -format Logic /tb_alu/i_alu/s_add_finished
add wave -noupdate -format Logic /tb_alu/i_alu/s_result_add
add wave -noupdate -format Logic /tb_alu/i_alu/s_square_finished
add wave -noupdate -format Logic /tb_alu/i_alu/p_square/v_result_square
add wave -noupdate -format Logic /tb_alu/i_alu/p_square/v_result_square_old
add wave -noupdate -format Logic /tb_alu/i_alu/p_square/v_multiply_counter
add wave -noupdate -format Logic /tb_alu/i_alu/s_result_square
add wave -noupdate -format Logic /tb_alu/i_alu/s_not_finished
add wave -noupdate -format Logic /tb_alu/i_alu/s_result_not
add wave -noupdate -format Logic /tb_alu/i_alu/s_xor_finished
add wave -noupdate -format Logic /tb_alu/i_alu/s_result_xor
add wave -noupdate -format Logic /tb_alu/i_alu/s_operation_state

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
