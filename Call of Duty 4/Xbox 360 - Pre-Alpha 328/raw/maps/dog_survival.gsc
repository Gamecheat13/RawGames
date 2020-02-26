#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;


main()
{
	animscripts\dog_init::initDogAnimations();
	maps\_load::set_player_viewhand_model( "viewhands_player_usmc" );
	maps\_load::main();
	
	if ( getdvar( "numdogs" ) == "" )
		setdvar( "numdogs", "2" );
	
	createthreatbiasgroup( "specialdog" );
	createthreatbiasgroup( "allies" );
	setthreatbias( "specialdog", "allies", -10000 );
	level.player.threatbias = 0;
	
	array_thread( getaispeciesarray( "allies" ), ::think_allies );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	spawners = getentarray( "dogspawner", "targetname" );
	
	counterHudElem();
			
	wait (5);
	
	level.dogKillCount = 0;

	numSpawners = spawners.size;
	maxWave = 5;
	
	thread dogSpecial();
	
	while (1)
	{
		if ( getdvarint( "numdogs" ) > maxWave )
			setdvar( "numdogs", maxWave );

		level.numDogsElem setText( "Dogs per wave: " + getdvar( "numdogs" ) );
		waveCount = getdvarint( "numdogs" );
	
		for ( i = 0; i < waveCount; i++ )
		{
			dog = spawners[ randomint(numSpawners) ] dospawn();
			if ( !spawn_failed( dog ) )
				dog thread dogCounter();
			wait 0.5;
		}
		
		wait (10);
	}
}


think_allies()
{
	self setthreatbiasgroup( "allies" );
}


think_axis()
{
}

dogSpecial()
{
	specialspawner = getentarray( "dogspecialspawn", "targetname" )[0];
	wait (10);
	
	while (1)
	{
		dog = specialspawner dospawn();
		if ( !spawn_failed( dog ) )
		{
			dog thread dogCounter();
		
			dog.goalradius = 32;
			dog.pathEnemyFightDist = 32;
			dog.script_forcegoal = true;
			dog waittill( "goal" );

			dog setthreatbiasgroup( "specialdog" );

			wait (5);
			
			if ( isdefined( dog ) )
			{
				dog setthreatbiasgroup();
				dog.pathEnemyFightDist = 512;
				dog.goalradius = 2048;
			}
		}
		
		wait (45);
	}
}


dogCounter()
{
	self waittill( "death" );
	level.dogKillCount++;


	level.counterElem setText( "Dogs killed: " + level.dogKillCount );
}

counterHudElem()
{
	level.counterElem = createFontString( "default", 1.5 );
	level.counterElem setPoint( "TOPLEFT", undefined, 20, 10 );
	level.counterElem setText( "Dogs killed: 0" );
	
	level.numDogsElem = createFontString( "default", 1.5 );
	level.numDogsElem setPoint( "TOPLEFT", undefined, 20, 30 );
	level.numDogsElem setText( "Dogs per wave: " + getdvar( "numdogs" ) );
}
