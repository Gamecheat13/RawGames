#include maps\_utility;
init()
{
}

SetupCallbacks()
{
	level.spawnPlayer = ::spawnPlayer;
	level.spawnClient = ::spawnClient;
	
	level.onSpawnPlayer = ::default_onSpawnPlayer;
	level.onPostSpawnPlayer = ::default_onPostSpawnPlayer;
	level.onSpawnSpectator = ::default_onSpawnSpectator;

	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;

	level.loadout = ::menuLoadout;
}


blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

Callback_SaveRestored()
{
	/#
	println("****Coop CodeCallback_SaveRestored****");
	#/
	
	players = get_players();
	level.debug_player = players[0];	
}

Callback_PlayerConnect()
{
	thread dummy();

	self waittill( "begin" );
	waittillframeend;

	// SCRIPTER_MOD
	// JesseS (3/15/2007): added player flag setup function
	self setup_player_flags();
//	wait( 2 );

	self.pers["class"] = "closequarters";

	// we want to give the player a good default starting position
	// info_player_spawn actually gets renamed to info_player_deathmatch
	// in the game
	info_player_spawn = getent( "info_player_deathmatch", "classname" );
	
	if ( isdefined( info_player_spawn ) )
	{
		self setOrigin( info_player_spawn.origin );
		self setPlayerAngles( info_player_spawn.angles );
	}
		
  /#
  if ( !isdefined(level.sPawnClient) )
  {
  	waittillframeend;
 		self spawn( self.origin, self.angles );
 		return;
	}  
  #/
		self setClientDvar( "ui_allow_loadoutchange", "1" );
//		if ( isDefined( self.pers["class"] ) && self.pers["class"] != "" )
//		{
//			self thread [[level.spawnClient]]();				
//		}
//		else
		{
			// right now this will always be for a splitscreen player
			// this will need to be changed to work with full screen players later
			self openMenu( "loadout_splitscreen" );
		}
}

Callback_PlayerDisconnect()
{
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	// get rid of the head icon
	self.headicon = "";

	// wait for the death sequence to finish
	wait( 5 );
	
  /#
  if ( !isdefined(level.spawnClient) )
  {
  	waittillframeend;
 		self spawn( self.origin, self.angles );
 		return;
	}  
  #/
	self thread [[level.spawnClient]]();
}

// this function is going to handle waiting for player input or programmed delays before starting the spawn
spawnClient()
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );

	self thread	[[level.spawnPlayer]]();
}

spawnPlayer()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	self notify("end_respawn");

	self detachAll();

	self [[level.onSpawnPlayer]]();
	
	if( IsDefined( level.player_spawnpoints ) && level.player_spawnpoints.size > 0 )
	{
		// Testing
		spawnpoint = level.player_spawnpoints[0];
		self Spawn( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self Spawn( self.origin, self.angles );
	}

	// SCRIPTER_MOD
	// JesseS (3/15/2007): moved this call to here from above the if / else
	self thread maps\_load::player_init();
	
	self [[level.onPostSpawnPlayer]]();

	// should not need this wait.  something in the spawn overides the weapons
	waittillframeend;
	self notify( "spawned_player" );
}

default_onSpawnPlayer()
{
}


default_onPostSpawnPlayer()
{
}


default_onSpawnSpectator()
{
}

dummy()
{
	waittillframeend;

	if( isDefined( self ) )
		level notify( "connecting", self );
}

menuLoadout(response)
{
//	class = self maps\mp\gametypes\_class::getClassChoice( response );
	println("*************************************** " + response );
	
	if ( response != "back" )
	{
			self.pers["class"] = response;
	}
	
	self thread [[level.spawnClient]]();
}

// SCRIPTER_MOD
// JesseS (3/15/2007): added flags to be called on the player
setup_player_flags()
{
	self player_flag_init("player_has_red_flashing_overlay");
	self player_flag_init("player_is_invulnerable");
}