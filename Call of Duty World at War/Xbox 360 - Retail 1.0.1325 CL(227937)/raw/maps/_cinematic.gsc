#include common_scripts\utility; 
#include maps\_utility;

main( movie, next_level )
{
	setsaveddvar( "hud_drawhud", 0 ); 
	
	level.script = tolower( getdvar( "mapname" ) ); 
		
	SetSavedDvar( "g_speed", 0 ); 
	
	PrecacheShader( "black" ); 

	set_background();
	
	wait( 0.05 );
	wait_for_first_player();

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( true );
	}

	play_movie( movie, next_level );
}

set_background()
{
	level.blackscreen = NewHudElem(); 
	level.blackscreen.sort = -1; 
	level.blackscreen.alignX = "left"; 
	level.blackscreen.alignY = "top"; 
	level.blackscreen.x = 0; 
	level.blackscreen.y = 0; 
	level.blackscreen.horzAlign = "fullscreen"; 
	level.blackscreen.vertAlign = "fullscreen"; 
	level.blackscreen.foreground = true; 

	level.blackscreen.alpha = 1; 
	level.blackscreen SetShader( "black", 640, 480 ); 
}

skip_movie_think()
{
	level endon( "movie_done" );

	players = get_players();
	player = players[0];
	
	wait( 0.05 ); 
	
	set_console_status(); 
	
	for( ;; )
	{
		// we want to check if the "A" button has been pressed on xenon
		// instead of FIRE. 
		if( level.console )
		{
			if( player buttonPressed( "BUTTON_A" ) )
			{
				level notify( "movie_skip" ); 			
				return;
			}	
			wait( 0.05 ); 
			continue; 
		}
		
		if( player attackButtonPressed() )
		{
			level notify( "movie_skip" ); 			
			return; 
		}

		wait( 0.05 ); 
	}
}


skip_movie( next_level )
{
	level endon( "movie_done" );
	level thread skip_movie_think();

	level waittill( "movie_skip" );
	ChangeLevel( next_level );
}

play_movie( movie, next_level )
{
	level thread skip_movie( next_level );
	println( "Playing Cinematic: " + movie );
	Cinematic( movie );

	wait( 30 );

	level notify( "movie_done" );
	ChangeLevel( next_level );
}

