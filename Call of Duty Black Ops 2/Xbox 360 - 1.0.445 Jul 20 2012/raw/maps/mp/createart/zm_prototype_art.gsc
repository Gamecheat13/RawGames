//_createart generated.  modify at your own risk. Changing values should be fine.

main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	//setdvar("scr_fog_exp_halfplane", "835");
	//setdvar("scr_fog_exp_halfheight", "200");
	//setdvar("scr_fog_nearplane", "165");
	//setdvar("scr_fog_red", "0.5");
	//setdvar("scr_fog_green", "0.5");
	//setdvar("scr_fog_blue", "0.5");
	//setdvar("scr_fog_baseheight", "50");

//	// *depth of field section* 
//	level.do_not_use_dof = true;
//	level.dofDefault["nearStart"] = 0;
//	level.dofDefault["nearEnd"] = 60;
//	level.dofDefault["farStart"] = 2000;
//	level.dofDefault["farEnd"] = 10000;
//	level.dofDefault["nearBlur"] = 6;
//	level.dofDefault["farBlur"] = 2;
//
//	players = maps\mp\_utility::get_players();
//	for( i = 0; i < players.size; i++ )
//	{
//		players[i] maps\_art::setdefaultdepthoffield();
//	}
	
	//setdvar("visionstore_glowTweakEnable", "1");
	//setdvar("visionstore_glowTweakRadius0", "5");
	//setdvar("visionstore_glowTweakRadius1", "5");
	//setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	//setdvar("visionstore_glowTweakBloomDesaturation", "0");
	//setdvar("visionstore_glowTweakBloomIntensity0", "2");
	//setdvar("visionstore_glowTweakBloomIntensity1", "2");
	//setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.29");
	//setdvar("visionstore_glowTweakSkyBleedIntensity1", "0.29");

	level thread fog_settings();
 
	VisionSetNaked("zm_prototype", 10);
	
	
	 	///////////New Hero Lighting///////////////
//t6todo	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
//t6todo	SetSavedDvar( "r_lightGridIntensity", 1.45 );
//t6todo	SetSavedDvar( "r_lightGridContrast", .15 );
	
	
}
//temp setting for art

fog_settings()
{
	/*
start_dist = 165;
	half_dist = 835;
	half_height = 200;
	base_height = 75;
	fog_r = .5;
	fog_g = .5;
	fog_b = .5;
	fog_scale = 1;
	sun_col_r = .5;
	sun_col_g = .5;
	sun_col_b = .5;
	sun_dir_x = 0;
	sun_dir_y = 0;
	sun_dir_z = 0;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
*/

start_dist = 220;
	half_dist = 948.75;
	half_height = 154.636;
	base_height = 75;
	fog_r = 0.501961;
	fog_g = 0.501961;
	fog_b = 0.501961;
	fog_scale = 3.02824;
	sun_col_r = 0.501961;
	sun_col_g = 0.501961;
	sun_col_b = 0.501961;
	sun_dir_x = 0;
	sun_dir_y = 0;
	sun_dir_z = 0;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	
}
