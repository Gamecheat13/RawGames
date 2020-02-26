//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "4196");
	setdvar("scr_fog_exp_halfheight", "276");
	setdvar("scr_fog_nearplane", "759");
	setdvar("scr_fog_red", "0.49");
	setdvar("scr_fog_green", "0.56");
	setdvar("scr_fog_blue", "0.6");
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
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");

	//* Fog section * 
	level thread fog_settings();
 	level thread maps\_utility::set_all_players_visionset( "sniper", 0.1 );
	SetSavedDvar("sm_sunSampleSizeNear", "1.5" );

}

fog_settings()
{
	start_dist 			= 759;
	halfway_dist 		= 4196;
	halfway_height 	= 276;
	base_height 		= 358.96;
	red 						= 0.49;
	green 					= 0.56;
	blue		 				= 0.6;
	trans_time			= 0;
	
	if( IsSplitScreen() )
	{
		start_dist 			= 1000;
		halfway_dist 		= 200;
		halfway_height 	= 0;
		cull_dist 			= 2000;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}
//	setdvar( "scr_fog_disable", "0" );
//
//	setVolFog(759.379, 4196, 276, 358.969, 0.49, 0.56, 0.6, 0.0);
//	maps\_utility::set_vision_set( "sniper_default", 0 );
//
//}
