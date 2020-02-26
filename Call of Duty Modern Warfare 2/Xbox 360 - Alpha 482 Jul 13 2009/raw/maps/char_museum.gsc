#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;
#include maps\_anim;

main()
{
	animscripts\dog\dog_init::initDogAnimations();
	maps\char_museum_precache::main();
	
	maps\_load::main();
	
	SetSavedDvar( "player_sprintUnlimited", "1" );
	level.friendlyFireDisabled = true;
	array_thread( level.players, ::museum_player_setup );
	
	thread museum_main();
}

museum_player_setup()
{
	self.ignoreme = true;
	
	startingWeapon = "beretta";
	startingViewhands = "viewhands_black_kit";
	self TakeAllWeapons();
	self GiveWeapon( startingWeapon );
	self SwitchToWeapon( startingWeapon );
	self SetViewmodel( startingViewhands );
}

museum_main()
{
	level.guys = [];
	level.activeRoom = "none";

	add_global_spawn_function( "axis", ::museum_ai_think );
	add_global_spawn_function( "allies", ::museum_ai_think );
	add_global_spawn_function( "neutral", ::museum_ai_think );
	
	spawntrigs = GetEntArray( "spawntrig", "targetname" );
	array_thread( spawntrigs, ::spawner_trig_think );
	
	// black screen while we do things in the background
	blackscreen_start();
	
	// room 1 guys spawn initially
	room1trig = GetEnt( "room1", "script_noteworthy" );
	room1trig spawn_museum_dudes();
	
	blackscreen_fadeout( 1.25 );
}

spawner_trig_think()
{
	room = self.script_noteworthy;
	ASSERT( IsDefined( room ) );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) && level.activeRoom != room )
		{
			self spawn_museum_dudes();
			
			while( other IsTouching( self ) )
			{
				wait( 0.05 );
			}
		}
	}
}

spawn_museum_dudes()
{
	level.activeRoom = self.script_noteworthy;

	foreach( guy in level.guys )
	{
		if( IsDefined( guy ) )
		{
			guy Delete();
		}
	}
	
	level.guys = [];
	
	wait( 0.05 );  // let the guys delete to make room
	
	newspawners = GetEntArray( self.script_noteworthy, "targetname" );
	ASSERT( newspawners.size );
	
	array_thread( newspawners, ::spawn_museum_dude );
}

spawn_museum_dude()
{
	self.count = 3;
	self spawn_ai( true );
}

museum_ai_think()
{
	self endon( "death" );
	
	self.ignoreme = true;
	self.ignoreall = true;
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.ignoresuppression = true;
	self.disableBulletWhizbyReaction = true;
	self disable_pain();
	self.newEnemyReactionDistSq = 0;
	
	self PushPlayer( true );
	
	if( IsDefined( self.team ) && self.team == "axis" )
	{
		self.team = "allies";
	}
	
	// make the guy go back to idle even if he freaked out on the first frame
	self ClearEnemy();
	self.alertlevel = "noncombat";
		
	level.guys[ level.guys.size ] = self;
}

blackscreen_start()
{
	foreach( player in level.players )
	{
		player.black_overlay = maps\_hud_util::create_client_overlay( "black", 0, player );
		player.black_overlay.alpha = 1;
	}
}

blackscreen_fadeout( fadeTime )
{
	foreach( player in level.players )
	{
		player.black_overlay FadeOverTime( fadeTime );
		player.black_overlay.alpha = 0;
		player.black_overlay delaycall( fadeTime, ::Destroy );
	}
}
