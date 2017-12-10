vsim -t ns -novopt -lib work work.tb_io_ctrl_sim_cfg
view *
do io_wave.do
run 21 ms
