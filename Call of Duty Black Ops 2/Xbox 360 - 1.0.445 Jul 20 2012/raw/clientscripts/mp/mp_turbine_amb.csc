//
// file: mp_turbine_amb.csc
// description: clientside ambient script for mp_turbine: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("turbine_outdoor", true );
		setAmbientRoomtone ("turbine_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "turbine_outdoor", "turbine_outdoor", 1, 1 );
		setAmbientRoomContext( "turbine_outdoor", "ringoff_plr", "outdoor" );			
		
	declareAmbientRoom("turbine_comp_room" );
		setAmbientRoomReverb( "turbine_comp_room", "turbine_largeroom", 1, 1 );
		setAmbientRoomContext( "turbine_comp_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("turbine_comp_hallway" );
		setAmbientRoomReverb( "turbine_comp_hallway", "turbine_dense_hallway", 1, 1 );
		setAmbientRoomContext( "turbine_comp_hallway", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("turbine_comp_mg_room" );
		setAmbientRoomReverb( "turbine_comp_mg_room", "turbine_smallroom", 1, 1 );
		setAmbientRoomContext( "turbine_comp_mg_room", "ringoff_plr", "indoor" );

	declareAmbientRoom("tur_comp_hallway_partial" );
		setAmbientRoomReverb( "tur_comp_hallway_partial", "turbine_dense_hallway", 1, 1 );
		setAmbientRoomContext( "tur_comp_hallway_partial", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("turbine_tubes" );
		setAmbientRoomtone ("turbine_tubes", "amb_air_dank_a", .55, .55);
		setAmbientRoomReverb( "turbine_tubes", "turbine_tube", 1, 1 );
		setAmbientRoomContext( "turbine_tubes", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("turbine_tubes_partial" );
	setAmbientRoomtone ("turbine_tubes", "amb_air_dank_a", .55, .55);
		setAmbientRoomReverb( "turbine_tubes_partial", "turbine_tube", 1, 1 );
		setAmbientRoomContext( "turbine_tubes_partial", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("turbine_tubes_loud" );
		setAmbientRoomtone ("turbine_tubes_loud", "amb_air_dank_c", .55, .55);
		setAmbientRoomReverb( "turbine_tubes_loud", "turbine_tube", 1, 1 );
		setAmbientRoomContext( "turbine_tubes_loud", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("tur_tubes_loud_partial" );
		setAmbientRoomtone ("tur_tubes_loud_partial", "amb_air_dank_c", .55, .55);
		setAmbientRoomReverb( "tur_tubes_loud_partial", "turbine_tube", 1, 1 );
		setAmbientRoomContext( "tur_tubes_loud_partial", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("turbine_sewer_pipe" );
		setAmbientRoomtone ("turbine_sewer_pipe", "amb_air_dank_a", .55, .55);
		setAmbientRoomReverb( "turbine_sewer_pipe", "turbine_tube", 1, 1 );
		setAmbientRoomContext( "turbine_sewer_pipe", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("turbine_comp_storage" );
		setAmbientRoomReverb( "turbine_comp_storage", "turbine_smallroom", 1, 1 );
		setAmbientRoomContext( "turbine_comp_storage", "ringoff_plr", "indoor" );
		
	declareAmbientRoom("turbine_outside_shed" );
		setAmbientRoomtone ("turbine_outside_shed", "amb_air_dank_a", .55, .55);
		setAmbientRoomReverb( "turbine_outside_shed", "turbine_partialroom", 1, 1 );
		setAmbientRoomContext( "turbine_outside_shed", "ringoff_plr", "outdoor" );
		
//	declareAmbientRoom("turbine_stone_room" );
//		setAmbientRoomReverb( "turbine_stone_room", "turbine_stone_room", 1, 1 );
//		setAmbientRoomContext( "turbine_stone_room", "ringoff_plr", "indoor" );	

//	declareAmbientRoom("turbine_medium_room" );
//		setAmbientRoomReverb( "turbine_medium_room", "turbine_medium_room", 1, 1 );
//		setAmbientRoomContext( "turbine_medium_room", "ringoff_plr", "indoor" );		
		
//	declareAmbientRoom("turbine_large_room" );
//		setAmbientRoomReverb( "turbine_large_room", "turbine_large_room", 1, 1 );
//		setAmbientRoomContext( "turbine_large_room", "ringoff_plr", "indoor" );	
		
//	declareAmbientRoom("turbine_open_room" );
//		setAmbientRoomReverb( "turbine_open_room", "turbine_open_room", 1, 1 );
//		setAmbientRoomContext( "turbine_open_room", "ringoff_plr", "indoor" );	
		
//	declareAmbientRoom("turbine_partial_room" );
//		setAmbientRoomReverb( "turbine_partial_room", "turbine_partial_room", 1, 1 );
//		setAmbientRoomContext( "turbine_partial_room", "ringoff_plr", "outdoor" );	
				
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "turbine_outdoor", 0 );	
		
	    thread snd_start_autofx_audio();
		thread snd_play_loopers();
		//thread windmill_whoosh_setup();
		thread wmill_sfx_setup();
		
		
}



//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{
	
//Cliff rapid wind stereo loops
	//tall high bottom one
	clientscripts\mp\_audio::playloopat( "amb_wind_cliff", (-1105, -1343, 1007) );
	//Bridge leads to this one
	clientscripts\mp\_audio::playloopat( "amb_wind_cliff", (-1780, 3042, 462) );
	//first on left when moving uphill
	clientscripts\mp\_audio::playloopat( "amb_wind_cliff", (-1436, -80, 524) );
	//bottom most point from fallen towef base
	clientscripts\mp\_audio::playloopat( "amb_wind_cliff", (-594, -2243, 432) );
	//over fallen tower base
	clientscripts\mp\_audio::playloopat( "amb_wind_cliff", (-133, -1095, 734) );
	
	playloopat( "amb_wind_cliff", (-1779, 1697, 676 ));
	
//Windmill motor loops
	clientscripts\mp\_audio::playloopat( "amb_wmill_motor", (-2524, 3083, 856) );
	//clientscripts\mp\_audio::playloopat( "amb_wmill_motor", (-1561, -691, 2090) );
	//clientscripts\mp\_audio::playloopat( "amb_wmill_motor", (-1050, 1317, 3536) );
		
//Windmill base rumble
	clientscripts\mp\_audio::playloopat( "amb_wmill_base_rumble", (-888, 1418, 547) );
	
}	
//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{
	snd_play_auto_fx ( "fx_light_flour_glow_cool_dbl_shrt", "amb_flour_light", 0, 0, 0, false );	
	
	
}

wmill_sfx_setup()
{
	wait (.5);

	location = [];
	location[0] = spawnstruct();
	location[0].origin = (-2579, 3014, 385);
	location[0].alias = "amb_wmill_whoosh";
	location[1] = spawnstruct();
	location[1].origin = (-1644, -636, 563);
	location[1].alias = "amb_wmill_whoosh";
	location[2] = spawnstruct();
	location[2].origin = (-1073, 1351, 1941);
	location[2].alias = "amb_wmill_whoosh";
		
	while(1)
	{

		for(i=0;i<location.size;i++)
		{
			playsound(0, location[i].alias, location[i].origin );
		}
		
		wait(1.35);
	}
}


snd_play_auto_fx( fxid, alias, offsetx, offsety, offsetz, onground, area )
{
	for( i = 0; i < level.createFXent.size; i++ )
	{
		if( level.createFXent[i].v["fxid"] == fxid )
		{
			level.createFXent[i].soundEnt = spawnFakeEnt( 0 );
			
			if (isdefined (area))
			{
				level.createFXent[i].soundEntArea = area;
			}	
			
			origin = level.createFXent[i].v["origin"];
			
			if (isdefined (offsetx) && offsetx > 0 )
			{
				//add offset to origin
				origin = origin + (offsetx,0,0);
			}
			if (isdefined (offsety) && offsetx > 0 )
			{
				//add offset to origin
				origin = origin + (0,offsety,0);
			}
			if (isdefined (offsetz) && offsetx > 0 )
			{
				//add offset to origin
				origin = origin + (0,0,offsetz);
			}
			if (isdefined (onground) && onground )
			{
				//check to ground move origin to ground + offest to ensure is above ground
			trace = undefined; 
			d = undefined; 

			FxOrigin = origin; 
			trace = bullettrace( FxOrigin, FxOrigin -( 0, 0, 100000 ), false, undefined ); 

			d = distance( FxOrigin, trace["position"] ); 
			
			origin =  trace["position"];
					
			}														
			setfakeentorg( 0, level.createFXent[i].soundEnt, origin );
			
			playloopsound( 0, level.createFXent[i].soundEnt, alias, .5 );

		}
	}
}
snd_play_auto_fturbine_area_emmiters()
{
	for( i = 0; i < level.createFXent.size; i++ )
	{	
		if( level.createFXent[i].soundEntArea > 1 )
		{
			//getentarray level.createFXent[i].soundEntArea
			
		}	
	}	
}	
snd_print_fturbine_id( fxid, type, ent )
{
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
	}	
#/			
}