//
// file: pakistan_amb.csc
// description: clientside ambient script for pakistan: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;
#include clientscripts\_music;


main()
{
//PLACEHOLDER PAKISTAN

	declareAmbientRoom( "pakistan_outdoor" );
	setAmbientRoomTone ("pakistan_outdoor","amb_rain_exterior_2d", .2, .5);
	setAmbientRoomReverb ("pakistan_outdoor","pakistan_outdoor", 1, 1);
	setAmbientRoomContext( "pakistan_outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "pakistan_outdoor" );

	declareAmbientRoom( "pak_intro_smallroom" );
	//setAmbientRoomTone ("pak_intro_smallroom","amb_water_int_drip", .2, .5);
	setAmbientRoomReverb ("pak_intro_smallroom","pakistan_mediumroom", 1, 1);
	setAmbientRoomContext( "pak_intro_smallroom", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_intro_smallroom" );
	

	declareAmbientRoom( "pak_intro_medroom" );
	setAmbientRoomTone ("pak_intro_medroom","amb_water_int_drip", .5, .5);
	setAmbientRoomReverb ("pak_intro_medroom","pakistan_mediumroom", 1, 1);
	setAmbientRoomContext( "pak_intro_medroom", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_intro_medroom" );	
	
	declareAmbientRoom( "pak_hallway" );
	setAmbientRoomTone ("pak_hallway","amb_water_int_drip", .5, .5);
	setAmbientRoomReverb ("pak_hallway","pakistan_mediumroom", 1, 1);
	setAmbientRoomContext( "pak_hallway", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_hallway" );	
		
	declareAmbientRoom( "pak_flood_street" );
	setAmbientRoomReverb ("pak_flood_street","pakistan_hills", 1, 1);
	setAmbientRoomContext( "pak_flood_street", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_flood_street" );

    declareAmbientRoom( "pak_flood_street_arch_sm" );
	setAmbientRoomReverb ("pak_flood_street_arch_sm","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_flood_street_arch_sm", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_flood_street_arch_sm" );		
	
	declareAmbientRoom( "pak_brick_semi_open" );
	setAmbientRoomReverb ("pak_brick_semi_open","pakistan_stoneroom", 1, 1);
	setAmbientRoomContext( "pak_brick_semi_open", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "pak_brick_semi_open" );	
	
	declareAmbientRoom( "pak_brick_closed" );
	setAmbientRoomReverb ("pak_brick_closed","pakistan_stoneroom", 1, 1);
	setAmbientRoomContext( "pak_brick_closed", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_brick_closed" );	
	
	declareAmbientRoom( "pak_small_concrete" );
	setAmbientRoomReverb ("pak_small_concrete","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_small_concrete", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_small_concrete" );	
	
	declareAmbientRoom( "pak_fallen_building" );
	setAmbientRoomReverb ("pak_fallen_building","pakistan_mediumroom", 1, 1);
	setAmbientRoomContext( "pak_fallen_building", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_fallen_building" );	
	
	declareAmbientRoom( "pak_sewer_pipe" );
	setAmbientRoomReverb ("pak_sewer_pipe","pakistan_sewerpipe", 1, 1);
	setAmbientRoomContext( "pak_sewer_pipe", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_sewer_pipe" );	
	
	declareAmbientRoom( "pak_sewer_room" );
	setAmbientRoomReverb ("pak_sewer_room","pakistan_sewerpipe_room", 1, 1);
	setAmbientRoomContext( "pak_sewer_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_sewer_room" );	
		
	declareAmbientRoom( "pak_sewer_brick_room" );
	setAmbientRoomReverb ("pak_sewer_brick_room","pakistan_smallroom", 1, 1);
	setAmbientRoomContext( "pak_sewer_brick_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "pak_sewer_brick_room" );
			


	
	activateAmbientPackage( 0, "pakistan_outdoor", 0 );
	activateAmbientRoom( 0, "pakistan_outdoor", 0 );	

	declaremusicstate ("PAK_RIVER_FIGHT");
		musicAliasloop ("mus_fighting_up_river", 0, 1);
		musicStinger ("mus_bus_stg", 6, true);
		
	declareMusicState ("PAK_RIVER_BUS");
		musicaliasloop ("mus_fighting_up_river", 0, 3);
		musicStinger ("mus_River_of_Bodies_stg", 6, true);
		
	declareMusicState ("PAK_BODIES");
		musicaliasloop ("null", 0, 1);
		musicStinger ("mus_hide_under_bodies_stg", 10, true);
		
	declareMusicState ("PAK_HIDE");
		musicaliasloop ("mus_searchlights", 1, 3);
			
	declareMusicState ("PAK_POST_RIVER");
		musicAliasloop ("mus_fighting_up_river", 3, 1);
		
			
	declareMusicState ("PAKISTAN_CHASE");
		musicAliasloop ("mus_pakistan_chase", 0, 3.5);
	//	musicStinger ("mus_turret_jump", 0);	
	
	thread snd_play_loopers();
	//thread snd_start_autofx_audio();
	thread bus_loop_audio();
	thread into_snd_snapshot();
	level thread snd_pov_watcher();
}
snd_pov_watcher()
{
	while (1)
	{
		msg = level waittill_any_return( "stfutz", "clawfutz", "drnfutz", "nofutz" );
		
		switch (msg)
		{
		case "stfutz":
			//iprintlnbold("stfutz");
			setglobalfutz("spl_war_command", 1.0);
			//setsoundcontext ("grass", "in_grass");
			break;					
		case "clawfutz":
			//iprintlnbold("clawfutz");
			setglobalfutz("spl_bigdog_pov", 1.0);
			//setsoundcontext ("grass", "in_grass");
			break;				
		case "drnfutz":
			//iprintlnbold("drnfutz");
			setglobalfutz("spl_quad_pov", 0.6);
			//setsoundcontext ("grass", "in_grass");
			break;
		case "nofutz":
			//iprintlnbold("nofutz");
			setglobalfutz("global", 0.0);
			//setsoundcontext ("grass", "no_grass");
			break;
		default:
			//iprintlnbold("default");
			setglobalfutz("global", 0.0);		
			//setsoundcontext ("grass", "no_grass");
			break;
		}
	}
}	


snd_play_loopers()
{
	clientscripts\_audio::playloopat( "amb_water_int_trans_rumb", (2518, 4050, 373) );
	clientscripts\_audio::playloopat( "amb_water_int_trans", (2516, 4023, 353));	

}


snd_start_autofx_audio()
{
	//snd_play_auto_fx ( "fx_fireplace01", "amb_fireplace", 0, 0, 0, false );
	

}


bus_loop_audio()
{
	level waittill ("bus_hit");
	bus_loop_ent = spawn(0, (2271, 4554, 335), "script_origin" );
	bus_loop_ent playloopsound ("amb_water_bus_hit", 2.5);
}

into_snd_snapshot()
{
	while (1)
	{
		level waittill ( "sfx_off" );
		snd_set_snapshot ( "cod_alloff" );
		
		wait (.1);
	
		level waittill ( "sfx_on" );
		snd_set_snapshot ( "default" );
		
		wait (.1);
	}
}