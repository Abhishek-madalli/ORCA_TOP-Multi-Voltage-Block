############### get violated net name and insert buffer to driver ######################## 
proc insert_driver_buffer nn { 
	set pi  [get_object_name [get_pins [all_connected $nn -leaf] -filter "direction == out"]]
	set di [ get_attribute [get_nets $nn] dr_length]
	if {$di < 101} {
		set hdi [expr $di / 2]
		add_buffer_on_route -repeater_distance $hdi -lib_cell NBUFFX2_HVT [get_nets  $nn] -punch_port -cell_prefix user_buffer_	
	} elseif {$di <  300} {
	set hdi [expr $di / 2]
		add_buffer_on_route -repeater_distance $hdi -lib_cell NBUFFX4_HVT [get_nets  $nn] -punch_port -cell_prefix user_buffer_	
	} else {
	add_buffer_on_route -repeater_distance 150 -lib_cell NBUFFX4_HVT [get_nets  $nn] -punch_port -cell_prefix user_buffer_
	} 
	 
	} 
############################# get_violated_name and pass violated net_name to proc ####################### 
set file_name ./outputs/mcv_aro.txt 
set fh_read [open $file_name r] 
set i 0 
set m 0
set n 0 
while {[gets $fh_read line] >= 0} {
		if {[llength $line] == 5}  {
		incr i 
		puts "\n iteration : $i " 
		set net_name [lindex $line 0] 
		 set flag [catch {insert_driver_buffer $net_name}] 
		 if {$flag == 0} {
			puts "buffer inserted  successfully"  
	         	incr m
		 }  else {
			puts "failed to insert buffer" 
			incr n
		} 
		
		
	}
 
}  
# legalize_placement -incremental 
# route_eco -reuse_existing_global_route true -utilize_dangling_wires true -reroute modified_nets_first_then_others


puts "\n number of buffers inserted $m" 
puts "number of buffers failed to insert $n"

 
