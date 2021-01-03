#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_turret;

 

// Manager for all weapons that can be remotely controlled with the tablet

	
#namespace remote_weapons;

function init()
{
	level.remoteWeapons = [];
	level.remoteExitHint = &"MP_REMOTE_EXIT";
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self endon("disconnect");

	if ( isdefined( self.remoteControlTrigger ))
	{
		self.remoteControlTrigger.origin = self.origin;
		self.remoteControlTrigger LinkTo( self );
	}
}

function RegisterRemoteWeapon( weaponName, hintString, useCallback, endUseCallback )
{
	assert( isdefined( level.remoteWeapons ) );

	level.remoteWeapons[ weaponName ] = SpawnStruct();
	level.remoteWeapons[ weaponName ].hintString = hintString;
	level.remoteWeapons[ weaponName ].useCallback = useCallback;
	level.remoteWeapons[ weaponName ].endUseCallback = endUseCallback;
}

function UseRemoteWeapon( weapon, weaponName, immediate )
{
	player = self;
	assert( IsPlayer( player ) );
	
	weapon.remoteOwner = player;
	weapon.initTime = GetTime();
	weapon.remoteName = weaponName;
	
	weapon thread WatchRemoveRemoteControlledWeapon();

	if( !immediate )
	{
		weapon CreateRemoteWeaponTrigger();
	}
	else
	{
		weapon UseRemoteControlWeapon();
	}
}
	
function WatchRemoveRemoteControlledWeapon()
{
	weapon = self;
	weapon endon( "remote_weapon_end" );
	weapon util::waittill_any( "death", "remote_weapon_shutdown" );
		
	weapon EndRemoteControlWeaponUse( false );
	
	while( isdefined( weapon ) )
	{
		{wait(.05);}; // Wait until any death animations and any other waits are finished
	}
	
	//Check for queued remote weapon
}

function CreateRemoteWeaponTrigger()
{
	weapon = self;
	player = weapon.remoteOwner;
	
	weapon.useTrigger = spawn( "trigger_radius_use", player.origin, 32, 32 );
	weapon.useTrigger EnableLinkTo();
	weapon.useTrigger LinkTo( player );
	weapon.useTrigger SetHintLowPriority( true );
	weapon.useTrigger SetCursorHint( "HINT_NOICON" );
	weapon.useTrigger SetHintString( level.remoteWeapons[ weapon.remoteName ].hintString );

	if( level.teamBased )
	{
		weapon.useTrigger SetTeamForTrigger( player.team );
		weapon.useTrigger.team = player.team;
	}

	player ClientClaimTrigger( weapon.useTrigger );
	player.remoteControlTrigger = weapon.useTrigger;
	weapon.useTrigger.ClaimedBy = player;
	
	weapon thread WatchWeaponDeath();
	weapon thread WatchOwnerDisconnect();
	weapon thread WatchRemoteTriggerUse();
	weapon thread WatchRemoteTriggerDisable();
}

function WatchWeaponDeath()
{
	weapon = self;
	weapon.useTrigger endon( "death" );
	
	weapon util::waittill_any( "death", "remote_weapon_end" );
	weapon.useTrigger delete();
}

function WatchOwnerDisconnect()
{
	weapon = self;
	weapon endon( "remote_weapon_end" );
	weapon endon( "remote_weapon_shutdown" );
	weapon.useTrigger endon( "death" );
	
	weapon.remoteOwner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	EndRemoteControlWeaponUse( false );
	weapon.useTrigger delete();
}

function WatchRemoteTriggerDisable()
{
	weapon = self;
	weapon endon( "remote_weapon_end" );
	weapon endon( "remote_weapon_shutdown" );
	weapon.useTrigger endon( "death" );
	
	while( true )
	{
		weapon.useTrigger TriggerEnable( !( weapon.remoteOwner IsWallRunning() ) && !( weapon.remoteOwner IsPlayerSwimming() ) );
		wait( 0.1 );
	}
}

