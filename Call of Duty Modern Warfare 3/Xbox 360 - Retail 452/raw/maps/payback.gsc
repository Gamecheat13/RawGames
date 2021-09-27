#include maps\_utility;
#include common_scripts\utility;

main()
{
	template_level( "payback" );
	maps\payback_precache::main();
	
	PrecacheShader( "gasmask_overlay_delta2" );
		
	//asanfilippo - put this here simply because it was trying to precache a model that didn't exist in devmap 1.
	maps\payback_streets::init_streets_assets();

	default_start( maps\payback_compound::start_compound );
	add_start( "s1_outer_compound", maps\payback_1_script_b::enter_compound );
	add_start( "s1_main_compound", maps\payback_1_script_c::compound_c_jumpto );
	add_start( "s1_interrogation", maps\payback_1_script_e::s1_interrogation_jumpto );
	add_start( "s2_city", maps\payback_streets::start_s2_city );
	add_start( "s2_postambush", maps\payback_streets::start_s2_postambush );
	add_start( "s2_construction", maps\payback_streets_const::start_s2_construction );
	add_start( "s2_rappel", maps\payback_streets_const::start_s2_rappel );
	add_start( "s2_sandstorm" , maps\payback_sandstorm::start_sandstorm );
	add_start( "s3_rescue", maps\payback_rescue::start_s3_rescue );
	add_start( "s3_escape", maps\payback_rescue::start_s3_escape );
//	add_start( "s3_exfil", maps\payback_rescue::start_s3_exfil );
	
	maps\payback_main::main();

}
