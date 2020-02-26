#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include animscripts\random_weapon;


//**************************************************************************
//**************************************************************************

main()
{
	// precache all the weapon variants
	precacheItem("ak47_sp");
	precacheItem("ak47_dualclip_sp");
	precacheItem("ak47_acog_sp");
	precacheItem("ak47_elbit_sp");
	precacheItem("ak47_extclip_sp");
	precacheItem("ak47_reflex_sp");
	precacheItem("ak47_ft_sp");
	precacheItem("ak47_gl_sp");
	precacheItem("ak47_ir_sp");
	precacheItem("ak47_mk_sp");

	precacheItem("kiparis_acog_sp");
	precacheItem("kiparis_elbit_sp");
	precacheItem("kiparis_extclip_sp");
	precacheItem("kiparis_reflex_sp");

	precacheItem("rpk_acog_sp");
	precacheItem("rpk_dualclip_sp");
	precacheItem("rpk_elbit_sp");
	precacheItem("rpk_extclip_sp");
	precacheItem("rpk_ir_sp");
	precacheItem("rpk_reflex_sp");

	precacheItem("famas_sp");
	precacheItem("famas_cuba_extclip_gl_sp");
	precacheItem("famas_cuba_extclip_mk_sp");

	// flame death
	level._effect["character_fire_death_torso"] = LoadFX("env/fire/fx_fire_player_torso");

	level.rw_attachments_allowed = true;

	maps\_load::main();

	level.enable_player_vulnerability = true;

	maps\feature_utility::feature_start();

	// turn on flanking
	SetSavedDvar("ai_coverScore_flanking", 13);

	// turn on headshot slowmo
	SetDvar( "kill_slowmo_time", 0.15 );

	StartChallenge();

	// override the dropped weapon chances
	// nevermind, the alt weapon don't work well with AI right now
//	build_weight_arrays_by_ai_class( "VC", true, 40, 25, 25, 10 );
//	build_weight_arrays_by_ai_class( "Spetsnaz", true, 40, 25, 25, 10 );
//	build_weight_arrays_by_ai_class( "RU", true, 40, 25, 25, 10 );
} 

//**************************************************************************
//**************************************************************************

AiSpawned()
{
	self.disableIdleStrafing = true;

	if( self.team == "allies" )
	{
		level.challenge_friendliesCount++;
	}
	else
	{
		level.challenge_enemiesCount++;
	}

//	self thread meleeTest();

	self thread AiDeathWatcher();
}

meleeTest()
{
	wait(0.2);

	self.pathenemyfightdist = 0;
	self.a.allow_shooting = false;
}

//**************************************************************************
//**************************************************************************

AiDeathWatcher()
{
	self waittill("death");

	if( self.team == "allies" )
	{
		level.challenge_friendliesCount--;
		level.challenge_friendliesKilled++;
	}
	else
	{
		level.challenge_enemiesCount--;
		level.challenge_enemiesKilled++;
	}
}

//**************************************************************************
//**************************************************************************

StartChallenge()
{
	wait_for_first_player();

	level.challenge_enemiesCount = 0;
	level.challenge_friendliesCount = 0;

	allAi = GetAIArray();
	for( i=0; i < allAi.size; i++ )
		allAi[i] AiSpawned();

	level.challenge_enemiesKilled = 0;
	level.challenge_friendliesKilled = 0;

	level thread ShowNumAI();
	level thread ShowScore();

	level.challenge_spawnCount = 3;

	level thread FriendlySpawnManager();
	level thread EnemySpawnManager();
	level thread SpawnCountManager();
}

//**************************************************************************
//**************************************************************************

ShowNumAI()
{
	self endon( "death" );
	
	hudNumFriendlies = NewHudElem();
	hudNumFriendlies.location = 0;
	hudNumFriendlies.alignX = "right";
	hudNumFriendlies.alignY = "middle";
	hudNumFriendlies.foreground = 1;
	hudNumFriendlies.fontScale = 2;
	hudNumFriendlies.sort = 20;
	hudNumFriendlies.alpha = 1;
	hudNumFriendlies.x = 330;
	hudNumFriendlies.y = 50;
	hudNumFriendlies.og_scale = 2;
	hudNumFriendlies.color = ( 0.0, 0.8, 0.0 );

	hudNumEnemies = NewHudElem();
	hudNumEnemies.location = 0;
	hudNumEnemies.alignX = "left";
	hudNumEnemies.alignY = "middle";
	hudNumEnemies.foreground = 1;
	hudNumEnemies.fontScale = 2;
	hudNumEnemies.sort = 20;
	hudNumEnemies.alpha = 1;
	hudNumEnemies.x = 380;
	hudNumEnemies.y = 50;
	hudNumEnemies.og_scale = 2;
	hudNumEnemies.color = ( 0.8, 0.0, 0.0 );

	hudVs = NewHudElem();
	hudVs.location = 0;
	hudVs.alignX = "center";
	hudVs.alignY = "middle";
	hudVs.foreground = 1;
	hudVs.fontScale = 2;
	hudVs.sort = 20;
	hudVs.alpha = 1;
	hudVs.x = 355;
	hudVs.y = 50;
	hudVs.og_scale = 2;
	hudVs.color = ( 0.8, 0.8, 0.8 );
	hudVs SetText( "vs" );
	
	while( 1 )
	{
		hudNumFriendlies SetValue( level.challenge_friendliesCount );
		hudNumEnemies SetValue( level.challenge_enemiesCount );

		wait(0.10);
	}
}

//**************************************************************************
//**************************************************************************

