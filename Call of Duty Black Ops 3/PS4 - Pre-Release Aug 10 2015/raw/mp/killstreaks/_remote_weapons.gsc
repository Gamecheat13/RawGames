#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
#using scripts\shared\lui_shared;
#using scripts\mp\killstreaks\_qrdrone;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreakrules;
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

	self AssignRemoteControlTrigger();
}

function RemoveAndAssignNewRemoteControlTrigger( remoteControlTrigger ) // player = self
{
	ArrayRemoveValue( self.activeRemoteControlTriggers, remoteControlTrigger );
	self AssignRemoteControlTrigger( true );
}

function AssignRemoteControlTrigger( force_new_assignment = false ) // player = self
{
	if ( !isdefined( self.activeRemoteControlTriggers ) )
		self.activeRemoteControlTriggers = [];

	ArrayRemoveValue( self.activeRemoteControlTriggers, undefined );

	if ( ( !isdefined( self.remoteControlTrigger ) || force_new_assignment ) && self.activeRemoteControlTriggers.size > 0 )
	{
		self.remoteControlTrigger = self.activeRemoteControlTriggers[ self.activeRemoteControlTriggers.size - 1 ];
	}
	
	if ( isdefined( self.remoteControlTrigger ) )
	{
		self.remoteControlTrigger.origin = self.origin;
		self.remoteControlTrigger LinkTo( self );
	}
}

function RegisterRemoteWeapon( weaponName, hintString, useCallback, endUseCallback, hideCompassOnUse = true )
{
	assert( isdefined( level.remoteWeapons ) );

	level.remoteWeapons[ weaponName ] = SpawnStruct();
	level.remoteWeapons[ weaponName ].hintString = hintString;
	level.remoteWeapons[ weaponName ].useCallback = useCallback;
	level.remoteWeapons[ weaponName ].endUseCallback = endUseCallback;
	level.remoteWeapons[ weaponName ].hideCompassOnUse = hideCompassOnUse;
}

function UseRemoteWeapon( weapon, weaponName, immediate, allowManualDeactivation = true, always_allow_ride = false )
{
	player = self;
	assert( IsPlayer( player ) );
	
	weapon.remoteOwner = player;
	weapon.initTime = GetTime();
	weapon.remoteName = weaponName;
	weapon.remoteWeaponAllowManualDeactivation = allowManualDeactivation;
	
	weapon thread WatchRemoveRemoteControlledWeapon();

	if( !immediate )
	{
		weapon CreateRemoteWeaponTrigger();
	}
	else
	{
		weapon thread WatchOwnerDisconnect();
		weapon UseRemoteControlWeapon( allowManualDeactivation, always_allow_ride );
	}
}

function WatchForHack()
{
	weapon = self;
	weapon endon( "death" );
	
	weapon waittill( "killstreak_hacked", hacker );

	if ( isdefined( weapon.remoteWeaponAllowManualDeactivation ) && weapon.remoteWeaponAllowManualDeactivation == true )
	{
		weapon thread WatchRemoteControlDeactivate();
    }
	weapon.remoteOwner = hacker;
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
	
	if ( isdefined( weapon.useTrigger ) )
	{
		weapon.useTrigger delete();
	}
	
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
	player.activeRemoteControlTriggers[ player.activeRemoteControlTriggers.size ] = weapon.useTrigger;
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
	
	if ( isdefined( weapon.remoteOwner ) )
	{
		weapon.remoteOwner RemoveAndAssignNewRemoteControlTrigger( weapon.useTrigger );
	}
	
	weapon.useTrigger delete();
}

function WatchOwnerDisconnect()
{
	weapon = self;
	weapon endon( "remote_weapon_end" );
	weapon endon( "remote_weapon_shutdown" );
	
	if( isdefined( weapon.useTrigger ) )
		weapon.useTrigger endon( "death" );
	
	weapon.remoteOwner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	
	EndRemoteControlWeaponUse( false );
	
	if( isdefined( weapon ) && isdefined( weapon.useTrigger ) )
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
		weapon.useTrigger TriggerEnable( !( weapon.remoteOwner IsWallRunning() ) );
		wait( 0.1 );
	}
}

function AllowRemoteStart()
{
	player = self;
	if( player useButtonPressed() && !player.throwingGrenade && !player meleeButtonPressed() && !player util::isUsingRemote() && !( isdefined( player.carryObject ) && ( isdefined( player.carryObject.disallowRemoteControl ) && player.carryObject.disallowRemoteControl ) ) )
	{
		return true;
	}
	else 
	{
		return false;
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
		
		if( weapon.remoteOwner IsUsingOffhand() || weapon.remoteOwner IsWallRunning() )
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
		if( weapon.remoteOwner AllowRemoteStart() )
		{
			UseRemoteControlWeapon();
		}
	}
}