function WatchRemoteTriggerUse()
{
	weapon = self;
	weapon endon( "death" );
	weapon endon( "remote_weapon_end" );

	if( weapon.remoteOwner util::is_bot() )
	{
		return;
	}

	while( true )
	{
		weapon.useTrigger waittill( "trigger", player );
		
		if( weapon.remoteOwner IsUsingOffhand() || weapon.remoteOwner IsWallRunning() || weapon.remoteOwner IsPLayerSwimming() )
		{
			continue;
		}
		
		if( isdefined( weapon.hackertrigger ) && isdefined( weapon.hackertrigger.progressbar ) )
		{	
			if( weapon.remoteName == "killstreak_remote_turret" )
			{
				weapon.remoteOwner iPrintLnBold( &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
			}
			
			continue;
		}
		if( weapon.remoteOwner useButtonPressed() && !weapon.remoteOwner.throwingGrenade && !weapon.remoteOwner meleeButtonPressed() && !weapon.remoteOwner util::isUsingRemote() )
		{
			UseRemoteControlWeapon();
		}
	}
}

function UseRemoteControlWeapon()
{
	weapon = self;
	
	weapon.remoteOwner DisableOffhandWeapons();
	weapon.remoteOwner DisableWeaponCycling();

	if( !isdefined( weapon.disableRemoteWeaponSwitch ) )
	{
		remoteWeapon = GetWeapon( "killstreak_remote" );
		weapon.remoteOwner giveWeapon( remoteWeapon );
		weapon.remoteOwner switchToWeapon( remoteWeapon );
		weapon.remoteOwner waittill( "weapon_change", newWeapon );
	}
	
	weapon.remoteOwner thread killstreaks::watch_for_remove_remote_weapon();
	
	weapon.remoteOwner util::setUsingRemote( weapon.remoteName );
	weapon.remoteOwner util::freeze_player_controls( true );
	
	if( !weapon.remoteOwner IsOnGround() || weapon.remoteOwner IsPlayerSwimming() )
	{
		weapon.remoteOwner killstreaks::clear_using_remote();
		weapon.remoteOwner util::freeze_player_controls( false );
		return;
	}
	
	result = weapon.remoteOwner killstreaks::init_ride_killstreak( weapon.remoteName );

	if( result != "success" )
	{
		if( result != "disconnect" )
		{
			weapon.remoteOwner killstreaks::clear_using_remote();
		}
	}
	else if( !weapon.remoteOwner IsOnGround() || weapon.remoteOwner IsWallRunning() || weapon.remoteOwner IsPlayerSwimming() )
	{
		weapon.remoteOwner killstreaks::clear_using_remote();
		weapon.remoteOwner util::freeze_player_controls( false );
	}
	else
	{
		weapon.controlled = true;
		weapon.killCamEnt = self;
		weapon notify("remote_start"); // shuts down the AI scripts for this weapon
		weapon thread watchRemoteControlDeactivate();
		weapon.remoteOwner thread [[level.remoteWeapons[ weapon.remoteName ].useCallback]]( weapon );
	}
	
	weapon.remoteOwner util::freeze_player_controls( false );
}

function WatchRemoteControlDeactivate()
{
	weapon = self;
	weapon endon( "remote_weapon_end" );
	weapon endon( "death" );
	weapon.remoteOwner endon( "disconnect" );
	
	while( true )
	{
		timeUsed = 0;
		while( weapon.remoteOwner UseButtonPressed() )
		{
			timeUsed += 0.05;
			if ( timeUsed > 0.25 )
			{
				weapon EndRemoteControlWeaponUse( true );
				return;
			}
			{wait(.05);};
		}
		{wait(.05);};
	}
}

function EndRemoteControlWeaponUse( exitRequestedByOwner )
{
	weapon = self;
	
	if( isdefined( weapon.remoteOwner ) && isdefined( weapon.controlled ) && weapon.controlled )
	{
		if( isdefined( weapon.remoteWeaponShutdownDelay ) ) //when changing teams or disconnect, we can skip this
		{
			wait( weapon.remoteWeaponShutdownDelay );
		}
		
		weapon.remoteOwner thread FadeToBlack();
		weapon.remoteOwner.killstreak_waitamount = undefined;
		weapon.remoteOwner killstreaks::clear_using_remote(); // must come before the end use callback, its notify clears all the AI threads on the remote weapons
		weapon.remoteOwner takeweapon( GetWeapon( weapon.remoteName ) );
	}
	
	if( isdefined( weapon ))
	{
		weapon.controlled = false;

		self [[ level.remoteWeapons[ weapon.remoteName ].endUseCallback]]( weapon, exitRequestedByOwner );

		weapon.killCamEnt = weapon;

		if( isdefined( weapon.remoteOwner ) )
		{
			weapon.remoteOwner unlink();
			weapon.remoteOwner.killstreak_waitamount = undefined;
			weapon.remoteOwner util::clientNotify( "nofutz" );
			
			if( isdefined( level.gameEnded ) && level.gameEnded )
			{
				weapon.remoteOwner util::freeze_player_controls( true );
			}	
		}
	}

	if( !exitRequestedByOwner )
	{
		weapon notify( "remote_weapon_end" );	
	}
}

function FadeToBlack()
{
	self endon("disconnect");
	self endon( "early_death" );
	self thread hud::fade_to_black_for_x_sec( 0, 0.2, 0, 0.3 );
}

function stunStaticFX( duration )
{
	self endon( "remove_remote_weapon" );
	self.fullscreen_static.alpha = 0.65;
	wait ( duration - 0.5 );
	time = duration - 0.5;
	while ( time < duration )
	{
		{wait(.05);};
		time += 0.05;
		self.fullscreen_static.alpha -= 0.05;
	}
	self.fullscreen_static.alpha = 0.15;
}
