#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;

//**************************************************************************
//**************************************************************************

startchallenge(name)
{
	OnPlayerConnect_Callback( ::OnPlayerConnect );
	OnPlayerDisconnect_Callback( ::OnPlayerDisconnect );
	OnPlayerKilled_Callback( ::OnPlayerKilled );

	level.onSpawnSpectator			= ::OnSpawnSpectator;

	wait_for_first_player();	
	level.player = get_players()[0];

	level.no_laststandmissionfail	= true;

	// delete all the spawn manager triggers
	trigger_types = [];
	trigger_types[trigger_types.size] = "trigger_multiple"; // can be used as spawn manager.
	trigger_types[trigger_types.size] = "trigger_once"; 	// can be used as spawn manager.
	trigger_types[trigger_types.size] = "trigger_radius"; 	// can be used as a spawn manager.
	trigger_types[trigger_types.size] = "trigger_box"; 	// can be used as a spawn manager.

	// Go through all the triggers in the level and set up the spawn managers for them.
	for( i=0; i<trigger_types.size; i++ )
	{
		triggers = getentarray( trigger_types[i],"classname" );

		for( j=0; j<triggers.size; j++ )
		{
			triggers[j] Delete();
		}
	}

	level.challenge_name			= name;
	level.challenge_round			= 0;
	level.challenge_state			= "";
	level.challenge_enemies			= [];
	level.challenge_enemiesCount	= 0;
	level.challenge_enemiesCountMax	= 0;
	
	SetDvar ("challenge_attemptmax",   "3");
	SetDvar ("challenge_attemptcount", "0");
	SetDvar ("challenge_score",		   "0");			

	level thread ShowSkill();
	level thread ShowRound();
	level thread ShowNumAI();	
	level thread ShowLife();
	level thread ShowScore();
	
	level thread RoundMgr();	
	level thread CountdownMgr(3);
	level thread GameMgr();
	
	level.challenge_PlayerHealth	= level.player.health;
	
	level notify("challenge_nextround");
}

//**************************************************************************
//**************************************************************************

RoundMgr()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill("challenge_nextround");		
		level.challenge_state	= "challenge_init";
				
		InitRound();		
		
		InitSkill();
		
		self notify("challenge_countdown");	
		
		wait(0.5);
			
		savegame( level.challenge_name );	
		//autosave_by_name( level.challenge_name );
	}	
}

//**************************************************************************
//**************************************************************************

CountdownMgr(countdownTime)
{
	self endon( "death" );
		
	while( 1 )
	{
		self waittill("challenge_countdown");
		level.challenge_state = "challenge_countdown";
				
		level thread Spawner(countdownTime-1);

		level thread BlackScreen(0.0,countdownTime-1,1);
		level thread WarpPlayerThreat(0.1, countdownTime-1);
	
		level thread ShowCountdown(0, countdownTime);
		
		wait(countdownTime+0.05);
		
		self notify("challenge_start");	
	}	
}

//**************************************************************************
//**************************************************************************

GameMgr()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill("challenge_start");		
		
		WakeUpAI();
			
		level notify("challenge_started");	
		
		level.challenge_state = "challenge_play";
	
		wait(0.75);	
	
		while( level.challenge_enemiesCount > 0 )
		{			
			//This is to kill all opponents
			//for(i=0; i<level.challenge_enemiesCount; i++)
			//{
			//	if( isdefined(level.challenge_enemies[i]) )
			//	{
			//		level.challenge_enemies[i] DoDamage(10000, (0,0,0) );				
			//	}
			//}
			
			//For now, we set the difficulty once in a while, to make sure it is really set
			wait(0.1);
		}	
		
		level notify("challenge_success");	
			
		level notify("endmusicpackage");
		
		wait(2); 
		
		ShowSuccess(3);

		level notify("challenge_nextround");
	}	 
}

//**************************************************************************
//**************************************************************************

LevelFail()
{
	//Use a dvar because saving cannot work :(		
	attempt = GetDvarint( "challenge_attemptcount" ) + 1;
	SetDvar ("challenge_attemptcount", "" + attempt );
						
	level notify("endmusicpackage");	
	
	if( CountLife() <= 0 )
	{
		ShowFailure(1,1);
		fastrestart();
	} 
	else
	{
		ShowFailure(1,2);
	}
}
	

//**************************************************************************
//**************************************************************************

