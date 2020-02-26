//
// file: mp_la_amb.csc
// description: clientside ambient script for mp_la: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	declareAmbientRoom("outdoor" );
		setAmbientRoomtone ("outdoor", "amb_wind_extreior_2d", .55, 1);
		setAmbientRoomReverb( "outdoor", "mp_la_city", 1, 1 );
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		
	declareAmbientRoom("cement_hall" );
		setAmbientRoomReverb( "cement_hall", "mp_la_cement_hall", 1, 1 );
		setAmbientRoomContext( "cement_hall", "ringoff_plr", "indoor" );
	
	declareAmbientRoom("parking_garage" );
		setAmbientRoomReverb( "parking_garage", "mp_la_garage", 1, 1 );
		setAmbientRoomContext( "parking_garage", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("indoor_medium" );
		setAmbientRoomReverb( "indoor_medium", "mp_la_mediumroom", 1, 1 );
		setAmbientRoomContext( "indoor_medium", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("indoor_large" );
		setAmbientRoomReverb( "indoor_large", "mp_la_largeroom", 1, 1 );
		setAmbientRoomContext( "indoor_large", "ringoff_plr", "indoor" );		
		
	declareAmbientRoom("indoor_rubble_md" );
		setAmbientRoomReverb( "indoor_rubble_md", "mp_la_rubbleroom_md", 1, 1 );
		setAmbientRoomContext( "indoor_rubble_md", "ringoff_plr", "outdoor" );		
		
	declareAmbientRoom("indoor_rubble_lg" );
		setAmbientRoomReverb( "indoor_rubble_lg", "mp_la_rubbleroom_lg", 1, 1 );
		setAmbientRoomContext( "indoor_rubble_lg", "ringoff_plr", "outdoor" );	

	declareAmbientRoom("bus" );
		setAmbientRoomReverb( "bus", "mp_la_bus", 1, 1 );
		setAmbientRoomContext( "bus", "ringoff_plr", "indoor" );				
		

	declareAmbientRoom("under_bridge" );
		setAmbientRoomReverb( "under_bridge", "mp_la_stoneroom", 1, 1 );
		setAmbientRoomContext( "under_bridge", "ringoff_plr", "outdoor" );
		
		
	//Plays default outdoor 2D alias
	activateAmbientRoom( 0, "outdoor", 0 );	
		
		thread snd_start_autofx_audio();
		thread snd_play_loopers();
		
}


//Play looping sound at position: (fadein, alias name, coord, fadeout)
snd_play_loopers()
{

	clientscripts\mp\_audio::playloopat( 0, "amb_fire_sprinkler", (41, 2071, -38), .5 );
	clientscripts\mp\_audio::playloopat( 0, "amb_fire_sprinkler_2", (-209, 1854, -47), .5 );
	clientscripts\mp\_audio::playloopat( 0, "amb_fire_sprinkler", (514, 2575, -38), .5 );
	clientscripts\mp\_audio::playloopat( 0, "amb_fire_sprinkler_2", (-235, 2555, -46), .5 );

}	


//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	snd_play_auto_fx ( "fx_fire_sm", "amb_fire_med", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_fire_md", "amb_fire_sml", 0, 0, 0, true );		
	snd_play_auto_fx ( "fx_fire_lg", "amb_fire_lrg", 0, 0, 0, true );		
	snd_play_auto_fx ( "fx_mp_light_flare_la", "amb_flare_loop", 0, 0, 10, true );		
	
	

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

