//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

		setdvar("scr_fog_exp_halfplane", "2787");
		setdvar("scr_fog_exp_halfheight", "2000");
		setdvar("scr_fog_nearplane", "1000");
		setdvar("scr_fog_red", "0.525");
		setdvar("scr_fog_green", "0.545");
		setdvar("scr_fog_blue", "0.63");
		setdvar("scr_fog_baseheight", "0");

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

	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.1");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	setdvar("visionstore_filmTweakEnable", "0");
	setdvar("visionstore_filmTweakContrast", "1.4");
	setdvar("visionstore_filmTweakBrightness", "0");
	setdvar("visionstore_filmTweakDesaturation", "0.2");
	setdvar("visionstore_filmTweakInvert", "1");
	setdvar("visionstore_filmTweakLightTint", "1.1 1.05 0.85");
	setdvar("visionstore_filmTweakDarkTint", "0.7 0.85 1");
	
	level thread fog_settings();
 
	level thread maps\_utility::set_all_players_visionset( "pel1a", 0.1 );
}

fog_settings()
{
	start_dist 			= 1000;
	halfway_dist 		= 2787;
	halfway_height 	= 2000;
	base_height 		= 0;
	red 						= 0.525;
	green 					= 0.545;
	blue		 				= 0.63;	
	trans_time			= 0;
	
	if( IsSplitScreen() )
	{

		start_dist 			= 1500;
		halfway_dist 		= 150;
		halfway_height 	= 0;
		cull_dist 			= 3000;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}