ShowCountdown(delay,time)
{
	self endon( "death" );
	
	hudTime = NewHudElem();
	hudTime.location = 0;
	hudTime.alignX = "left";
	hudTime.alignY = "middle";
	hudTime.foreground = 1;
	hudTime.fontScale = 5;
	hudTime.sort = 20;
	hudTime.x = 290;
	hudTime.y = 250;
	hudTime.og_scale = 1;
	hudTime.color = ( 1, 0, 0 );
	hudTime.alpha = 1;	
	
	wait(delay);
	
	while( time > 0 )
	{			
		//Display the type of test we are doing
		hudTime SetText( "0" + time );
		level.player playsound("mouse_click");
		
		wait(1);
		
		time = time - 1;		
	}
			
	level notify("playmusicpackage_backlot");

	wait(0.2);
	
	hudTime.x = 250; //270
	hudTime.fontScale = 10;
	hudTime.color = ( 0, 1, 0 );	
	hudTime SetText( "GO" );
	
	wait(0.5);
	
	hudTime SetText( "" );

	hudTime destroy();
}


//**************************************************************************
//**************************************************************************

ShowSkill()
{	
	self endon( "death" );
	
	hudSkill = NewHudElem();
	hudSkill.location = 0;
	hudSkill.alignX = "center";
	hudSkill.alignY = "middle";
	hudSkill.foreground = 1;
	hudSkill.fontScale = 2;
	hudSkill.sort = 20;
	hudSkill.x = 330;
	hudSkill.y = 30;
	hudSkill.og_scale = 1;
	hudSkill.color = ( 1, 0, 0 );
	hudSkill.alpha = 1;
			
	while( 1 )
	{			
		text = "";
		//switch(GetDvarint( "level_gameskill" ))
		switch( level.gameskill )
		{
			case 0:
			{
				text = "Recruit";				
			}
			break;
			case 1:
			{
				text = "Regular";
			}
			break;
			case 2:
			{
				text = "Hardened";
			}
			break;
			case 3:
			{
				text = "Veteran";
			}
			break;
		}

		hudSkill SetText( text );			
		wait(0.25);
	}
	
}
	
	
//**************************************************************************
//**************************************************************************

ShowNumAI()
{
	self endon( "death" );
	
	hudNumAI = NewHudElem();
	hudNumAI.location = 0;
	hudNumAI.alignX = "center";
	hudNumAI.alignY = "middle";
	hudNumAI.foreground = 1;
	hudNumAI.fontScale = 2;
	hudNumAI.sort = 20;
	hudNumAI.alpha = 1;
	hudNumAI.x = 330;
	hudNumAI.y = 95;
	hudNumAI.og_scale = 2;
	hudNumAI.color = ( 0.8, 0.8, 0.8 );
	
	while( 1 )
	{			
		if( level.challenge_state == "challenge_play" )
		{
			hudNumAI SetText( level.challenge_enemiesCountMax-level.challenge_enemiesCount + " / " + level.challenge_enemiesCountMax );			
		}
		else
		{		
			hudNumAI SetText( "" );			
		}
		wait(0.10);
	}
}

//**************************************************************************
//**************************************************************************

ShowRound()
{
	self endon( "death" );
	
	hudRound = NewHudElem();
	hudRound.location = 0;
	hudRound.alignX = "center";
	hudRound.alignY = "middle";
	hudRound.foreground = 1;
	hudRound.fontScale = 3;
	hudRound.sort = 20;
	hudRound.alpha = 1;
	hudRound.x = 330;
	hudRound.y = 70;
	hudRound.og_scale = 2;
	hudRound.color = ( 1, 1, 1 );
	
	while( 1 )
	{			
		hudRound SetText( "Round: " + level.challenge_round );			
		wait(0.25);
	}
}

//**************************************************************************
//**************************************************************************

CountLife()
{
	return GetDvarint( "challenge_attemptmax" ) - GetDvarint( "challenge_attemptcount" );
}

//**************************************************************************
//**************************************************************************

ShowLife()
{
	self endon( "death" );
	
	hudRound = NewHudElem();
	hudRound.location = 0;
	hudRound.alignX = "left";
	hudRound.alignY = "middle";
	hudRound.foreground = 1;
	hudRound.fontScale = 2;
	hudRound.sort = 20;
	hudRound.alpha = 1;
	hudRound.x = 0;
	hudRound.y = 430;
	hudRound.og_scale = 2;
	hudRound.color = ( 0.8, 0.8, 0.8 );
	 
	while( 1 )
	{			
		life = CountLife();
		hudRound SetText( "Lives: "  +  life );
		wait(0.25);
	}
}

//**************************************************************************
//**************************************************************************

