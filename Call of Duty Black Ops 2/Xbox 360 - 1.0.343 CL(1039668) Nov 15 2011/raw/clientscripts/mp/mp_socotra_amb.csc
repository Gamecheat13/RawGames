//
// file: mp_socotra_amb.csc
// description: clientside ambient script for mp_socotra: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("default" );
		setAmbientRoomtone ("default", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "default", "socotra_outdoor", 1, 1 );
		setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
	
	declareAmbientRoom("under_bridge" );
		//setAmbientRoomtone ("under_bridge", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "under_bridge", "socotra_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );

	declareAmbientRoom("small_room" );
		//setAmbientRoomtone ("small_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "small_room", "socotra_smallroom", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("medium_room" );
		//setAmbientRoomtone ("medium_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "medium_room", "socotra_mediumroom", 1, 1 );
		setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("largeroom_room" );
		//setAmbientRoomtone ("largeroom_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "largeroom_room", "socotra_largeroom", 1, 1 );
		setAmbientRoomContext( "largeroom_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("hallroom" );
		//setAmbientRoomtone ("hallroom", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "hallroom", "socotra_hallroom", 1, 1 );
		setAmbientRoomContext( "hallroom", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("partialroom" );
		//setAmbientRoomtone ("partialroom", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "partialroom", "socotra_partialroom", 1, 1 );
		setAmbientRoomContext( "partialroom", "ringoff_plr", "outdoor" );	
		
		
		
/*
	declareAmbientRoom("default" );
		setAmbientRoomtone ("default", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "default", "gen_outdoor", 1, 1 );
		setAmbientRoomContext( "default", "ringoff_plr", "outdoor" );
	
	declareAmbientRoom("under_bridge" );
		//setAmbientRoomtone ("under_bridge", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "under_bridge", "gen_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );

	declareAmbientRoom("small_room" );
		//setAmbientRoomtone ("small_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "small_room", "gen_smallroom", 1, 1 );
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("medium_room" );
		//setAmbientRoomtone ("medium_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "medium_room", "gen_mediumroom", 1, 1 );
		setAmbientRoomContext( "medium_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("largeroom_room" );
		//setAmbientRoomtone ("largeroom_room", "amb_wind_extreior_2d", 1, 1);
		setAmbientRoomReverb( "largeroom_room", "gen_largeroom", 1, 1 );
		setAmbientRoomContext( "largeroom_room", "ringoff_plr", "indoor" );		
		
*/
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "default", 0 );	
		
	//	thread snd_start_autofx_audio();
		thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	clientscripts\mp\_audio::playloopat( 0, "amb_battle_dist", (-1404, 166, 1299), .5 );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	//snd_play_auto_fx ( "fx_leaves_falling_lite_w", "amb_wind_tree_high", 0, 0, 0, false );	

	

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
snd_play_auto_fx_area_emmiters()
{
	for( i = 0; i < level.createFXent.size; i++ )
	{	
		if( level.createFXent[i].soundEntArea > 1 )
		{
			//getentarray level.createFXent[i].soundEntArea
			
		}	
	}	
}	
snd_print_fx_id( fxid, type, ent )
{
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
	}	
#/			
}