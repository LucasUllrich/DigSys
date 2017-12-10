vsim -t ns -novopt -lib work work.tb_calc_ctrl_sim_cfg
view *
do calc_wave.do
run 13 ms
