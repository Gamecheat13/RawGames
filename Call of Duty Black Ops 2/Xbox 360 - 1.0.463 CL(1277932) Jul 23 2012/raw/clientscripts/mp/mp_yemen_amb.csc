//
// file: mp_yemen_amb.csc
// description: clientside ambient script for mp_yemen: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("yemen_outdoor" );
		setAmbientRoomtone ("yemen_outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "yemen_outdoor", "yemen_outdoor", 1, 1 );
		setAmbientRoomContext( "yemen_outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("yemen_partial_room" );
		setAmbientRoomReverb( "yemen_partial_room", "yemen_partial_room", 1, 1 );
		setAmbientRoomContext( "yemen_partial_room", "ringoff_plr", "outdoor" );				
		
	declareAmbientRoom("yemen_small_room" );
		setAmbientRoomReverb( "yemen_small_room", "yemen_small_room", 1, 1 );
		setAmbientRoomContext( "yemen_small_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("yemen_medium_room" );
		setAmbientRoomReverb( "yemen_medium_room", "yemen_medium_room", 1, 1 );
		setAmbientRoomContext( "yemen_medium_room", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("yemen_large_room" );
		setAmbientRoomReverb( "yemen_large_room", "yemen_large_room", 1, 1 );
		setAmbientRoomContext( "yemen_large_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("yemen_open_room" );
		setAmbientRoomReverb( "yemen_open_room", "yemen_open_room", 1, 1 );
		setAmbientRoomContext( "yemen_open_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("yemen_dense_hallway" );
		setAmbientRoomReverb( "yemen_dense_hallway", "yemen_dense_hallway", 1, 1 );
		setAmbientRoomContext( "yemen_dense_hallway", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("yemen_stone_room" );
		setAmbientRoomReverb( "yemen_stone_room", "yemen_stone_room", 1, 1 );
		setAmbientRoomContext( "yemen_stone_room", "ringoff_plr", "indoor" );	
		
	declareAmbientRoom("yemen_container" );
		setAmbientRoomReverb( "yemen_container", "yemen_container", 1, 1 );
		setAmbientRoomContext( "yemen_container", "ringoff_plr", "indoor" );	
		
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "yemen_outdoor", 0 );	
		
	//	thread snd_start_autofyemen_audio();
	//	thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	//clientscripts\mp\_audio::playloopat( 0, "amb_flag", (-68, 3130, 182), .5 );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofyemen_audio()
{

	//snd_play_auto_fx ( "fyemen_fire_sm", "amb_fire_med", 0, 0, 0, true );
	//snd_play_auto_fx ( "fyemen_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	//snd_play_auto_fx ( "fyemen_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	

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
snd_play_auto_fyemen_area_emmiters()
{
	for( i = 0; i < level.createFXent.size; i++ )
	{	
		if( level.createFXent[i].soundEntArea > 1 )
		{
			//getentarray level.createFXent[i].soundEntArea
			
		}	
	}	
}	
snd_print_fyemen_id( fxid, type, ent )
{
/#
	if( GetDvarint( "debug_audio" ) > 0 )
	{
		printLn( "^5 ******* fxid; " + fxid + "^5 type; " + type );
	}	
#/			
}