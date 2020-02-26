#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	precacheItem( "nuke_mp" );
	precacheLocationSelector( "map_nuke_selector" );
	precacheString( &"MP_NUCLEAR_STRIKE_CALLED" );
	precacheString( &"MP_FRIENDLY_NUCLEAR_STRIKE" );
	precacheString( &"MP_NUCLEAR_STRIKE" );

	level._effect[ "nuke_player" ] = loadfx( "explosions/player_death_nuke" );
	level._effect[ "nuke_flash" ] = loadfx( "explosions/player_death_nuke_flash" );
	//level._effect[ "nuke_ash" ] = loadfx( "weather/ash_turb_aftermath" );

	game["strings"]["nuclear_strike"] = &"MP_NUCLEAR_STRIKE";
	
	level.killstreakFuncs["nuke"] = ::tryUseNuke;
	level.nukeTimer = 10;
	
	/#
	setDevDvarIfUninitialized( "scr_nukeDistance", 5000 );
	setDevDvarIfUninitialized( "scr_nukeEndsGame", 1 );
	setDevDvarIfUninitialized( "scr_nukeDebugPosition", 0 );

	level thread onPlayerConnect();
	#/
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "spawned_player" );
		
		nukeEndsGame = 1;
		/# nukeEndsGame = getDvarInt( "scr_nukeEndsGame" );	#/
	
		if ( !nukeEndsGame )
			VisionSetNaked( getDvar( "mapname" ) );
	}
}

tryUseNuke( lifeId )
{
	if( isDefined( level.nukeIncoming ) )
	{
		self iPrintLnBold( "Nuclear strike already inbound!" );
		return false;	
	}

	if ( self isUsingRemote() && ( !isDefined( level.gtnw ) || !level.gtnw ) )
		return false;

	self thread doNuke();
	self notify( "used_nuke" );
	
	return true;
}

doNuke()
{
	level.nukeInfo = spawnStruct();
	level.nukeInfo.player = self;
	level.nukeInfo.team = self.pers["team"];
	level.nukeIncoming = true;
	
	maps\mp\gametypes\_gamelogic::pauseTimer();
	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.nukeTimer * 1000) ) );
	setDvar( "ui_bomb_timer", 4 ); // Nuke sets '4' to avoid briefcase icon showing
	
	if ( level.teambased )
	{
		thread teamPlayerCardSplash( "used_nuke", self, self.team );

		players = level.players;
		
		foreach( player in level.players )
		{
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == self.pers["team"] )
					player iprintln( &"MP_NUCLEAR_STRIKE_CALLED", self );
			}
		}
	}
	else
	{
		if ( !level.hardcoreMode )
			self iprintlnbold(&"MP_FRIENDLY_NUCLEAR_STRIKE");
	}

	//thread nukeMessage();
	//thread nukeAftermath();
	
	level delaythread( (level.nukeTimer - 3.3), ::nukeSoundIncoming );
	level delaythread( level.nukeTimer, ::nukeSoundExplosion );
	level delaythread( level.nukeTimer, ::nukeSlowMo );
	level delaythread( level.nukeTimer, ::nukeEffects );
	level delaythread( (level.nukeTimer + 0.25), ::nukeVision );
	level delaythread( (level.nukeTimer + 1.5), ::nukeDeath );
	level delaythread( (level.nukeTimer + 1.5), ::nukeEarthquake );

	clockObject = spawn( "script_origin", (0,0,0) );
	clockObject hide();

	while ( !level.gameEnded )
	{
		clockObject playSound( "ui_mp_nukebomb_timer" );
		wait( 1.0 );
	}
}

nukeSoundIncoming()
{
	foreach( player in level.players )
		player playlocalsound( "nuke_incoming" );
}

nukeSoundExplosion()
{
	foreach( player in level.players )
	{
		player playlocalsound( "nuke_explosion" );
		player playlocalsound( "nuke_wave" );
	}
}

/*nukeSounds()
{
	foreach( player in level.players )
	{
		player playlocalsound( "nuke_incoming" );
		player delayCall( 2.2, ::playlocalsound, "nuke_explosion" );
		player delayCall( 2.2, ::playlocalsound, "nuke_wave" );
	}
}*/

/*nukeMessage()
{
	foreach( player in level.players )
		player iPrintLnBold( "NUCLEAR STRIKE INBOUND!" );
}*/

