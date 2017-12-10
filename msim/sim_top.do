vsim -t ns -novopt -lib work work.tb_calculator_sim_cfg
view *
do top_wave.do
run 340 ms