ShowScore()
{
	self endon( "death" );

	hudScore = NewHudElem();
	hudScore.location = 0;
	hudScore.alignX = "right";
	hudScore.alignY = "middle";
	hudScore.foreground = 1;
	hudScore.fontScale = 2;
	hudScore.sort = 20;
	hudScore.alpha = 1;
	hudScore.x = 5;
	hudScore.y = 50;
	hudScore.og_scale = 2;
	hudScore.color = ( 0.8, 0.8, 0.8 );
	hudScore SetText( "Score:" );
	
	hudNumFriendlies = NewHudElem();
	hudNumFriendlies.location = 0;
	hudNumFriendlies.alignX = "right";
	hudNumFriendlies.alignY = "middle";
	hudNumFriendlies.foreground = 1;
	hudNumFriendlies.fontScale = 2;
	hudNumFriendlies.sort = 30;
	hudNumFriendlies.alpha = 1;
	hudNumFriendlies.x = 30;
	hudNumFriendlies.y = 50;
	hudNumFriendlies.og_scale = 2;
	hudNumFriendlies.color = ( 0.0, 0.8, 0.0 );

	hudNumEnemies = NewHudElem();
	hudNumEnemies.location = 0;
	hudNumEnemies.alignX = "left";
	hudNumEnemies.alignY = "middle";
	hudNumEnemies.foreground = 1;
	hudNumEnemies.fontScale = 2;
	hudNumEnemies.sort = 20;
	hudNumEnemies.alpha = 1;
	hudNumEnemies.x = 70;
	hudNumEnemies.y = 50;
	hudNumEnemies.og_scale = 2;
	hudNumEnemies.color = ( 0.8, 0.0, 0.0 );

	hudVs = NewHudElem();
	hudVs.location = 0;
	hudVs.alignX = "center";
	hudVs.alignY = "middle";
	hudVs.foreground = 1;
	hudVs.fontScale = 2;
	hudVs.sort = 50;
	hudVs.alpha = 1;
	hudVs.x = 45;
	hudVs.y = 50;
	hudVs.og_scale = 2;
	hudVs.color = ( 0.8, 0.8, 0.8 );
	hudVs SetText( "-" );
	
	while( 1 )
	{
		hudNumFriendlies SetValue( level.challenge_enemiesKilled );
		hudNumEnemies SetValue( level.challenge_friendliesKilled );

		wait(0.10);
	}
}

//**************************************************************************
//**************************************************************************

EnemySpawnManager()
{
	self endon( "death" );

	while(1)
	{
		if( level.challenge_enemiesCount < level.challenge_spawnCount )
		{
			SpawnGuys( "axis", level.challenge_spawnCount - level.challenge_enemiesCount );
		}

		wait(0.05);
	}
}

//**************************************************************************
//**************************************************************************

FriendlySpawnManager()
{
	self endon( "death" );

	while(1)
	{
		if( level.challenge_friendliesCount < level.challenge_spawnCount )
		{
			SpawnGuys( "allies", level.challenge_spawnCount - level.challenge_friendliesCount );
		}

		wait(0.05);
	}
}

//**************************************************************************
//**************************************************************************

SpawnGuys( team, count )
{
	spawnerName = "Ally";
	otherTeam = "axis";

	if( team == "axis" )
	{
		spawnerName = "Enemy";
		otherTeam = "allies";
	}

	averageEnemyPositon = GetAverageTeamPosition( otherTeam );

	spawners = GetEntArray( spawnerName, "targetname" );

	spawnersSorted = get_array_of_closest( averageEnemyPositon, spawners );

	for( i = 0; i < count && i < spawnersSorted.size; i++ )
	{
		wait( RandomFloatRange( 1, 3 ) );

		newGuy = spawnersSorted[ spawnersSorted.size - i - 1 ] StalingradSpawn();
		newGuy AiSpawned();
	}
}

//**************************************************************************
//**************************************************************************

GetAverageTeamPosition( team )
{
	guys = GetAiArray( team );

	averagePos = (0,0,0);

	for( i=0; i < guys.size; i++ )
		averagePos += guys[i].origin;

	if( guys.size > 0 )
		averagePos = VectorScale( averagePos, 1 / guys.size );

	return averagePos;
}

//**************************************************************************
//**************************************************************************

SpawnCountManager()
{
	self endon( "death" );

	hudSpawnCountText = NewHudElem();
	hudSpawnCountText.location = 0;
	hudSpawnCountText.alignX = "right";
	hudSpawnCountText.alignY = "middle";
	hudSpawnCountText.foreground = 1;
	hudSpawnCountText.fontScale = 2;
	hudSpawnCountText.sort = 20;
	hudSpawnCountText.alpha = 1;
	hudSpawnCountText.x = 7;
	hudSpawnCountText.y = 70;
	hudSpawnCountText.og_scale = 2;
	hudSpawnCountText.color = ( 0.8, 0.8, 0.8 );
	hudSpawnCountText SetText( "Count: " );

	hudSpawnCount = NewHudElem();
	hudSpawnCount.location = 0;
	hudSpawnCount.alignX = "left";
	hudSpawnCount.alignY = "middle";
	hudSpawnCount.foreground = 1;
	hudSpawnCount.fontScale = 2;
	hudSpawnCount.sort = 20;
	hudSpawnCount.alpha = 1;
	hudSpawnCount.x = 15;
	hudSpawnCount.y = 70;
	hudSpawnCount.og_scale = 2;
	hudSpawnCount.color = ( 0.8, 0.8, 0.8 );

	while(1)
	{
		player = get_players()[0];

		if (player ButtonPressed("DPAD_RIGHT"))
		{
			level.challenge_spawnCount++;

			wait(0.15);
		}
		else if (player ButtonPressed("DPAD_LEFT"))
		{
			level.challenge_spawnCount--;

			wait(0.15);
		}

		hudSpawnCount SetValue( level.challenge_spawnCount );

		wait(0.05);
	}
}