nukeEffects()
{
	setDvar( "ui_bomb_timer", 0 );
	setGameEndTime( 0 );

	foreach( player in level.players )
	{
		playerForward = anglestoforward( player.angles );
		playerForward = ( playerForward[0], playerForward[1], 0 );
		playerForward = VectorNormalize( playerForward );
	
		nukeDistance = 5000;
		/# nukeDistance = getDvarInt( "scr_nukeDistance" );	#/

		nukeEnt = Spawn( "script_model", player.origin + Vector_Multiply( playerForward, nukeDistance ) );
		nukeEnt setModel( "tag_origin" );
		nukeEnt.angles = ( 0, (player.angles[1] + 180), 90 );

		/#
		if ( getDvarInt( "scr_nukeDebugPosition" ) )
		{
			lineTop = ( nukeEnt.origin[0], nukeEnt.origin[1], (nukeEnt.origin[2] + 500) );
			thread draw_line_for_time( nukeEnt.origin, lineTop, 1, 0, 0, 10 );
		}
		#/

		nukeEnt thread nukeEffect( player );
	}
}

nukeEffect( player )
{
	waitframe();
	PlayFXOnTagForClients( level._effect[ "nuke_flash" ], self, "tag_origin", player );
}

nukeSlowMo()
{
	//SetSlowMotion( <startTimescale>, <endTimescale>, <deltaTime> )
	setSlowMotion( 1.0, 0.25, 0.5 );
	level waittill( "nuke_death" );
	setSlowMotion( 0.25, 1, 2.0 );
}

nukeVision()
{
	//visionSetNaked( "mp_nuke_flash", 3 );
	//wait 3;
	visionSetNaked( "mpnuke", 3 );
	level waittill( "nuke_death" );
	visionSetNaked( "mpnuke_aftermath", 5 );
	/*wait 5;*/
	//VisionSetNaked( getDvar( "mapname" ), 5 );
}

nukeDeath()
{
	level notify( "nuke_death" );

	//PhysicsExplosionCylinder( nukepos, 100, 100, 10 );
	AmbientStop(1);
	
	foreach( player in level.players )
	{
		player.nuked = true;

		if ( isAlive( player ) )
			player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( level.nukeInfo.player, level.nukeInfo.player, 999999, 0, "MOD_EXPLOSIVE", "nuke_mp", player.origin, player.origin, "none", 0, 0 );
	      //player thread finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, stunFraction )
	}

	level.nukeDetonated = true;
	level.postRoundTime = 10;

	nukeEndsGame = 1;
	/# nukeEndsGame = getDvarInt( "scr_nukeEndsGame" );	#/

	if ( nukeEndsGame ) //&& ( !isDefined( level.nukeInfo.player.capturedNuke ) || !level.nukeInfo.player.capturedNuke ) ) used for round based gtnw
	{
		if ( level.teamBased )
			thread maps\mp\gametypes\_gamelogic::endGame( level.nukeInfo.team, game["strings"]["nuclear_strike"], true );
		else
		{
			if ( isDefined( level.nukeInfo.player ) )
				thread maps\mp\gametypes\_gamelogic::endGame( level.nukeInfo.player, game["strings"]["nuclear_strike"], true );
			else
				thread maps\mp\gametypes\_gamelogic::endGame( level.nukeInfo, game["strings"]["nuclear_strike"], true );
		}
	}
}

nukeEarthquake()
{
	level waittill( "nuke_death" );

	// TODO: need to get a different position to call this on
	//earthquake( 0.6, 10, nukepos, 100000 );

	//foreach( player in level.players )
		//player PlayRumbleOnEntity( "damage_heavy" );
}

/*nukeAftermath()
{
	level waittill( "nuke_death" );
	
	for( ;; )
	{
		foreach( player in level.players )
			PlayFXOnTagForClients( level._effect[ "nuke_ash" ], player, "tag_origin", player );

		wait( 0.2 ); // This would be bad to repeat the effect in script calls
	}
}*/

waitForNukeCancel()
{
	self waittill( "cancel_location" );
	self setblurforplayer( 0, 0.3 );
}

endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	self waittill( waitfor );
	self thread stopNukeLocationSelection( (waitfor == "disconnect") );
}

endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	level waittill( "game_ended" );
	self thread stopNukeLocationSelection( false );
}

stopNukeLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self setblurforplayer( 0, 0.3 );
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}

/*displayGameEndNuke( winner, endReasonText )
{	
	foreach ( player in level.players )
	{
		if ( isDefined( player.connectedPostGame ) || player.pers["team"] == "spectator" )
			continue;
		
		if ( level.teamBased )
			player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, false, endReasonText );
		else
			player thread maps\mp\gametypes\_hud_message::outcomeNotify( winner, endReasonText );
	}
	
	level notify ( "game_win", winner );
	
	roundEndWait( level.postRoundTime, true );
}*/
