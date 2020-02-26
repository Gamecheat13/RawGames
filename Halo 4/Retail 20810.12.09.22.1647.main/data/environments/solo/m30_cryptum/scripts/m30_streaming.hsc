// Script aids for streaming

global zone_set cin_m31_trans_zone = "cin_m31_trans";

// Callback from cin_m31
script static void f_start_cin_m31_transition()
	prepare_to_switch_to_zone_set(cin_m31_trans_zone);
end