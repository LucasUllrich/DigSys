onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -format Logic /tb_calculator/clk_i
add wave -noupdate -format Logic /tb_calculator/reset_i
add wave -noupdate -format Logic /tb_calculator/ss_sel_o
add wave -noupdate -format Logic /tb_calculator/ss_o
add wave -noupdate -format Logic /tb_calculator/sw_i(15:12)
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_swsync
add wave -noupdate -format Logic /tb_calculator/sw_i(11:0)
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_start
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_finished
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_calc_ctrl/op1_o
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_op1
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_alu/op1_i
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_calc_ctrl/op2_o
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_op2
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_alu/op2_i
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_alu/s_result_add
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_result
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_alu/result_o
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_overflow
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_error
add wave -noupdate -format Logic /tb_calculator/pb_i
add wave -noupdate -format Logic /tb_calculator/i_calculator/s_pbsync
add wave -noupdate -format Logic /tb_calculator/led_o
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_calc_ctrl/s_calc_state
add wave -noupdate -format Logic /tb_calculator/i_calculator/i_alu/s_operation_state

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left