function UseRemoteControlWeapon( allowManualDeactivation = true, always_allow_ride = false )
{
	self endon( "death" );

	weapon = self;
	
	assert( isdefined( weapon.remoteOwner ) );
	
	weapon.control_initiated = true;
	weapon.endRemoteControlWeapon = false;
	
	weapon.remoteOwner endon( "disconnect" );
	weapon.remoteOwner endon( "joined_team" );
	
	weapon.remoteOwner DisableOffhandWeapons();
	weapon.remoteOwner DisableWeaponCycling();
	
	weapon.remoteOwner.dofutz = false;

	if( !isdefined( weapon.disableRemoteWeaponSwitch ) )
	{
		remoteWeapon = GetWeapon( "killstreak_remote" );
		weapon.remoteOwner giveWeapon( remoteWeapon );
		weapon.remoteOwner switchToWeapon( remoteWeapon );
		
		if ( always_allow_ride )
		{
			weapon.remoteOwner util::waittill_any( "weapon_change", "death" );
		}
		else
		{
			weapon.remoteOwner waittill( "weapon_change", newWeapon );
		}
	}
	
	if( isdefined( newweapon ) )
	{
		if( newweapon != remoteWeapon )
		{
			weapon.remoteOwner killstreaks::clear_using_remote( true, true );
			return;
		}
	}
	
	weapon.remoteOwner thread killstreaks::watch_for_remove_remote_weapon();
	
	weapon.remoteOwner util::setUsingRemote( weapon.remoteName );
	weapon.remoteOwner util::freeze_player_controls( true );

	result = weapon.remoteOwner killstreaks::init_ride_killstreak( weapon.remoteName, always_allow_ride );

	if( result != "success" )
	{
		if( result != "disconnect" )
		{
			weapon.remoteOwner killstreaks::clear_using_remote();
		}
	}
	else
	{
		weapon.controlled = true;
		weapon.killCamEnt = self;
		weapon notify("remote_start"); // shuts down the AI scripts for this weapon
		
		if ( allowManualDeactivation )
		{
			weapon thread watchRemoteControlDeactivate();
		}
		
		weapon.remoteOwner thread [[level.remoteWeapons[ weapon.remoteName ].useCallback]]( weapon );
			
		if ( level.remoteWeapons[ weapon.remoteName ].hideCompassOnUse )
		{
			weapon.remoteOwner killstreaks::hide_compass();
		}
	}
	
	weapon.remoteOwner util::freeze_player_controls( false );
}

function WatchRemoteControlDeactivate()
{
	self notify("WatchRemoteControlDeactivate_remoteWeapons");
	self endon ("WatchRemoteControlDeactivate_remoteWeapons");
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
				weapon thread EndRemoteControlWeaponUse( true );
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
	
	if( !isdefined( weapon ) || ( isdefined( weapon.endRemoteControlWeapon ) && weapon.endRemoteControlWeapon ) )
		return;
		
	weapon.endRemoteControlWeapon = true;
	
	remote_controlled = ( isdefined( weapon.control_initiated ) && weapon.control_initiated ) || ( isdefined( weapon.controlled ) && weapon.controlled );
	
	if( isdefined( weapon.remoteOwner ) && remote_controlled )
	{		
		
		if( isdefined( weapon.remoteWeaponShutdownDelay ) ) //when changing teams or disconnect, we can skip this
		{
			wait( weapon.remoteWeaponShutdownDelay );
		}
		
		player = weapon.remoteOwner;
		
		if( player.dofutz === true )
		{
			
			player clientfield::set_to_player( "static_postfx", 1 );
			
			wait 1;
			
			if( isdefined( player ) )
			{
				player clientfield::set_to_player( "static_postfx", 0 );
				player.dofutz = false;
			}
		}
		
		if( isdefined( player ) )
		{
			player thread FadeToBlack();	
			player waittill( "fade2black" ); // we the prev call to be blocking, in the same time we dont want to be left with black screen if smth external kills this thread.
			if( remote_controlled )
				player unlink();
			player killstreaks::clear_using_remote( true ); // must come before the end use callback, its notify clears all the AI threads on the remote weapons
			player EnableUsability(); // there are cases where the typical path to enable usability is not called, (because of some endon)
		}
	}
	
	if( isdefined( weapon ))
	{
		self [[ level.remoteWeapons[ weapon.remoteName ].endUseCallback]]( weapon, exitRequestedByOwner );
	}
	
	if( isdefined( weapon ))
	{
		weapon.killCamEnt = weapon;

		if( isdefined( weapon.remoteOwner ) )
		{
			if ( remote_controlled )
			{
				weapon.remoteOwner unlink();
				weapon.remoteOwner killstreaks::reset_killstreak_delay_killcam();
				weapon.remoteOwner util::clientNotify( "nofutz" );
			}

			if( isdefined( level.gameEnded ) && level.gameEnded )
			{
				weapon.remoteOwner util::freeze_player_controls( true );
			}	
		}
	}
	
	if( isdefined( weapon ) )
	{
		weapon.control_initiated = false;
		weapon.controlled = false;
		if( isdefined( weapon.remoteOwner ) )
			weapon.remoteOwner killstreaks::unhide_compass();
		
		if( !exitRequestedByOwner || ( isdefined( weapon.one_remote_use ) && weapon.one_remote_use )  )
			weapon notify( "remote_weapon_end" );	
	}
}

function FadeToBlack()
{
	self endon( "disconnect" );
	// self endon( "death" ); // never end on death as it may never fade back in

	lui::screen_fade_out( 0.1 );
	
	self qrdrone::destroyHud();	
	
	{wait(.05);};
	
	lui::screen_fade_in( .2 );
	
	self notify( "fade2black" );
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

function destroyRemoteHUD()
{	
	self UseServerVisionset( false );
	self SetInfraredVision( false );
	if ( isdefined(self.fullscreen_static) )
	{
		self.fullscreen_static destroy();
	}
	
	if ( isdefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit destroy();
	}
}

function set_static( val )
{
	owner = self.owner;
	if( isdefined( owner ) && owner.usingvehicle && isdefined( owner.viewlockedentity ) && ( owner.viewlockedentity == self ) )
	{
		owner clientfield::set_to_player( "static_postfx", val );
	}
}

function do_static_fx()
{
	self endon( "death" );
	self set_static( 1 );
	wait 2;
	self set_static( 0 );
}