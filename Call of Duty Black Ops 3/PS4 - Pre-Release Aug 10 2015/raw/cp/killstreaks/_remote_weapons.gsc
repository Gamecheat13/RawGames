#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_ai_tank;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_turret_killstreak;

// Manager for all weapons that can be remotely controlled with the tablet


	
#namespace remote_weapons;

function init()
{
	level.remoteWeapons = [];

	level.remoteWeapons[ "killstreak_remote_turret" ] = SpawnStruct();
	level.remoteWeapons[ "killstreak_remote_turret" ].hintString = &"MP_REMOTE_USE_TURRET";
	level.remoteWeapons[ "killstreak_remote_turret" ].useCallback = &turret_killstreak::startTurretRemoteControl;
	level.remoteWeapons[ "killstreak_remote_turret" ].endUseCallback = &turret_killstreak::endRemoteTurret;
	
	level.remoteWeapons[ "killstreak_ai_tank" ] = SpawnStruct();
	level.remoteWeapons[ "killstreak_ai_tank" ].hintString = &"MP_REMOTE_USE_TANK";
	level.remoteWeapons[ "killstreak_ai_tank" ].useCallback = &ai_tank::startTankRemoteControl;
	level.remoteWeapons[ "killstreak_ai_tank" ].endUseCallback = &ai_tank::endTankRemoteControl;
	
	level.remoteExitHint = &"MP_REMOTE_EXIT";

	callback::on_spawned( &on_player_spawned );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_spawned()
{
	self endon("disconnect");

	if ( isdefined( self.remoteControlTrigger ))
	{
		// a remote control trigger exists so reattach it to myself
		self.remoteControlTrigger.origin = self.origin;
		self.remoteControlTrigger LinkTo( self );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function initRemoteWeapon( weapon, weaponName ) // self == player
{
	weapon.initTime = GetTime();
	weapon.remoteName = weaponName;
	
	weapon thread watchFindRemoteWeapon( self );

	if ( isdefined( self.remoteWeapon ))
	{
		if ( !util::IsUsingRemote())
		{
			self notify ( "remove_remote_weapon", true );
		}
	}
	else
	{
		self thread setActiveRemoteControlledWeapon( weapon );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function setActiveRemoteControlledWeapon( weapon ) // self == player
{
	/#
	assert( !isdefined( self.remoteWeapon ), "Trying to activate remote weapon without cleaning up the current one" );
	#/

	if ( isdefined( self.remoteWeapon ))
	{
		return;
	}

	while ( !IsAlive( self ))
	{
		{wait(.05);};
	}

	self notify( "set_active_remote_weapon" );

	self.remoteWeapon = weapon;

	self thread watchRemoveRemoteControlledWeapon( weapon.remoteName );
	self thread watchRemoteControlledWeaponDeath();
	self thread watchRemoteWeaponPings();

	self createRemoteWeaponTrigger( weapon.remoteName  );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchFindRemoteWeapon( player ) // self == remote weapon (tank etc)
{
	self endon( "removed_on_death" ); // can happen before the entity is freed
	self endon( "death" );

	while( true )
	{
		player waittill( "find_remote_weapon" );
		player notify( "remote_weapon_ping", self );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoteWeaponPings() // self == player
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

		if ( isdefined( weapon ))
		{
			self.remoteWeaponQueue[ self.remoteWeaponQueue.size ] = weapon;
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function collectWeaponPings() // self == player
{
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	self waittill( "remote_weapon_ping" );

	// watchRemoteWeaponPings() will collect all remote weapons this frame
	wait( 0.1 );

	while ( !IsAlive( self ))
	{
		{wait(.05);};
	}

	if ( isdefined( self ))
	{
		/#
		assert( isdefined( self.remoteWeaponQueue ));
		#/

		best_weapon = undefined;
		foreach ( weapon in self.remoteWeaponQueue )
		{
			if ( isdefined( weapon ) && IsAlive( weapon ))
			{
				if ( !isdefined( best_weapon ) || ( best_weapon.initTime < weapon.initTime ))
				{
					best_weapon = weapon;
				}
			}
		}

		if ( isdefined( best_weapon ))
		{
			self thread setActiveRemoteControlledWeapon( best_weapon );
		}
	}
}
	

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoteControlledWeaponDeath() // self == player
{
	self endon( "remove_remote_weapon" );
	/# 
	assert( isdefined( self.remoteWeapon ));
	#/

	self.remoteWeapon waittill( "death" );

	if ( isdefined( self ))
	{
		self notify( "remove_remote_weapon", true );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoveRemoteControlledWeapon( weaponName ) // self == player
{
	// this should be the only place the player references to remoteWeapon/trigger should be cleaned up
	self endon( "disconnect" );

	self waittill( "remove_remote_weapon", tryToReplace );

	self removeRemoteControlledWeapon( weaponName );
	
	while ( isdefined( self.remoteWeapon ) )
	{
		{wait(.05);}; // Wait until any death animations and any other waits are finished
	}
	
	if ( tryToReplace == true )
	{
		self notify( "find_remote_weapon" );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function removeRemoteControlledWeapon( weaponName ) // self == player
{
	if ( self util::isUsingRemote() )
	{
		remoteWeaponName = self util::getRemoteName();
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
function createRemoteWeaponTrigger( weaponName ) // self == player
{
	trigger = spawn( "trigger_radius_use", self.origin, 32, 32 );
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
	self thread removeRemoteTriggerOnDisconnect( trigger );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function removeRemoteTriggerOnDisconnect( trigger ) // self == player
{
	self endon ( "remove_remote_weapon" );
	trigger endon ( "death" );
	
	self waittill( "disconnect" );
	
	trigger delete();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoteTriggerUse( weaponName ) // self == player
{
	self endon ( "remove_remote_weapon" );
	self endon ( "disconnect" );

	if ( self util::is_bot() )
	{
		return;
	}

	while( true )
	{
		self.remoteControlTrigger waittill( "trigger", player );
		{
			if ( self IsUsingOffhand() )
			{
				continue;
			}

			if ( isdefined( self.remoteWeapon ) && isdefined( self.remoteWeapon.hackertrigger ) && isdefined ( self.remoteWeapon.hackertrigger.progressbar ) )
			{	if ( weaponName == "killstreak_remote_turret" )
				{
					self iPrintLnBold( &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
				}
				continue;
			}
			if ( self useButtonPressed() && !self.throwingGrenade && !self meleeButtonPressed() && !self util::isUsingRemote() )
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
function useRemoteControlWeapon( weaponName, allowExit ) // self == player
{
	self disableOffhandWeapons();

	weapon = GetWeapon( weaponName );
	self giveWeapon( weapon );
	self switchToWeapon( weapon );

	if ( !isdefined( allowExit ) )
		allowExit = true;
		
	self thread killstreaks::watch_for_remove_remote_weapon();
	self waittill( "weapon_change", newWeapon );
	self notify( "endWatchForRemoveRemoteWeapon" );

	self util::setUsingRemote( weaponName );

	if (!self IsOnGround())
	{
		self killstreaks::clear_using_remote();
		return;
	}
	
	result = self killstreaks::init_ride_killstreak( weaponName );

	if ( allowExit && result != "success" )
	{
		if ( result != "disconnect" )
		{
			self killstreaks::clear_using_remote();
		}
	}
	else if (allowExit && !self IsOnGround())
	{
		self killstreaks::clear_using_remote();
		return;
	}
	else
	{
		self.remoteWeapon.controlled = true;
		self.remoteWeapon.killCamEnt = self;
		self.remoteWeapon notify("remote_start"); // shuts down the AI scripts for this weapon

		if ( !isdefined( allowExit ) || allowExit )
			self thread watchRemoteControlDeactivate( weaponName );
	
		self thread [[level.remoteWeapons[ weaponName ].useCallback]]( self.remoteWeapon );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function createRemoteControlActionPromptHUD() // self == player
{
	if ( !isdefined(self.hud_prompt_exit))
	{
		self.hud_prompt_exit = newclienthudelem( self );
	}

	self.hud_prompt_exit.alignX = "left";
	self.hud_prompt_exit.alignY = "bottom";
	self.hud_prompt_exit.horzAlign = "user_left";
	self.hud_prompt_exit.vertAlign = "user_bottom";
	self.hud_prompt_exit.font = "small";
	self.hud_prompt_exit.fontScale = 1.25;
	self.hud_prompt_exit.hidewheninmenu = true;
	self.hud_prompt_exit.archived = false;
	self.hud_prompt_exit.x = 25;
	self.hud_prompt_exit.y = -10;
	self.hud_prompt_exit SetText(level.remoteExitHint);
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function destroyRemoteControlActionPromptHUD() // self == player
{
	if ( isdefined( self )  && isdefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit destroy();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRemoteControlDeactivate( weaponName ) // self == player
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
			if ( timeUsed > 0.25 )
			{
				self thread baseEndRemoteControlWeaponUse( weaponName, false );
				return;
			}
			{wait(.05);};
		}
		{wait(.05);};
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function endRemoteControlWeaponUse( weaponName ) // self == player
{
	if ( isdefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit SetText("");
	}

	self [[level.remoteWeapons[ weaponName ].endUseCallback]]( self.remoteWeapon );
}

function fadeOutToBlack( isDead )
{
	self endon("disconnect");
	self endon( "early_death" );
	
	if ( isDead )
	{
		self SendKillstreakDamageEvent( 600 );
		wait( 0.75 );
		self thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
	}
	else
	{
		self thread hud::fade_to_black_for_x_sec( 0, 0.2, 0, 0.3 );
	}
}

/*earlyDeathWatcher()
{
	self endon( "unlink_delay_complete" );
	while ( true )
	{
		if ( !isdefined( self.remoteWeapon ) )
		{
			self thread hud::fade_to_black_for_x_sec( 0, 0.2, 0, 0.3 );
			self notify( "early_death" );
			return;
		}
		WAIT_SERVER_FRAME;
	}
}

function delayUnlink()
{
	self endon( "early_death" );
	self thread earlyDeathWatcher();
	wait 1;
	self notify( "unlink_delay_complete" );
}*/

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function baseEndRemoteControlWeaponUse( weaponName, isDead ) // self == player
{
	if ( isdefined( self ) )
	{
		if ( isDead && isdefined( self.remoteWeapon ) && !isdefined( self.remoteWeapon.skipFutz ))
		{
			self thread fadeOutToBlack( true );
			wait 1; // This is to prevent unlinking until the fade to black is complete
			//self delayUnlink(); // I think this would be a better alternative to this explicit wait, but I know of no code-path to test it right now
		}
		else
		{
			self thread fadeOutToBlack( false );
		}

		self killstreaks::clear_using_remote(); // must come before the end use callback, its notify clears all the AI threads on the remote weapons
		
		self takeweapon( GetWeapon( weaponName ) );
	}
	
	if ( isdefined( self.remoteWeapon ))
	{
		if ( isDead )
		{
			self.remoteWeapon.wasControlledNowDead = self.remoteWeapon.controlled;
		}
		self.remoteWeapon.controlled = false;

		self [[level.remoteWeapons[ weaponName ].endUseCallback]]( self.remoteWeapon, isDead );

		self.remoteWeapon.killCamEnt = self.remoteWeapon;

		self unlink();
		self.killstreak_waitamount = undefined;
		self destroyRemoteHUD();
		self util::clientNotify( "nofutz" );
		
		if ( isdefined(level.gameEnded) && level.gameEnded )
		{
			self util::freeze_player_controls( true );
		}
	}

	if ( isdefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit SetText("");
	}

	self notify( "remove_remote_weapon", true );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function destroyRemoteHUD()
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
	if ( isdefined( self.hud_prompt_exit ))
	{
		self.hud_prompt_exit destroy();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
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
