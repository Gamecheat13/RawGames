#include clientscripts\_utility;
#include clientscripts\_filter;

init()
{
	waitforclient(0);
	init_filter_hazmat( level.localPlayers[0] );
	
	thread gasmask_off();
	thread gasmask_on_pristine();
	thread gasmask_on_cracked_1();
	thread gasmask_on_cracked_2();
	thread gasmask_on_cracked_3();
	
	PrintLn( "_gasmask::init() completed" );
}



gasmask_off()
{
	while( true )
	{
		level waittill( "_gasmask_off" );
		
		disable_filter_hazmat( level.localPlayers[0], 0, 0 );
		
		PrintLn( "_gasmask::gasmask_off completed" );
	}
}



gasmask_on_pristine()
{
	while( true ) 
	{
		level waittill( "_gasmask_on_pristine" );
		level notify( "audio_mask" );
		
		enable_filter_hazmat( level.localPlayers[0], 0, 0, 1 /*stage 1 ( no crack )*/, 1.0 );		
		thread gasmask_breathing();
		
		PrintLn( "_gasmask::gasmask_on_pristine completed" );
	}
}



gasmask_on_cracked_1()
{
	while( true ) 
	{
		PrintLn( "waiting for cracked notify" );
		level waittill( "_gasmask_on_cracked_1" );
		PrintLn( "cracked notify received" );
		
		enable_filter_hazmat( level.localPlayers[0], 0, 0, 2 /*stage 2 ( cracked )*/, 1.0 );
		
		PrintLn( "_gaskmask::gasmask_on_cracked_1 complted" );
	}
}



gasmask_on_cracked_2()
{
	while( true ) 
	{
		PrintLn( "waiting for cracked notify" );
		level waittill( "_gasmask_on_cracked_2" );
		PrintLn( "cracked notify received" );
		
		enable_filter_hazmat( level.localPlayers[0], 0, 0, 3 /*stage 3 ( cracked more )*/, 1.0 );
		
		PrintLn( "_gaskmask::gasmask_on_cracked_2 complted" );
	}
}



gasmask_on_cracked_3()
{
	while( true ) 
	{
		PrintLn( "waiting for cracked notify" );
		level waittill( "_gasmask_on_cracked_3" );
		PrintLn( "cracked notify received" );
		
		enable_filter_hazmat( level.localPlayers[0], 0, 0, 4 /*stage 4 ( cracked more )*/, 1.0 );
		
		PrintLn( "_gaskmask::gasmask_on_cracked_3 complted" );
	}
}



gasmask_breathing()
{
	/*
	breath_strength = 0;
	breath_interator = .07;
	breath_direction = "up";
	
	while( true )
	{
		set_filter_gasmask_breath(level.localPlayers[0], 0, 0, breath_strength );
		wait(.05);
		
		if( breath_strength == 0 )
		{
			wait(1);
			breath_direction = "up";
		}
		else if( breath_strength == 1 )
		{
			breath_direction = "down";
		}
		
		if( breath_direction == "up" )
		{
			breath_strength += breath_interator;
			if( breath_strength > 1 )
			{
				breath_strength = 1;
			}
		}
		else
		{		
			breath_strength -= breath_interator;
			if( breath_strength < 0 )
			{
				breath_strength = 0;
			}			
		}
	}
	*/
}