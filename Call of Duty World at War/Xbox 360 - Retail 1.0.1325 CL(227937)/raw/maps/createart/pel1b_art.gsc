//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "1764");
	setdvar("scr_fog_exp_halfheight", "541");
	setdvar("scr_fog_nearplane", "815");
	setdvar("scr_fog_red", "0.506");
	setdvar("scr_fog_green", "0.613");
	setdvar("scr_fog_blue", "0.657");
	setdvar("scr_fog_baseheight", "-451.65");

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
 
	level thread maps\_utility::set_all_players_visionset( "pel1b", 0.1 );
}

/*

fog_settings()
{
		start_dist 			= 815;
		halfway_dist 		= 1764;
		halfway_height 		= 541;
		base_height 		= -451.65;
		red 				= 0.506;
		green 				= 0.613;
		blue		 		= 0.657;
		trans_time			= 0;

	
	//if( IsSplitScreen() )
	//{

		start_dist 			= 6000;
		halfway_dist 		= 5000;
		halfway_height 		=10000;
		cull_dist 			= 6000;

		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	//}
	//else
	//{
	
	//	maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	//}
}
//	setdvar( "scr_fog_disable", "0" );
//
//	setVolFog(814.911, 1763.99, 541.494, -451.652, 0.506273, 0.613708, 0.657198, 0);
//	maps\_utility::set_vision_set( "pel1b", 0 );
// }

*/
fog_settings()
{
	start_dist 			= 2166;
	halfway_dist 		= 2600;
	halfway_height 		= 2649;
	base_height 		= 1320;
	red 				= 0.506;
	green 				= 0.613;
	blue		 		= 0.657;
	trans_time			= 0;
		
	if( IsSplitScreen() )
	{
		start_dist 		= 8000;
		halfway_dist 	= 7000;
		halfway_height 	= 10000;
		cull_dist 		= 10000;
		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	
	//else
	//{
	//	SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	//}
}