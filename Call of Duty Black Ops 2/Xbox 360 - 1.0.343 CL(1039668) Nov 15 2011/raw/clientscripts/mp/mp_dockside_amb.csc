//
// file: mp_dockside_amb.csc
// description: clientside ambient script for mp_dockside: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("dockside_outdoor" );
		setAmbientRoomtone ("dockside_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "dockside_outdoor", "dockside_outdoor", 1, 1 );
		setAmbientRoomContext( "dockside_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("dockside_partial_room" );
		setAmbientRoomReverb( "dockside_partial_room", "dockside_partial_room", 1, 1 );
		setAmbientRoomContext( "dockside_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("dockside_small_room" );
		setAmbientRoomReverb( "dockside_small_room", "dockside_small_room", 1, 1 );
		setAmbientRoomContext( "dockside_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_medium_room" );
		setAmbientRoomReverb( "dockside_medium_room", "dockside_medium_room", 1, 1 );
		setAmbientRoomContext( "dockside_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("dockside_large_room" );
		setAmbientRoomReverb( "dockside_large_room", "dockside_large_room", 1, 1 );
		setAmbientRoomContext( "dockside_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_open_room" );
		setAmbientRoomReverb( "dockside_open_room", "dockside_open_room", 1, 1 );
		setAmbientRoomContext( "dockside_open_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_dense_hallway" ); 
		setAmbientRoomReverb( "dockside_dense_hallway", "dockside_dense_hallway", 1, 1 );
		setAmbientRoomContext( "dockside_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("dockside_stone_room" );
		setAmbientRoomReverb( "dockside_stone_room", "dockside_stone_room", 1, 1 );
		setAmbientRoomContext( "dockside_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("dockside_container" );
		setAmbientRoomReverb( "dockside_container", "dockside_container", 1, 1 );
		setAmbientRoomContext( "dockside_container", "ringoff_plr", "indoor" );	
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "dockside_outdoor", 0 );	
		
	//	thread snd_start_autofx_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//clientscripts\mp\_audio::playloopat( 0, "amb_flag", (-68, 3130, 182), .5 );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	//snd_play_auto_fx ( "fx_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fx_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fx_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	

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


