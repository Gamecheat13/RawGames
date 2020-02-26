//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "3200");
	setdvar("scr_fog_exp_halfheight", "1360");
	setdvar("scr_fog_nearplane", "1100");
	setdvar("scr_fog_red", "0.62");
	setdvar("scr_fog_green", "0.59");
	setdvar("scr_fog_blue", "0.52");
	setdvar("scr_fog_baseheight", "-448");

//	// *depth of field section* 
//	level.do_not_use_dof = true
//	level.dofDefault["nearStart"] = 0;
//	level.dofDefault["nearEnd"] = 60;
//	level.dofDefault["farStart"] = 2000;
//	level.dofDefault["farEnd"] = 3200;
//	level.dofDefault["nearBlur"] = 6;
//	level.dofDefault["farBlur"] = 2;
//
//	players = maps\_utility::get_players();
//	for( i = 0; i < players.size; i++ )
//	{
//		players[i] maps\_art::setdefaultdepthoffield();
//	}

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "0.25");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.5");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.125");
	setdvar("visionstore_glowTweakBloomIntensity1", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");

	//* Fog section * 
	level thread fog_settings();
// 	SetSavedDvar("sm_sunSampleSizeNear", "1.5" );
	level thread maps\_utility::set_all_players_visionset( "see1", 0.1 );
}

fog_settings()
{
	start_dist 			= 1100;
	halfway_dist 		= 3200;
	halfway_height 	= 1360;
	base_height 		= -448;
	red 						= 0.62;
	green 					= 0.59;
	blue		 				= 0.52;
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

//	setdvar( "scr_fog_disable", "0" );
//
//	setVolFog(1100, 4100, 1360, -448, 0.62, 0.59, 0.52, 0);
//	maps\_utility::set_vision_set( "see1", 0 );
// }
