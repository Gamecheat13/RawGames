//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "750");
	setdvar("scr_fog_exp_halfheight", "400");
	setdvar("scr_fog_nearplane", "250");
	setdvar("scr_fog_red", "0.44");
	setdvar("scr_fog_green", "0.52");
	setdvar("scr_fog_blue", "0.50");
	setdvar("scr_fog_baseheight", "-128");

//	// *depth of field section* 
//	level.do_not_use_dof = true;
//	level.Dofdefault["Nearstart"] = 0;
//	level.Dofdefault["Nearend"] = 60;
//	level.Dofdefault["Farstart"] = 2000;
//	level.Dofdefault["Farend"] = 10000;
//	level.Dofdefault["Nearblur"] = 6;
//	level.Dofdefault["Farblur"] = 2;
//	
//	players = maps\_utility::get_players();
//	for( i = 0; i < players.size; i++ )
//	{
//		players[i] maps\_art::setdefaultdepthoffield();
//	}

	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "3");
	setdvar("visionstore_glowTweakRadius1", "3");
	setdvar("visionstore_glowTweakBloomCutoff", "0.45");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.20");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.8");
	setdvar("visionstore_glowTweakBloomIntensity1", "0.8");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.29");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0.29");

	//* Fog section * 
	level thread fog_settings();
	level thread maps\_utility::set_all_players_visionset( "ber2_interior", 0.1 );
}

fog_settings()
{
	start_dist 			= 250;
	halfway_dist 		= 750;
	halfway_height 	= 400;
	base_height 		= -128;
	red 						= 0.44;
	green 					= 0.52;
	blue		 				= 0.50;
	trans_time			= 0;

	if( IsSplitScreen() )
	{
		start_dist 			= 1500;
		halfway_dist 		= 150;
		halfway_height 	= 0;
		cull_dist 			= 4000;

		maps\_utility::set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
	}
	else
	{
		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time );
	}
}

