#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

// Manager for all weapons that can be remotely controlled with the tablet

#define REMOTE_USE_HOLD_TIME_SECONDS 0.3

init()
{
	level.remoteWeapons = [];

	level.remoteWeapons[ "killstreak_remote_turret_mp" ] = SpawnStruct();
	level.remoteWeapons[ "killstreak_remote_turret_mp" ].hintString = &"MP_REMOTE_USE_TURRET";
	level.remoteWeapons[ "killstreak_remote_turret_mp" ].useCallback = maps\mp\killstreaks\_turret_killstreak::startTurretRemoteControl;
	level.remoteWeapons[ "killstreak_remote_turret_mp" ].endUseCallback = maps\mp\killstreaks\_turret_killstreak::endRemoteTurret;
	
	level.remoteWeapons[ "killstreak_ai_tank_mp" ] = SpawnStruct();
	level.remoteWeapons[ "killstreak_ai_tank_mp" ].hintString = &"MP_REMOTE_USE_TANK";
	level.remoteWeapons[ "killstreak_ai_tank_mp" ].useCallback = maps\mp\killstreaks\_ai_tank::startTankRemoteControl;
	level.remoteWeapons[ "killstreak_ai_tank_mp" ].endUseCallback = maps\mp\killstreaks\_ai_tank::endTankRemoteControl;
	
	level.remoteExitHint = &"MP_REMOTE_EXIT";

	level thread onPlayerConnect();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill( "spawned_player" );

		if ( IsDefined( self.remoteControlTrigger ))
		{
			// a remote control trigger exists so reattach it to myself
			self.remoteControlTrigger.origin = self.origin;
			self.remoteControlTrigger LinkTo( self );
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
initRemoteWeapon( weapon, weaponName ) // self == player
{
	weapon.initTime = GetTime();
	weapon.remoteName = weaponName;
	
	if ( IsDefined( self.remoteWeapon ))
	{
		weapon thread watchFindRemoteWeapon( self );
	}
	else
	{
		self setActiveRemoteControlledWeapon( weapon, weaponName );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchFindRemoteWeapon( player ) // self == remote weapon (tank etc)
{
	self endon( "death" );

	player waittill( "find_remote_weapon" );

	player notify( "remote_weapon_ping", self );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
setActiveRemoteControlledWeapon( weapon, weaponName ) // self == player
{
	/#
	assert( !IsDefined( self.remoteWeapon ), "Trying to activate remote weapon without cleaning up the current one" );
	#/

	if ( IsDefined( self.remoteWeapon ))
	{
		return;
	}

	self notify( "set_active_remote_weapon" );

	self.remoteWeapon = weapon;

	self thread watchRemoveRemoteControlledWeapon( weaponName );
	self thread watchRemoteControlledWeaponDeath();
	self thread watchRemoteWeaponPings();

	self createRemoteWeaponTrigger( weaponName );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoteWeaponPings() // self == player
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "set_active_remote_weapon" );

	self.remoteWeaponQueue = [];

	self thread collectWeaponPings();

	while ( true )
	{
		self waittill( "remote_weapon_ping", weapon );

		if ( IsDefined( weapon ))
		{
			self.remoteWeaponQueue[ self.remoteWeaponQueue.size ] = weapon;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
collectWeaponPings() // self == player
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	self waittill( "remote_weapon_ping" );

	// watchRemoteWeaponPings() will collect all remote weapons this frame
	wait( 0.1 );

	if ( IsDefined( self ))
	{
		/#
		assert( IsDefined( self.remoteWeaponQueue ));
		#/

		best_weapon = undefined;
		foreach ( weapon in self.remoteWeaponQueue )
		{
			if ( IsDefined( weapon ) && IsAlive( weapon ))
			{
				if ( !IsDefined( best_weapon ) || ( best_weapon.initTime < weapon.initTime ))
				{
					best_weapon = weapon;
				}
			}
		}

		if ( IsDefined( best_weapon ))
		{
			self setActiveRemoteControlledWeapon( best_weapon, weapon.remoteName );
		}
	}
}
	

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoteControlledWeaponDeath() // self == player
{
	self endon( "remove_remote_weapon" );
	/# 
	assert( IsDefined( self.remoteWeapon ));
	#/

	self.remoteWeapon waittill( "death" );

	if ( IsDefined( self ))
	{
		self notify( "remove_remote_weapon", true );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoveRemoteControlledWeapon( weaponName ) // self == player
{
	// this should be the only place the player references to remoteWeapon/trigger should be cleaned up
	self endon( "disconnect" );

	self waittill( "remove_remote_weapon", tryToReplace );

	if ( tryToReplace == true )
	{
		self notify( "find_remote_weapon" );
	}

	self removeRemoteControlledWeapon( weaponName );	
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
removeRemoteControlledWeapon( weaponName ) // self == player
{
	if ( self isUsingRemote() )
	{
		remoteWeaponName = self getRemoteName();
		if ( remoteWeaponName == weaponName )
		{
			self baseEndRemoteControlWeaponUse( weaponName, true );
		}
	}

	self destroyRemoteControlActionPromptHUD();

	self.remoteWeapon = undefined;
	self.remoteControlTrigger delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
createRemoteWeaponTrigger( weaponName ) // self == player
{
	trigger = Spawn( "trigger_radius_use", self.origin, 32, 32 );
	trigger EnableLinkTo();
	trigger LinkTo( self );

	trigger SetHintLowPriority( true );

	trigger SetCursorHint( "HINT_NOICON" );
	trigger SetHintString( level.remoteWeapons[ weaponName ].hintString );

	if ( level.teamBased )
	{
		trigger SetTeamForTrigger( self.team );
		trigger.triggerTeam = self.team;
	}

	self ClientClaimTrigger( trigger );
	trigger.ClaimedBy = self;

	self.remoteControlTrigger = trigger;

	self thread watchRemoteTriggerUse( weaponName );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoteTriggerUse( weaponName ) // self == player
{
	self endon ( "remove_remote_weapon" );

	while( true )
	{
		self.remoteControlTrigger waittill( "trigger", player );
		{
			if ( isdefined( self.remoteWeapon ) && isdefined( self.remoteWeapon.hackertrigger ) && isdefined ( self.remoteWeapon.hackertrigger.progressbar ) )
			{	if ( weaponName == "killstreak_remote_turret_mp" )
				{
					self iPrintLnBold( &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
				}
				continue;
			}
			if ( self useButtonPressed() && !self.throwingGrenade && !self meleeButtonPressed() )
			{
				self useRemoteControlWeapon( weaponName );
			}
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
useRemoteControlWeapon( weaponName ) // self == player
{
	self giveWeapon( weaponName );
	self switchToWeapon( weaponName );

	self waittill( "weapon_change", newWeapon );

	self setUsingRemote( weaponName );

	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( weaponName );

	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self clearUsingRemote();
		}
	}
	else
	{
		self.remoteWeapon.controlled = true;
		self.remoteWeapon.killCamEnt = self;
		self.remoteWeapon notify("remote_start"); // shuts down the AI scripts for this weapon

		self thread watchRemoteControlDeactivate( weaponName );
		self thread [[level.remoteWeapons[ weaponName ].useCallback]]( self.remoteWeapon );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
createRemoteControlActionPromptHUD() // self == player
{
	if ( !isDefined(self.hud_prompt_exit))
	{
		self.hud_prompt_exit = newclienthudelem( self );
	}

	self.hud_prompt_exit.alignX = "center";
	self.hud_prompt_exit.alignY = "bottom";
	self.hud_prompt_exit.horzAlign = "user_center";
	self.hud_prompt_exit.vertAlign = "user_bottom";
	self.hud_prompt_exit.foreground = true;
	self.hud_prompt_exit.font = "small";
	self.hud_prompt_exit.fontScale = 1.25;
	self.hud_prompt_exit.hidewheninmenu = true;
	self.hud_prompt_exit.archived = false;
	self.hud_prompt_exit.x = 0;
	self.hud_prompt_exit.y = -90;
	self.hud_prompt_exit SetText(level.remoteExitHint);
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
destroyRemoteControlActionPromptHUD() // self == player
{
	if ( isDefined( self )  && isDefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit destroy();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
watchRemoteControlDeactivate( weaponName ) // self == player
{
	self endon( "remove_remote_weapon" );
	self endon( "disconnect" );
	self.remoteWeapon endon( "remote_start" );

	wait( 1 );
	
	while( true )
	{
		timeUsed = 0;
		while( self UseButtonPressed() )
		{
			timeUsed += 0.05;
			if ( timeUsed > REMOTE_USE_HOLD_TIME_SECONDS )
			{
				self thread baseEndRemoteControlWeaponUse( weaponName, false );
				return;
			}
			wait ( 0.05 );
		}
		wait ( 0.05 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
endRemoteControlWeaponUse( weaponName ) // self == player
{
	if ( IsDefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit SetText("");
	}

	self [[level.remoteWeapons[ weaponName ].endUseCallback]]( self.remoteWeapon );
}

fadeOutToBlack( isDead )
{
	self endon("disconnect");
	if ( isDead )
	{
		self thread maps\mp\killstreaks\_remotemissile::staticEffect( 1.0 );
		wait( 0.75 );
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.25, 0.1, 0.25 );
	}
	else
	{
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0, 0.2, 0, 0.3 );
	}
}
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
baseEndRemoteControlWeaponUse( weaponName, isDead ) // self == player
{
	if ( IsDefined( self ) )
	{
		self thread fadeOutToBlack( isDead );

		self clearUsingRemote(); // must come before the end use callback, its notify clears all the AI threads on the remote weapons
		self takeweapon( weaponName );
	}
	
	if ( isDefined( self.remoteWeapon ))
	{
		self.remoteWeapon.controlled = false;

		self [[level.remoteWeapons[ weaponName ].endUseCallback]]( self.remoteWeapon, isDead );

		self.remoteWeapon.killCamEnt = self.remoteWeapon;

		self unlink();
		self.killstreak_waitamount = undefined;
		self destroyRemoteHUD();
		self ClientNotify( "nofutz" );
		
		if ( isdefined(level.gameEnded) && level.gameEnded )
		{
			self freezecontrolswrapper( true );
		}
	}

	if ( IsDefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit SetText("");
	}		
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
destroyRemoteHUD()
{	
	self UseServerVisionset( false );
	self SetInfraredVision( false );
	if ( isdefined(self.fullscreen_static) )
		self.fullscreen_static destroy();
	if ( isdefined(self.remote_hud_reticle) )
		self.remote_hud_reticle destroy();
	if ( isdefined(self.remote_hud_bracket_right) )
		self.remote_hud_bracket_right destroy();
	if ( isdefined(self.remote_hud_bracket_left) )
		self.remote_hud_bracket_left destroy();
	if ( isdefined(self.remote_hud_arrow_right) )
		self.remote_hud_arrow_right destroy();
	if ( isdefined(self.remote_hud_arrow_left) )
		self.remote_hud_arrow_left destroy();
	if ( isdefined(self.tank_rocket_1) )
		self.tank_rocket_1 destroy();	
	if ( isdefined(self.tank_rocket_2) )
		self.tank_rocket_2 destroy();
	if ( isdefined(self.tank_rocket_3) )
		self.tank_rocket_3 destroy();
	if ( isdefined(self.tank_rocket_hint) )
		self.tank_rocket_hint destroy();
	if ( isdefined(self.tank_mg_bar) )
		self.tank_mg_bar destroy();
	if ( isdefined(self.tank_mg_arrow) )
		self.tank_mg_arrow destroy();
	if ( isdefined(self.tank_mg_hint) )
		self.tank_mg_hint destroy();
	if ( isdefined(self.tank_fullscreen_effect) )
		self.tank_fullscreen_effect destroy();
	if ( IsDefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit destroy();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
stunStaticFX( duration )
{

	self endon( "remove_remote_weapon" );
	self.fullscreen_static.alpha = 0.65;
	wait ( duration - 0.5 );
	time = duration - 0.5;
	while ( time < duration )
	{
		wait( 0.05 );
		time += 0.05;
		self.fullscreen_static.alpha -= 0.05;
	}
	self.fullscreen_static.alpha = 0.15;
}
