//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "3500");
	setdvar("scr_fog_exp_halfheight", "285");
	setdvar("scr_fog_nearplane", "2500");
	setdvar("scr_fog_red", "0.435");
	setdvar("scr_fog_green", "0.433");
	setdvar("scr_fog_blue", "0.409");
	setdvar("scr_fog_baseheight", "-380");

//	// *depth of field section* 
//	level.do_not_use_dof = true;
//	level.dofDefault["nearStart"] = 0;
//	level.dofDefault["nearEnd"] = 60;
//	level.dofDefault["farStart"] = 2000;
//	level.dofDefault["farEnd"] = 10000;
//	level.dofDefault["nearBlur"] = 6;
//	level.dofDefault["farBlur"] = 2;
//	
//	players = maps\_utility::get_players();
//	for( i = 0; i < players.size; i++ )
//	{
//		players[i] maps\_art::setdefaultdepthoffield();
//	}

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "3.0");
	setdvar("visionstore_glowTweakRadius1", "0");
	setdvar("visionstore_glowTweakBloomCutoff", "0.2");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.37");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");

	//* Fog section * 
	level thread fog_settings();
 
	level thread maps\_utility::set_all_players_visionset( "oki3", 0.1 );
}

fog_settings()
{
	start_dist 			= 2500;
	halfway_dist 		= 3500;
	halfway_height 	= 285;
	base_height 		= -380;
	red 						= 0.435;
	green 					= 0.433;
	blue		 				= 0.409;
	trans_time			= 0;
	
	if( IsSplitScreen() )
	{
		start_dist 			= 3000;
		halfway_dist 		= 250;
		halfway_height 	= 0;
		cull_dist 			= 6000;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}