ShowScore()
{	
	hud = NewHudElem();
	hud.location = 0;
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = 3;
	hud.sort = 20;
	hud.alpha = 1;
	hud.x = 50;
	hud.y = 50;
	hud.og_scale = 1;
	hud.color = ( 1, 1, 1 );
	 
	showScore = 0;
	while( 1 )
	{		
		realScore = int(GetDvarint( "challenge_score" ));
		diff = realScore - showScore;
		if( diff < 0 )
		{
			showScore =realScore;
		}
		else if( diff > 1000 )
		{
			showScore += 136;
		}
		else if( diff > 36 )
		{
			showScore += 36;
		}
		else
		{
			showScore = realScore;
		}

		hud SetValue( showScore);

		wait(0.05);
	}
} 

//**************************************************************************
//**************************************************************************

ShowSuccess( time )
{
	self endon( "death" );
	
	hudTime = NewHudElem();
	hudTime.location = 0;
	hudTime.alignX = "center";
	hudTime.alignY = "middle";
	hudTime.foreground = 1;
	hudTime.fontScale = 2.5;
	hudTime.sort = 20;
	hudTime.alpha = 1;
	hudTime.x		= 320; 
	hudTime.y		= 240;
	hudTime.og_scale = 1;
	
	hudTime.color = ( 0, 1, 0 );
	
	nextSkill = CalcSkill(level.challenge_round+1);
	//if( nextSkill>GetDvarint( "level_gameskill" ) )
	if( nextSkill > level.gameskill )
	{		
		hudTime.fontScale = 4;
		hudTime SetText( "PROMOTED" );	
		
		//We succeed... got one more life
		SetDvar ("challenge_attemptmax",   GetDvarint( "challenge_attemptmax" ) + 1 );
	}	
	else 
	{
		hudTime.fontScale = 2;
		hudTime SetText( "Cleared" );
	}
		
	wait( time );	
	
	hudTime SetText( "" );

	hudTime destroy();
}


//**************************************************************************
//**************************************************************************

ShowFailure( delay, time )
{
	self endon( "death" );
		
	wait( delay );
	
	hudTime = NewHudElem();
	hudTime.location = 0;
	hudTime.alignX = "left";
	hudTime.alignY = "middle";
	hudTime.foreground = 1;
	hudTime.fontScale = 10;
	hudTime.sort = 20;
	hudTime.alpha = 1;
	hudTime.y = 250;
	hudTime.og_scale = 2;
		
	life = CountLife();

	if( life <= 0 )
	{
		hudTime.x = 120;
		hudTime.color = ( 1, 0, 0 );
		hudTime SetText( "PWNED" );
	}
	else
	{
		hudTime.x = 80;
		hudTime.color = ( 1, 0.2, 0 );

		if( life > 1 )
		{
			hudTime SetText( "" + life + " Lives Left");
		}
		else
		{
			hudTime SetText( "" + life + " Life Left");
		}
	}
		
	wait( time );	
	
	hudTime SetText( "" );
	
	hudTime destroy();
}

//**************************************************************************
//**************************************************************************

SelfMonitorDamageThread()
{
	self			endon( "death" );
	level.player	endon( "death" );

	while(1)
	{
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName);

		if(		(sAttacker == level.player)
			&&	(sTagName == "neck" || sTagName == "head")
			&&  (sType == "MOD_RIFLE_BULLET" || sType == "MOD_PISTOL_BULLET" || sType == "MOD_HEAD_SHOT")			)
		{
			self.challenge_value += 1000;
			break;
		}
	}
}

//**************************************************************************
//**************************************************************************

SelfPenalizedTimeThread()
{
	self endon( "death" );
	self endon( "challenge_StopPenalizedTime" );

	//5 seconds free
	wait( 5 );

	while( self.health > 0 )
	{
		self.challenge_value = self.challenge_value-5;

		if( self.challenge_value > 80 )
		{
			wait(0.5);
		}
		else if( self.challenge_value > 60 )
		{
			wait(1.0);
		}
		else if( self.challenge_value > 40 )
		{
			wait(1.5);
		}
		else if( self.challenge_value > 20 )
		{
			wait(2.0);
		}
		else 
		{
			wait(4.0);
		}
	}
}

//**************************************************************************
//**************************************************************************

SelfScoreThread()
{
	self endon( "death" );
	self.challenge_value = 1000;

	self thread SelfMonitorDamageThread();
	self thread SelfPenalizedTimeThread();
	//self thread ShowValue();
}

//**************************************************************************
//**************************************************************************

