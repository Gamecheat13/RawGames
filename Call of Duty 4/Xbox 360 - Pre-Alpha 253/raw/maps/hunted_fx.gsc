main()

{
	level._effect["firelp_vhc_lrg_pm_farview"]		= loadfx ("fire/firelp_vhc_lrg_pm_farview");
	level._effect["lighthaze"]						= loadfx ("misc/lighthaze"); 
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["fog_hunted"]						= loadfx ("weather/fog_hunted");
	level._effect["fog_hunted_a"]					= loadfx ("weather/fog_hunted_a");
	level._effect["bird_pm"]						= loadfx ("misc/bird_pm");
	level._effect["bird_takeoff_pm"]				= loadfx ("misc/bird_takeoff_pm");
	level._effect["leaves"]							= loadfx ("misc/leaves");
	level._effect["leaves_a"]						= loadfx ("misc/leaves_a");
	level._effect["leaves_b"]						= loadfx ("misc/leaves_b");
	level._effect["leaves_c"]						= loadfx ("misc/leaves_c");
	level._effect["leaves_runner"]					= loadfx ("misc/leaves_runner");
	level._effect["leaves_runner_1"]				= loadfx ("misc/leaves_runner_1");
	level._effect["leaves_lp"]						= loadfx ("misc/leaves_lp");
	level._effect["leaves_gl"]						= loadfx ("misc/leaves_gl");
	level._effect["leaves_gl_a"]					= loadfx ("misc/leaves_gl_a");
	level._effect["leaves_gl_b"]					= loadfx ("misc/leaves_gl_b");	
	level._effect["hunted_vl"]						= loadfx ("misc/hunted_vl");	
	level._effect["hunted_vl_sm"]					= loadfx ("misc/hunted_vl_sm");
	level._effect["hunted_vl_od_lrg"]				= loadfx ("misc/hunted_vl_od_lrg");	
	level._effect["hunted_vl_od_lrg_a"]				= loadfx ("misc/hunted_vl_od_lrg_a");	
	level._effect["hunted_vl_od_sml"]				= loadfx ("misc/hunted_vl_od_sml");	
	level._effect["hunted_vl_od_sml_a"]				= loadfx ("misc/hunted_vl_od_sml_a");
	level._effect["hunted_vl_od_dtl_a"]				= loadfx ("misc/hunted_vl_od_dtl_a");
	level._effect["hunted_vl_od_dtl_b"]				= loadfx ("misc/hunted_vl_od_dtl_b");			
	level._effect["mist_hunted_add"]				= loadfx ("weather/mist_hunted_add");	
	level._effect["insects_light_hunted"]			= loadfx ("misc/insects_light_hunted");	
	level._effect["insects_light_hunted_a"]			= loadfx ("misc/insects_light_hunted_a");	
	level._effect["hunted_vl_white_eql"]			= loadfx ("misc/hunted_vl_white_eql");	
	level._effect["hunted_vl_white_eql_flare"]		= loadfx ("misc/hunted_vl_white_eql_flare");
	level._effect["hunted_vl_white_eql_a"]			= loadfx ("misc/hunted_vl_white_eql_a");	
	level._effect["grenadeexp_fuel"]				= loadfx ("explosions/grenadeexp_fuel");
	level._effect["hunted_fel"]						= loadfx ("misc/hunted_fel");	
	
			
	
	// level script effects
	level._effect["truck_smoke"]					= loadfx ("smoke/car_damage_blacksmoke");
	level._effect["spotlight"]						= loadfx ("misc/spotlight_medium");
	level._effect["spotlight_dlight"]				= loadfx ("misc/spotlight_dlight");
	level._effect["flashlight"]						= loadfx ("misc/spotlight_small");

	maps\createfx\hunted_fx::main();
}

fuel_explosion()
{
	maps\_utility::exploder(20);

	maps\_utility::play_sound_in_space ( "hunted_fuel_explosion", (2577.57, -8615.74, 373.73) );

   	ent = maps\_utility::createOneshotEffect("firelp_vhc_lrg_pm_farview");
   	ent.v["origin"] = (2577.57,-8615.74,373.73);
   	ent.v["angles"] = (270,0,0);
   	ent.v["fxid"] = "firelp_vhc_lrg_pm_farview";
   	ent.v["delay"] = -15;
	ent maps\_createfx::set_forward_and_up_vectors();

	ent thread maps\_fx::OneShotfxthread();
}