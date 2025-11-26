sh date

# set some per design variables
set TOPLEVEL  "mac_dp"

set target_library {/sw/cadence/libraries/cmos065_522/CORE65LPLVT_5.1/libs/CORE65LPLVT_nom_1.20V_25C.db}
set link_library $target_library 


proc dir_exists {name} {
    if { [catch {set type [file type $name] } ]  } {
	return 0;
    } 
    if { $type == "directory" } {
	return 1;
    }
    return 0;

}

if {[dir_exists $TOPLEVEL.out]} {
    sh rm -r ./$TOPLEVEL.out
}
sh mkdir ./$TOPLEVEL.out

if [file exists mac_dp.v] {
    analyze -format verilog mac_dp.v
    analyze -format verilog saturation.v
} else {
    analyze -format vhdl mac_dp.vhd
    analyze -format vhdl saturation.vhd
}

analyze -format verilog mac_scale.v

elaborate mac_dp

# Set timing constaints, this says that a max of .6ns of delay from
# input to output is alowable 
set_max_delay .6 -to [all_outputs]

# If this was a clocked piece of logic we could set a clock
#  period to shoot for like this 
create_clock clk_i -period 2.000

# Check for warnings/errors 
check_design

# This forces the compiler to spend as much effort (and time)
# compiling this RTL to achieve timing possible. 
compile_ultra

# Now that the compile is complete report on the results 

check_design > ./$TOPLEVEL.out/check_design.rpt

report_constraint -all_violators -verbose  > constraint.rpt
report_wire_load > wire_load_model_used.rpt
report_area > area.rpt
report_qor > qor.rpt
report_timing -max_paths 1000 > timing.rpt
report_power -verbose > power_estimate.rpt
report_design > ./$TOPLEVEL.out/design_information.rpt
report_resources > ./$TOPLEVEL.out/resources.rpt

# Finally write the post synthesis netlist out to a verilog file 
write -f verilog $TOPLEVEL -output synthesized_netlist.v -hierarchy


quit
