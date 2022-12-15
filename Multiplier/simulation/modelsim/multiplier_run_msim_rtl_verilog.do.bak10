transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/Synchronizers.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/ripple_adder_9.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/ripple_adder_4.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/Register_unit.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/Reg_8.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/Reg_1.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/HexDriver.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/full_adder.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/Control.sv}
vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/multiplier.sv}

vlog -sv -work work +incdir+C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier {C:/intelFPGA_lite/18.1/Documents/ECE385/lab_4/multiplier/testbench_multi.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench_multi

add wave *
view structure
view signals
run 1000 ns
