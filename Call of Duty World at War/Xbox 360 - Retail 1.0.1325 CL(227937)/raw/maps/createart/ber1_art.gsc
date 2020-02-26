//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2900");
	setdvar("scr_fog_exp_halfheight", "120");
	setdvar("scr_fog_nearplane", "340");
	setdvar("scr_fog_red", "0.485");
	setdvar("scr_fog_green", "0.485");
	setdvar("scr_fog_blue", "0.5");
	setdvar("scr_fog_baseheight", "-392");

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
	setdvar("visionstore_glowTweakRadius0", "5.20299");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.365491");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.139647");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");

	//* Fog section * 
	level thread fog_settings();
 	level thread maps\_utility::set_all_players_visionset( "ber1", 0.1 );
}

fog_settings()
{
	start_dist 			= 800;
	halfway_dist 		= 2900;
	halfway_height 	= 120;
	base_height 		= -392;
	red 						= 0.485;
	green 					= 0.485;
	blue		 				= 0.55;
	trans_time			= 0;
	
	if( IsSplitScreen() )
	{
		start_dist 			= 2200;
		halfway_dist 		= 150;
		halfway_height 		= 0;
		cull_dist 			= 6000;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}

//	setVolFog(350, 2900, 120, -392, 0.38, 0.36, 0.36, 0);
//	maps\_utility::set_vision_set( "ber1", 0 );