ShowValue()
{
	self endon( "death" );

	while(1)
	{
		Print3d(self.origin, "" + self.challenge_value);
		wait(0.05);
	}
}


//**************************************************************************
//**************************************************************************

CalcSkill(round)
{
	if(		IsDefined(level.challenge_Difficulty)
		&&  IsDefined(level.challenge_Difficulty[round])	)
	{
		return level.challenge_Difficulty[round];
	}
	
	//return  GetDvarint( "level_gameskill" );
	return level.gameskill;
}

//**************************************************************************
//**************************************************************************

InitSkill()
{
	//SetDvar( "level_gameskill", CalcSkill(level.challenge_round) );	

	level.gameskill = CalcSkill(level.challenge_round);

	maps\_gameskill::setSkill( true, level.gameskill );
}

//**************************************************************************
//**************************************************************************

Spawner(waitTime)
{
	self endon( "death" );
	
	level.challenge_enemiesCount = 0;
	
	//by default we spawn 1 Ai per round
	// i.e. in round 4, we should spwan 4 AI
	numAi = level.challenge_round;
	
	//--------------------
	//A challenge can overide how many AI to spawn 	
	//by changing the array: level.challenge_AiToSpawn
	//--------------------
	if(		IsDefined(level.challenge_AiToSpawn)
		&&	IsDefined(level.challenge_AiToSpawn[level.challenge_round])	)
	{
		numAi = level.challenge_AiToSpawn[level.challenge_round];
	}

	//--------------------
	
	wait( waitTime );

	//--------------------

	for( round=1; level.challenge_enemiesCount < numAi; round++ )
	{
		spawnerName = "Enemy" + round;
	
		spawners = GetEntArray( spawnerName, "targetname" );
		
		if( isdefined(spawners) && spawners.size > 0 )
		{
			spawners = array_randomize( spawners );

			for( i=0; i < spawners.size && level.challenge_enemiesCount < numAi; i++ )
			{				
				level.challenge_enemies[level.challenge_enemiesCount] = spawners[i] StalingradSpawn();
				
				//Wait 1 frame to make sure everything is initialize correctly
				wait( 0.05 );
				
				if( isdefined(level.challenge_enemies[level.challenge_enemiesCount]) )
				{
					newAI = level.challenge_enemies[level.challenge_enemiesCount];
					
					//newAi SetEnableSense(false);		
					newAI.ignoreall = true;
					
					level notify("ChallengeAiSpawned", newAI );
					
					level.challenge_enemiesCount++;
				}
			}
		}
	}
	
	level.challenge_enemiesCountMax = level.challenge_enemiesCount;	
	
}

//**************************************************************************
//**************************************************************************

WakeUpAI()
{	
	for( i=0; i < level.challenge_enemiesCount; i++ )
	{
		if( IsDefined(level.challenge_enemies[i]) )
		{
			level.challenge_enemies[i].ignoreall = false;
			level.challenge_enemies[i] thread AiPerfectSense(6);
			level.challenge_enemies[i] thread AiDeathListener();
			level.challenge_enemies[i] thread SelfScoreThread();
			level.challenge_enemies[i] thread AiGoalChooser();
			
			level notify("ChallengeAiAwaken", level.challenge_enemies[i] );
		}
	}
}

//**************************************************************************
//**************************************************************************

AiGoalChooser(time)
{
	self endon( "death" );

	while(1)
	{
		if( IsDefined(self.enemy) && DistanceSquared(self.goalpos, self.enemy.origin) > 128*128 )
		{
			self SetGoalEntity( self.enemy );
			self.goalradius = RandomIntRange(768, 1280);
		}

		wait(2);

		/*
		connectedPlayers = get_players();

		alivePlayers = [];
		for( i=0; i < connectedPlayers.size; i++ )
		{
			// not in last stand and not spectating
			if( !connectedPlayers[i] maps\_laststand::player_is_in_laststand() && connectedPlayers[i].sessionstate == "playing" )
			{
				alivePlayers[ alivePlayers.size ] = connectedPlayers[i];
			}
		}

		playerIndex = RandomInt( alivePlayers.size );

		/#
		iprintln("ent " + self GetEntNum() + " chose " + playerIndex );
		#/

		self SetGoalEntity( alivePlayers[playerIndex] );

		alivePlayers[playerIndex] waittill_any( "disconnect", "player_downed" );

		//iprintln("player disconnected/downed");
		*/
	}
}

//**************************************************************************
//**************************************************************************

