//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "255");
	setdvar("scr_fog_exp_halfheight", "250");
	setdvar("scr_fog_nearplane", "790");
	setdvar("scr_fog_red", "0.44");
	setdvar("scr_fog_green", "0.40");
	setdvar("scr_fog_blue", "0.32");
	setdvar("scr_fog_baseheight", "-55");

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
	setdvar("visionstore_glowTweakRadius0", "2");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.9");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");

	//* Fog section * 
	level thread fog_settings();
 
	level thread maps\_utility::set_all_players_visionset( "pel2_2", 0.1 );
}

fog_settings()
{
	start_dist 			= 790;
	halfway_dist 		= 255;
	halfway_height 	= 250;
	base_height 		= -55;
	red 						= 0.44;
	green 					= 0.40;
	blue		 				= 0.32;
	trans_time			= 0;
	
	if( IsSplitScreen() )
	{
		start_dist 			= 2500;
		halfway_dist 		= 150;
		halfway_height 		= 0;
		cull_dist 			= 8500;
		red 				= 0.7;
		green 				= 0.62;
		blue		 				= 0.52;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}
//	setdvar( "scr_fog_disable", "0" );
//	setVolFog(940, 2560, 520, -55, 0.7, 0.62, 0.52, 0);
//	maps\_utility::set_vision_set( "pel2", 0 );
// }
//	setVolFog( 350, 500, 90, -120, 0.51, 0.52, 0.36, 0.0 );	
