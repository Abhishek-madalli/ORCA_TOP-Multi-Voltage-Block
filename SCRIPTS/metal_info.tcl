# Metal info Program 
# get only M1 M2 M3 M4 M5 M6 M7 M8 M9 MRDL
# pi >= ms + mw

foreach_in_collection m [get_layers  -filter "is_routing_layer == true" M*] {
	set ms [get_attr [get_layer $m] min_spacing] 
	set pi [get_attr [get_layer $m] pitch]
	set mw [get_attr [get_layer $m] min_width] 
	set mn [get_object_name $m] 
	
	set flag [expr $pi >= ($ms + $mw)]
	if {$flag == 1} {
	set fg "correct_pitch" 
	} else {
	set fg "incorrect_pitch"
	} 
	
	puts "$mn\t$ms\t$pi\t$mw\t$fg"
} 

puts "Printing completed" 