AiPerfectSense(time)
{
	self endon( "death" );

	timer = 0;
	while( timer < time )
	{
		players = get_players();
		for( i=0; i < players.size; i++ )
		{
			self GetPerfectInfo( players[i] );
		}

		wait(0.05);
	}
	
//	self setscriptspeed("sprint");
//	self lockalertstate("alert_red");
//	self setperfectsense(true);
//	
//	wait(time);
//	
//	self setperfectsense(false);

//	self SetEntityTarget( level.player, 1 );
}

//**************************************************************************
//**************************************************************************

AiDeathListener(time)
{
	self waittill( "death" );
	
	level.challenge_enemiesCount--;
	
	if( self.challenge_value <= 0 )
	{
		self.challenge_value = 1;
	}

	//score = GetDvarint( "challenge_score" ) + (GetDvarint( "level_gameskill" )+1)*self.challenge_value;
	score = GetDvarint( "challenge_score" ) + (level.gameskill+1)*self.challenge_value;
	SetDvar ("challenge_score", "" + score );
}

//**************************************************************************
//**************************************************************************

AiCorpseCleanup()
{
	delete_ents( level.CONTENTS_CORPSE, get_players()[0].origin, 10000 );
}

//**************************************************************************
//**************************************************************************

WarpTo(warpPt)
{	
	self setorigin( warpPt.origin );
	self setplayerangles( warpPt.angles );
}

//**************************************************************************
//**************************************************************************

WarpPlayerThreat(delay, time)
{	
	self endon( "death" );
	self endon( "challenge_start" );
	
	wait(delay);

	for( i=0; i < get_players().size; i++ )
	{
		get_players()[i] FreezeControls(true);
	}

	playerstart_array = GetEntArray( "playerstart", "targetname" );

	if( isdefined(playerstart_array) && playerstart_array.size > 0 )
	{
		playerstart_array = array_randomize( playerstart_array );

		for( i=0; i < playerstart_array.size && i < get_players().size; i++ )
		{
			get_players()[i] WarpTo( playerstart_array[i] );
		}
	}

	wait(time);

	for( i=0; i < get_players().size; i++ )
	{
		get_players()[i] FreezeControls(false);
	}
}

//**************************************************************************
//**************************************************************************

BlackScreen(fadein, stay, fadeout)
{
	blackscreen = NewHudElem();
	
	blackscreen.alpha = 0;
	blackscreen.horzAlign = "fullscreen";
	blackscreen.vertAlign = "fullscreen";
	
	blackscreen SetShader( "black", 640, 480 );
	if( fadein > 0 )
	{
		blackscreen fadeOverTime( fadein ); 
	}
	blackscreen.alpha = 1;

	AiCorpseCleanup();
	
	wait (stay);
	
	if( fadeout > 0 )
	{
		blackscreen fadeOverTime( fadeout ); 
	}
	blackscreen.alpha = 0;	
	
	blackscreen destroy();
}

//**************************************************************************
//**************************************************************************

InitRound()
{
	if( isdefined(level.challenge_round) )
	{			
		level.challenge_round++;
	}
	else
	{
		level.challenge_round = 1;
	}
			
	//SetDvar ("challenge_attemptcount", "0");
	
	//Restore the player health	
	players = get_players();
	for( i=0; i < players.size; i++ )
	{
		// respawn all the spectators
		if( players[i].health <= 0 || players[i].sessionstate == "spectator" )
		{
			players[i] [[level.spawnPlayer]]();
		}

		// TODO: don't know what the proper way to do this is
		if( players[i] maps\_laststand::player_is_in_laststand() )
		{
			players[i] maps\_laststand::revive_force_revive( players[i] );
			players[i] notify ( "zombified" );
		}

		//players[i] GiveMaxAmmo( "m16_sp" );
		players[i].health	= level.challenge_PlayerHealth;
	}
}

//**************************************************************************
//**************************************************************************

OnPlayerConnect()
{
//	level.playerCount++;
//	println("OnPlayerConnect: " + level.playerCount);
}

//**************************************************************************
//**************************************************************************

OnPlayerDisconnect()
{
//	level.playerCount--;
//	println("OnPlayerDisconnect: " + level.playerCount);
}

//**************************************************************************
//**************************************************************************

OnPlayerKilled()
{
//	level.playerCount--;
//	println("OnPlayerKilled: " + level.playerCount);

	LevelFail();
}

//**************************************************************************
//**************************************************************************

OnSpawnSpectator()
{
//	level.playerCount--;
//	println("OnSpawnSpectator: " + level.playerCount);

	self.ignoreme = false;
}

//**************************************************************************
//**************************************************************************