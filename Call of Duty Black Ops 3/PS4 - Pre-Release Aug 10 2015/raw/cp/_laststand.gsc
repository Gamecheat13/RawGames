#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\lui_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#using scripts\cp\_util;
#using scripts\cp\_bb;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_healthoverlay;

// Fill amount of the getup bar the first time it is used	

// Percent of the bar filled for auto fill logic	

// Time to bleed-out when there's nobody to rescue you.

	


	



	

	
#namespace laststand;

function autoexec __init__sytem__() {     system::register("laststand",&__init__,undefined,undefined);    }

#precache( "string", "COOP_BUTTON_TO_REVIVE_PLAYER" );
#precache( "string", "COOP_PLAYER_NEEDS_TO_BE_REVIVED" );
#precache( "string", "COOP_PLAYER_IS_REVIVING_YOU" );	
#precache( "string", "COOP_REVIVING" );
#precache( "string", "COOP_REVIVING_SOLO" );
#precache( "string", "COOP_REVIVING_SOLO_LAST_LIFE" );

function __init__()
{
	if (level.script=="frontend")
	{
		return ;
	}
	
	//register clientfield for each person
	level.laststand_update_clientfields = [];
	for( i = 0; i < 4; i++ )
	{
		level.laststand_update_clientfields[i] = "laststand_update" + i;
		clientfield::register( "world", level.laststand_update_clientfields[i], 1, 5, "counter" );
	}

	if( !isdefined( level.playerlaststand_func ) )
	{
		level.playerlaststand_func = &player_laststand;
	}

	level.weaponReviveTool = GetWeapon( "syrette" );

	if( !IsDefined( level.laststandpistol ) )
	{
		level.laststandpistol = GetWeapon( "noweapon" );
	}

	level thread revive_hud_think();

	level.primaryProgressBarX = 0;
	level.primaryProgressBarY = 110;
	level.primaryProgressBarHeight = 4;
	level.primaryProgressBarWidth = 120;
	level.primaryProgressBarY_ss = 280;

	if( GetDvarString( "revive_trigger_radius" ) == "" )
	{
		SetDvar( "revive_trigger_radius", "100" ); 
	}

	level.lastStandGetupAllowed = false;
	
	VisionSetLastStand( "zombie_last_stand" );	// Set the config string
}

function player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	//stat tracking
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && attacker != self )
	{
		attacker.kills++;

		if (isdefined(weapon))
		{
			dmgweapon = weapon;
			attacker AddWeaponStat(dmgweapon, "kills", 1);
		}
	}
	
	self increment_downed_stat();	
}

function increment_downed_stat()
{
	self.downs++;
	self AddPlayerStat( "INCAPS", 1 );
}

function private force_last_stand()
{
	/#
	if ( GetDvarString( "scr_last_stand" ) == "force_last_stand" )
	{
		return true;
	}
	#/

	return false;
}

function PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride )
{	
	if ( ( isdefined( self.disable_last_stand ) && self.disable_last_stand ) )
	{
		return;
	}
	
	self notify("entering_last_stand");

	// check to see if we are in a game module that wants to do something with PvP damage
	if( isDefined( level._game_module_player_laststand_callback ) )
	{
		self [[ level._game_module_player_laststand_callback ]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	}

	if( self player_is_in_laststand() )
	{
		return;
	}

	if( level.players.size == 1 && self.lives == 0 && !force_last_stand() )
	{
		// No last stand in solo if no lives are left
		return;
	}
	
	self.lastStandParams = spawnstruct();
	self.lastStandKillcam = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandKillcam.eInflictorNum = -1;
	if( IsDefined( eInflictor ) )
	{
		self.lastStandKillcam.eInflictorNum = eInflictor getEntityNumber();
	}
	self.lastStandKillcam.attackerNum = -1;
	if( IsDefined( attacker ) )
	{
		self.lastStandKillcam.attackerNum = eInflictor getEntityNumber();
	}
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = weapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();	
	
	self thread player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	bb::logPlayerMapNotification("enter_last_stand", self);
	
	if( IsDefined( level.playerlaststand_func ) )
	{
		[[level.playerlaststand_func]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	}
	
	self.health = 1;
	self.laststand = true;
	self.ignoreme = true;
	self EnableInvulnerability();
	self.meleeAttackers = undefined;
	
	callback::callback( #"on_player_laststand" );
	
	//self thread call_overloaded_func( "maps\_arcademode", "arcademode_player_laststand" );

	// revive trigger
	if ( !( isdefined( self.no_revive_trigger ) && self.no_revive_trigger ) )
	{
		self revive_trigger_spawn();
	}
	else
	{
		self UndoLastStand(); // hide the overhead icon if there's no trigger
	}
	
	self thread laststand_watch_weapon_switch();

	// laststand weapons
	self laststand_disable_player_weapons();
	self laststand_give_pistol();

	if( ( isdefined( level.playerSuicideAllowed ) && level.playerSuicideAllowed ) && GetPlayers().size > 1 )
	{
		if (!IsDefined(level.canPlayerSuicide) || self [[level.canPlayerSuicide]]() )
		{
			self thread suicide_trigger_spawn();
		}
	}
	
	// Reset Disabled Power Perks Array On Downed State
	//-------------------------------------------------
	if ( IsDefined( self.disabled_perks ) )
	{
		self.disabled_perks = [];
	}

	if( level.lastStandGetupAllowed && delayOverride != -1)
	{
		self thread laststand_getup();
	}
	else
	{
		// bleed out timer
		bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
		
		if(delayOverride != 0)
		{
			if(delayOverride == -1)
				delayOverride = 0;
			
			bleedout_time = delayOverride;
		}
		
//		foreach( e_player in level.players )
//		{
//			entityNumber = self GetEntityNumber();
//			e_player clientfield::increment_to_player( "laststand_update" + ( self GetEntityNumber() ), 30 );
//		}
		
		level clientfield::increment( "laststand_update" + ( self GetEntityNumber() ), 30 );
		
		self thread laststand_bleedout( bleedout_time );
	}

	demo::bookmark( "player_downed", gettime(), self );
	
	self notify( "player_downed" );
	self thread refire_player_downed();
	
	//clean up revive trigger if he disconnects while in laststand
	self thread cleanup_laststand_on_disconnect();
	
	self thread auto_revive_on_notify();
	
	self thread clean_up_laststand_widget();
}

function clean_up_laststand_widget()
{
	self endon ( "player_revived");
	self endon ( "disconnect");
	
	self waittill( "death" );
	self UndoLastStand();
}

function refire_player_downed()
{
	self endon("player_revived");
	self endon("death");
	self endon("disconnect");
	wait(1.0);
	//if(self.num_perks)
	{
		self notify("player_downed");
	}
}

function wait_for_weapon_pullout()
{
	self endon( "weapon_change" );
	
	while ( !self AttackButtonPressed() )
	{
		wait 0.05;
	}
}

function laststand_watch_weapon_switch()
{
	self endon( "bled_out" );
	self endon( "disconnect" );
	self endon( "player_revived" );
	
	// Wait for the laststand weapon to come out.
	self waittill( "weapon_change" );
	
	self wait_for_weapon_pullout();
	
	self laststand_enable_player_weapons( false );
	self.ignoreme = false;
	self DisableInvulnerability();
}

// self = a player
function laststand_disable_player_weapons()
{
	weaponInventory = self GetWeaponsList( true );
	self.lastActiveWeapon = self GetCurrentWeapon();
	if ( self IsThrowingGrenade() ) // && _zm_utility::is_offhand_weapon( self.lastActiveWeapon ))
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self.lastActiveWeapon = primaryWeapons[0];
			self SwitchToWeaponImmediate( self.lastActiveWeapon );
		}
		
	}
	self SetLastStandPrevWeap( self.lastActiveWeapon );
	self.laststandpistol = undefined;

	if ( !IsDefined( self.laststandpistol ) )
	{
		self.laststandpistol = level.laststandpistol;
	}
	
	if( IsDefined( self.laststandpistoloverride ) )
	{
		self.laststandpistol = self.laststandpistoloverride;	
	}
	
	if( IsDefined( level.laststandweaponoverride ) )
	{
		[[ level.laststandweaponoverride ]]();
	}

	self notify("weapons_taken_for_last_stand");
}


// self = a player
function laststand_enable_player_weapons( b_allow_grenades = true )
{
	if ( IsDefined( self.laststandpistol ) )
	{
		self TakeWeapon( self.laststandpistol );
	}
	
	self SetLowReady( false );
	self EnableWeaponCycling();
	
	if ( b_allow_grenades )
	{
		self EnableOffhandWeapons();
	}

	// if we can't figure out what the last active weapon was, try to switch a primary weapon
	//CHRIS_P: - don't try to give the player back the mortar_round weapon ( this is if the player killed himself with a mortar round)
	if( IsDefined(self.lastActiveWeapon) && (self.lastActiveWeapon != level.weaponNone) && self HasWeapon( self.lastActiveWeapon ) )
	{
		self SwitchToWeapon( self.lastActiveWeapon );
	}
	else
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
	
	if( IsDefined( level.laststandweaponreturnedoverride ) )
	{
		[[ level.laststandweaponreturnedoverride ]]();
	}
	
	
}

function laststand_clean_up_on_interrupt( playerBeingRevived, reviverGun )
{
	self endon( "do_revive_ended_normally" );

	reviveTrigger = playerBeingRevived.revivetrigger;

	playerBeingRevived util::waittill_any( "disconnect", "game_ended", "death" );	
	
	if( isdefined( reviveTrigger ) )
	{
		reviveTrigger delete();
	}
	self cleanup_suicide_hud();
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	self revive_give_back_weapons( reviverGun );
}

function laststand_clean_up_reviving_any( playerBeingRevived )
{
	self endon( "do_revive_ended_normally" );

	playerBeingRevived util::waittill_any( "disconnect", "zombified", "stop_revive_trigger" );

	self.is_reviving_any--;
	if ( 0 > self.is_reviving_any )
	{
		self.is_reviving_any = 0;
	}
}

function laststand_give_pistol()
{
	assert( IsDefined( self.laststandpistol ) );
	assert( self.laststandpistol != level.weaponNone );

	self GiveWeapon( self.laststandpistol );
	self GiveMaxAmmo( self.laststandpistol );
	self SwitchToWeapon( self.laststandpistol );
	
	if( IsDefined( level.laststandweapongivenoverride ) )
	{
		[[ level.laststandweapongivenoverride ]]();
	}
}

function Laststand_Bleedout_Decrement()
{
	self.bleedout_time -= 1;

	wait( 1 );
	
	// if they are currently being revived then do not count down the time past the first second
	// applying the 1 second first before stalling on the revive should help start-stop-start bugs and exploits
	while( IsDefined( self.revivetrigger ) && IsDefined( self.revivetrigger.beingRevived ) && self.revivetrigger.beingRevived == 1 )
	{
		wait( 0.1 );
	}	
}

// If all players are in last stand or dead, bleed them out immediately.
//
function private check_early_bleedout()
{
	// If you're out of lives and there's nobody left to revive you, everyone will immediately bleed out.
	players = GetPlayers();
	if ( players.size == 1  )
	{
		if ( self.lives == 0 )
		{
			self.bleedout_time = 3.0;
		}
	}
	else
	{
		b_any_standing = false;
		foreach( player in players )
		{
			if ( IsAlive( player ) && !( isdefined( player.laststand ) && player.laststand ) )
			{
				b_any_standing = true;
			}
		}
		
		if ( !b_any_standing )
		{
			foreach( player in players )
			{
				player.bleedout_time = 3.0;
			}
		}
	}
}

// Transfers damage to the laststand timer.
//
function Laststand_Bleedout_Damage()
{
	self endon( "player_revived" );
	self endon( "player_suicide" );
	self endon( "disconnect" );
	self endon( "bled_out" );
	
	// Don't transfer damage in a solo game.
	//
	if ( level.players.size == 1 )
	{
		return;
	}
	
	while ( true )
	{
		self waittill( "laststand_damage", amt );
		
		// If they shouldn't be targeted, don't accept the damage.
		if ( !self.ignoreme )
		{
			self.bleedout_time -= 0.02 * amt;
		}
	}
}

// Transfers movement to the laststand timer.
//
function Laststand_Bleedout_Movement()
{
	self endon( "player_revived" );
	self endon( "player_suicide" );
	self endon( "disconnect" );
	self endon( "bled_out" );
	
	// Don't penalize movement in a solo game.
	//
	if ( level.players.size == 1 )
	{
		return;
	}

	v_pos = self.origin;
	
	const move_timer = 0.5;
	while ( true )
	{
		wait move_timer;
		if ( v_pos != self.origin )
		{
			self.bleedout_time -= 1.0 * move_timer;
		}
		v_pos = self.origin;
	}
}

function Laststand_Bleedout( delay )
{
	self endon ("player_revived");
	self endon ("player_suicide");
	self endon ("disconnect");
	self endon ( "death" );

	//self PlayLoopSound("heart_beat",delay);	// happens on client now DSL

	// Notify client that we're in last stand.
	
	//util::setClientSysState("lsm", "1", self);
	self clientfield::set_to_player( "sndHealth", 2 );

	self.last_bleedout_time = delay;
	self.bleedout_time = delay;
	
	if(delay != 0 && !force_last_stand())
	{
		check_early_bleedout();
	}
	
	// Transfer incoming damage to the timer.
	self thread Laststand_Bleedout_Damage();
	
	// Movement contributes to bleedout timer.
	self thread Laststand_Bleedout_Movement();

	do
	{
		Laststand_Bleedout_Decrement();
		
//		foreach( e_player in level.players )
//		{
//			if( self.bleedout_time < 0 )
//			{
//				self.bleedout_time = 0;
//			}
////			e_player clientfield::increment_to_player( "laststand_update" + ( self GetEntityNumber() ), self.bleedout_time + 1 );
//		}
//		
		level clientfield::increment( "laststand_update" + ( self GetEntityNumber() ), self.bleedout_time + 1 );
	} while ( self.bleedout_time > 0 );
	self notify("bled_out");
	bb::logplayermapnotification("player_bled_out", self);
	util::wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

	self bleed_out();	
}

function ensureLastStandParamsValidity()
{
	// attacker may have become undefined if the player that killed me has disconnected
	if ( !isDefined( self.lastStandParams.attacker ) )
		self.lastStandParams.attacker = self;
}

function bleed_out()
{
	if(GetDVarInt("enable_new_death_cam", 1))
	{
		bleed_out_fade_time = GetDVarFloat("bleed_out_screen_fade_speed", 1.5);
		
		self playlocalsound( "chr_health_laststand_bleedout" );
		self lui::screen_fade( bleed_out_fade_time, 1, 0, "black", false );
		
		wait (bleed_out_fade_time + 0.2);
	}
	
	self cleanup_suicide_hud();
	if( isdefined( self.reviveTrigger ) )
	{
		self.reviveTrigger delete();
	}
	self.reviveTrigger = undefined;
	
//	util::setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self clientfield::set_to_player( "sndHealth", 0 );
//	foreach( e_player in level.players )
//	{
//		e_player clientfield::increment_to_player( "laststand_update" + ( self GetEntityNumber() ), 1 );
//	}
	
	level clientfield::increment( "laststand_update" + ( self GetEntityNumber() ), 1 );

	demo::bookmark( "player_bledout", gettime(), self, undefined, 1 );

	level notify("bleed_out", self.characterindex);
	self notify( "player_bleedout" );

	if (IsDefined(level.onPlayerBleedout))
	{
		self [[level.onPlayerBleedout]]();
	}
	
	//clear the revive icon
	self UndoLastStand();
	self.ignoreme = false;

	//self thread [[level.spawnMessage]]();
	
	self.useLastStandParams = true;
	self ensureLastStandParamsValidity();
	self suicide();
	
	self thread respawn_player_after_time( 15.0 );
}

function respawn_player_after_time( n_time_seconds )
{
	self endon( "disconnect" );
	
	// No love for solo artists.
	players = GetPlayers();
	if ( players.size == 1 )
	{
		return;
	}
	
	self waittill( "spawned_spectator" );
	
	self endon( "spawned" );
	level endon( "objective_changed" );
	
	wait n_time_seconds;
	
	if ( self.sessionstate == "spectator" )
	{
		self thread globallogic_spawn::waitAndSpawnClient();
	}
}

function suicide_trigger_spawn()
{
	self.suicidePrompt = newclientHudElem( self );
	
	self.suicidePrompt.alignX = "center";
	self.suicidePrompt.alignY = "middle";
	self.suicidePrompt.horzAlign = "center";
	self.suicidePrompt.vertAlign = "bottom";
	self.suicidePrompt.y = -170;
	if ( self IsSplitScreen() )
	{
		self.suicidePrompt.y = -132;
	}
	self.suicidePrompt.foreground = true;
	self.suicidePrompt.font = "default";
	self.suicidePrompt.fontScale = 1.5;
	self.suicidePrompt.alpha = 1;
	self.suicidePrompt.color = ( 1.0, 1.0, 1.0 );
	self.suicidePrompt.hidewheninmenu = true;

	self thread suicide_trigger_think();
}

// logic for the revive trigger
function suicide_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "stop_revive_trigger" );
	self endon ( "player_revived");
	self endon ( "bled_out");
	self endon ("fake_death");
	level endon("game_ended");
	level endon("stop_suicide_trigger");
	
	//in case the game ends while this is running
	self thread clean_up_suicide_hud_on_end_game();
	
	//in case user is holding UseButton while this is running
	self thread clean_up_suicide_hud_on_bled_out();
	
	// If player was holding use while going into last stand, wait for them to release it
	while ( self UseButtonPressed() )
	{
		wait ( 1 );
	}
	
	if(!isDefined(self.suicidePrompt))
	{
		return;
	}
	
	while ( 1 )
	{
		wait ( 0.1 );
		
		if(!isDefined(self.suicidePrompt))
		{
			continue;
		}
					
		self.suicidePrompt setText( &"COOP_BUTTON_TO_SUICIDE" );
		
		if ( !self is_suiciding() )
		{
			continue;
		}

		self.pre_suicide_weapon = self GetCurrentWeapon();
		self GiveWeapon( level.suicide_weapon );
		self SwitchToWeapon( level.suicide_weapon );
		duration = self doCowardsWayAnims();

		suicide_success = suicide_do_suicide(duration);
		self.laststand = undefined;
		self TakeWeapon( level.suicide_weapon );

		if ( suicide_success )
		{
			self notify("player_suicide");

			util::wait_network_frame(); //to guarantee the notify gets sent and processed before the rest of this script continues to turn the guy into a spectator

			//Stat Tracking
			//self _zm_stats::increment_client_stat( "suicides" );
			
			self bleed_out();

			return;
		}

		self SwitchToWeapon( self.pre_suicide_weapon );
		self.pre_suicide_weapon = undefined;
	}
}

function suicide_do_suicide(duration)
{
	level endon("game_ended");
	level endon("stop_suicide_trigger");
	
	suicideTime = duration; //1.5;

	timer = 0;

	suicided = false;
	
	self.suicidePrompt setText( "" );
	
	if( !isdefined(self.suicideProgressBar) )
	{
		self.suicideProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.suicideTextHud) )
	{
		self.suicideTextHud = newclientHudElem( self );
	}
	
	self.suicideProgressBar hud::updateBar( 0.01, 1 / suicideTime );

	self.suicideTextHud.alignX = "center";
	self.suicideTextHud.alignY = "middle";
	self.suicideTextHud.horzAlign = "center";
	self.suicideTextHud.vertAlign = "bottom";
	self.suicideTextHud.y = -173;
	if ( self IsSplitScreen() )
	{
		self.suicideTextHud.y = -147;
	}
	self.suicideTextHud.foreground = true;
	self.suicideTextHud.font = "default";
	self.suicideTextHud.fontScale = 1.8;
	self.suicideTextHud.alpha = 1;
	self.suicideTextHud.color = ( 1.0, 1.0, 1.0 );
	self.suicideTextHud.hidewheninmenu = true;
	self.suicideTextHud setText( &"COOP_SUICIDING" );
	bb::logplayermapnotification("last_stand_suicide", self);
	while( self is_suiciding() )
	{
		{wait(.05);};
		timer += 0.05;

		if( timer >= suicideTime)
		{
			suicided = true;
			break;
		}
	}
	
	if( isdefined( self.suicideProgressBar ) )
	{
		self.suicideProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.suicideTextHud ) )
	{
		self.suicideTextHud destroy();
	}
	
	if ( isDefined(self.suicidePrompt) )
	{
		self.suicidePrompt setText( &"COOP_BUTTON_TO_SUICIDE" );
	}
	return suicided;
}

function can_suicide()
{
	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( !self player_is_in_laststand() )
	{
		return false;
	}
		
	if ( !isDefined( self.suicidePrompt ) )
	{
		return false;
	}

	if ( ( isdefined( level.intermission ) && level.intermission ) )
	{
		return false;
	}
		
	return true;
}

function is_suiciding( revivee )
{	
	return ( self UseButtonPressed() && can_suicide() );
}



// spawns the trigger used for the player to get revived
function revive_trigger_spawn()
{
	if ( IsDefined( level.revive_trigger_spawn_override_link ) )
	{
		[[ level.revive_trigger_spawn_override_link ]]( self );
	}
	else
	{
		radius = GetDvarint( "revive_trigger_radius" );
		self.revivetrigger = spawn( "trigger_radius", (0.0,0.0,0.0), 0, radius, radius );
		self.revivetrigger setHintString( "" ); // only show the hint string if the triggerer is facing me
		self.revivetrigger setCursorHint( "HINT_NOICON" );
		self.revivetrigger SetMovingPlatformEnabled( true );
		self.revivetrigger EnableLinkTo();
		self.revivetrigger.origin = self.origin;
		self.revivetrigger LinkTo( self ); 

		self.revivetrigger.beingRevived = 0;
		self.revivetrigger.createtime = gettime();
	}

	self thread revive_trigger_think();
	//self.revivetrigger thread revive_debug();
}


// logic for the revive trigger
function revive_trigger_think()
{
	self endon ( "disconnect" );
	self endon ( "stop_revive_trigger" );
	level endon("game_ended");
	self endon( "death" );
	
	while ( 1 )
	{
		wait ( 0.1 );
	
		if( !isdefined(self.revivetrigger) )
		{
			self notify ( "stop_revive_trigger" );
		}
		self.revivetrigger setHintString( "" );

		players = GetPlayers();

		for ( i = 0; i < players.size; i++ )
		{
			//PI CHANGES - revive should work in deep water for nazi_zombie_sumpf
			d = 0;
			d = self depthinwater();
				
			if ( players[i] can_revive( self ) || d > 20)
			//END PI CHANGES
			{
				// TODO: This will turn on the trigger hint for every player within
				// the radius once one of them faces the revivee, even if the others
				// are facing away. Either we have to display the hints manually here
				// (making sure to prioritize against any other hints from nearby objects),
				// or we need a new combined radius+lookat trigger type.						
				self.revivetrigger setReviveHintString( &"COOP_BUTTON_TO_REVIVE_PLAYER", self.team );
				break;			
			}
		}

		for ( i = 0; i < players.size; i++ )
		{
			reviver = players[i];
			
			if ( self == reviver || !reviver is_reviving( self ) )
			{
				continue;
			}
			
			// give the syrette
			gun = reviver GetCurrentWeapon();
			assert( IsDefined( gun ) );
			//assert( gun != level.weaponNone );
			if ( gun == level.weaponReviveTool )
			{
				//already reviving somebody
				continue;
			}

			reviver GiveWeapon( level.weaponReviveTool );
			reviver SwitchToWeapon( level.weaponReviveTool );
			reviver SetWeaponAmmoStock( level.weaponReviveTool, 1 );

			reviver DisableWeaponFire();
			reviver DisableWeaponCycling();
			reviver DisableUsability();
			reviver DisableOffhandWeapons();

			//CODER_MOD: TOMMY K
			revive_success = reviver revive_do_revive( self, gun );
			
			reviver revive_give_back_weapons( gun );

			//PI CHANGE: player couldn't jump - allow this again now that they are revived
			if ( IsPlayer( self ) )
			{
				self AllowJump(true);
			}
			//END PI CHANGE
			
			self.laststand = undefined;

			if( revive_success )
			{
				self thread revive_success( reviver );
				self cleanup_suicide_hud();
				return;
			}
		}
	}
}

function revive_give_back_weapons( gun )
{
	// take the syrette
	self TakeWeapon( level.weaponReviveTool );

	self EnableWeaponFire();
	self EnableWeaponCycling();
	self EnableUsability();
	self EnableOffhandWeapons();
	
	// Don't switch to their old primary weapon if they got put into last stand while trying to revive a teammate
	if ( self player_is_in_laststand() )
	{
		return;
	}

	if ( self HasWeapon( gun ) )
	{
		self SwitchToWeapon( gun );
	}
	else
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
}


function can_revive( revivee )
{
	if ( !isDefined( revivee.revivetrigger ) )
	{
		return false;
	}

	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( self player_is_in_laststand() )
	{
		return false;
	}

	if( self.team != revivee.team ) 
	{
		return false;
	}

	if ( ( isdefined( level.can_revive_use_depthinwater_test ) && level.can_revive_use_depthinwater_test ) && revivee depthinwater() > 10 )
	{
		return true;
	}

	if ( isDefined( level.can_revive ) && ![[ level.can_revive ]]( revivee ) )
	{
		return false;
	}

	if ( isDefined( level.can_revive_game_module ) && ![[ level.can_revive_game_module ]]( revivee ) )
	{
		return false;
	}

	ignore_sight_checks = false;
	ignore_touch_checks = false;
	if ( IsDefined( level.revive_trigger_should_ignore_sight_checks ) )
	{
		ignore_sight_checks = [[ level.revive_trigger_should_ignore_sight_checks ]]( self );

		if( ignore_sight_checks && isdefined(revivee.revivetrigger.beingRevived) && (revivee.revivetrigger.beingRevived==1) )
		{
			ignore_touch_checks = true;
		}
	}

	if( !ignore_touch_checks )
	{
		if ( !self IsTouching( revivee.revivetrigger ) )
		{
			return false;
		}
	}

	if( !ignore_sight_checks )
	{
		if ( !self is_facing( revivee, 0.8 ) )
		{
			return false;
		}

		if ( !SightTracePassed( self.origin + ( 0, 0, 50 ), revivee.origin + ( 0, 0, 30 ), false, undefined ) )				
		{
			return false;
		}

		//chrisp - fix issue where guys can sometimes revive thru a wall	
		if ( !bullettracepassed( self.origin + (0, 0, 50), revivee.origin + (0, 0, 30), false, undefined ) )
		{
			return false;
		}	
	}

	//iprintlnbold("REVIVE IS GOOD");
	return true;
}

function is_reviving( revivee )
{	
	return ( self UseButtonPressed() && can_revive( revivee ) );
}

function is_reviving_any()
{	
	return ( isdefined( self.is_reviving_any ) && self.is_reviving_any );
}

// self = reviver
function revive_do_revive( playerBeingRevived, reviverGun )
{
	assert( self is_reviving( playerBeingRevived ) );
	// reviveTime used to be set from a Dvar, but this can no longer be tunable:
	// it has to match the length of the third-person revive animations for
	// co-op gameplay to run smoothly.
	reviveTime = GetDvarFloat( "g_reviveTime" );

	if ( self HasPerk( "specialty_quickrevive" ) )
	{
		reviveTime = reviveTime / 2;
	}

	timer = 0;
	revived = false;
	
	//CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger.beingRevived = 1;
	playerBeingRevived.revive_hud setText( &"COOP_PLAYER_IS_REVIVING_YOU", self );
	playerBeingRevived revive_hud_show_n_fade( 3.0 );
	
	playerBeingRevived.revivetrigger setHintString( "" );
	
	if ( IsPlayer( playerBeingRevived ) )
	{
		playerBeingRevived startrevive( self );
	}

	if( false && !isdefined(self.reviveProgressBar) )
	{
		self.reviveProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.reviveTextHud) )
	{
		self.reviveTextHud = newclientHudElem( self );
	}
	
	// Play DNI Arm Revive Effects
	self cybercom::cyberCom_armPulse(2);
	
	self thread laststand_clean_up_on_interrupt( playerBeingRevived, reviverGun );

	if ( !IsDefined( self.is_reviving_any ) )
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any( playerBeingRevived );
	
	if ( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::updateBar( 0.01, 1 / reviveTime );
	}

	self.reviveTextHud.alignX = "center";
	self.reviveTextHud.alignY = "middle";
	self.reviveTextHud.horzAlign = "center";
	self.reviveTextHud.vertAlign = "bottom";
	self.reviveTextHud.y = -113;
	if ( self IsSplitScreen() )
	{
		self.reviveTextHud.y = -347;
	}
	self.reviveTextHud.foreground = true;
	self.reviveTextHud.font = "default";
	self.reviveTextHud.fontScale = 1.8;
	self.reviveTextHud.alpha = 1;
	self.reviveTextHud.color = ( 1.0, 1.0, 1.0 );
	self.reviveTextHud.hidewheninmenu = true;
	self.reviveTextHud setText( &"COOP_REVIVING" );
	
	//stat tracking - failed revive
	self thread check_for_failed_revive(playerBeingRevived);
	
	self playlocalsound( "chr_revive_start" );
	
	while( self is_reviving( playerBeingRevived ) )
	{
		{wait(.05);};
		timer += 0.05;

		if ( self player_is_in_laststand() )
		{
			break;
		}
		
		if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
		{
			break;
		}

		if( timer >= reviveTime)
		{
			revived = true;
			scoreevents::processScoreEvent( "player_did_revived", self );
			break;
		}
	}
	
	self playlocalsound( "chr_revive_end" );
	
	if( isdefined( self.reviveProgressBar ) )
	{
		self.reviveProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.reviveTextHud ) )
	{
		self.reviveTextHud destroy();
	}
	
	if( IsDefined( playerBeingRevived.revivetrigger.auto_revive ) && playerBeingRevived.revivetrigger.auto_revive == true )
	{
		// ww: just fall through this part, no stoprevive
	}
	else if( !revived )
	{
		if ( IsPlayer( playerBeingRevived ) )
		{
			playerBeingRevived stoprevive( self );
		}
	}

	// CODER_MOD: TOMMYK 07/13/2008
	playerBeingRevived.revivetrigger setHintString( &"COOP_BUTTON_TO_REVIVE_PLAYER" );
	playerBeingRevived.revivetrigger.beingRevived = 0;

	self notify( "do_revive_ended_normally" );
	self.is_reviving_any--;

	// This player stopper reviving (kick of a thread to check to see if the player now bleeds out)
	if( !revived )
	{
		playerBeingRevived thread checkforbleedout( self );
	}
	
	return revived;
}


//*****************************************************************************
// Persistent upgrade, revive upgrade lost check
//*****************************************************************************

// self = player who failed to revive a college
function checkforbleedout( player )
{
	self endon ( "player_revived" );
	self endon ( "player_suicide" );
	self endon ( "disconnect" );
	player endon( "disconnect" );

// MikeA: You now automatically lose the upgrade if you fail a revive
/*
	self waittill( "bled_out" );
*/
	
	//player.failed_revives++;
	player notify( "player_failed_revive" );
}


//*****************************************************************************
//*****************************************************************************
// auto revive on notify - used in scene system to revive player before an animation
function auto_revive_on_notify()
{
	self endon( "player_revived" );
	self waittill( "auto_revive", reviver, dont_enable_weapons );
	auto_revive( reviver, dont_enable_weapons );
}

function auto_revive( reviver, dont_enable_weapons )
{
	if( IsDefined( self.revivetrigger ) )
	{
		self.revivetrigger.auto_revive = true;
		if( self.revivetrigger.beingRevived == 1 )
		{
			while( 1 )
			{
				if( self.revivetrigger.beingRevived == 0 )
				{
					break;
				}
				util::wait_network_frame();
	
			}
		}
		self.revivetrigger.auto_trigger = false;
	}

	self reviveplayer();

//	util::setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self clientfield::set_to_player( "sndHealth", 0 );
	
	self notify( "stop_revive_trigger" );
	if(isDefined(self.revivetrigger))
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self cleanup_suicide_hud();

	if( !IsDefined(dont_enable_weapons) || (dont_enable_weapons == false) )
	{
		self laststand_enable_player_weapons();
	}

	self AllowJump( true );
	
	self.ignoreme = false;
	self DisableInvulnerability();
	self.laststand = undefined;

	//don't do this for Grief
	if(!( isdefined( level.isresetting_grief ) && level.isresetting_grief ))
	{
		// ww: moving the revive tracking, wasn't catching below the auto_revive
		
		if ( isdefined( reviver ) )
		{
			reviver.revives++;
			if( IsPlayer( reviver ) )
			{
				reviver AddPlayerStat( "REVIVES", 1 );
			}
		}
		
		//stat tracking
	//	demo::bookmark( "player_revived", gettime(), self, reviver );
	}

	self notify ( "player_revived", reviver );
}


function remote_revive( reviver )
{
	if ( !self player_is_in_laststand() )
	{
		return;
	}	

	self auto_revive( reviver );
}


function revive_success( reviver, b_track_stats = true )
{
	// Maybe it was a chugabud corpse that was revived
	if( !IsPlayer(self) )
	{
		self notify ( "player_revived", reviver );
		return;
	}

	if( ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		demo::bookmark( "player_revived", gettime(), reviver, self );
	}
	
	self notify ( "player_revived", reviver );
	bb::logplayermapnotification("player_revived", self);
	self reviveplayer();

	//CODER_MOD: TOMMYK 06/26/2008 - For coop scoreboards
	
	reviver.revives++;
	if( IsPlayer( reviver ) )
	{
		reviver AddPlayerStat( "REVIVES", 1 );
	}
	//stat tracking
	reviver.upgrade_fx_origin = self.origin;
	
	if( ( isdefined( b_track_stats ) && b_track_stats ) )
	{
		reviver thread check_for_sacrifice(); //stat tracking 
	}
	
	// CODER MOD: TOMMY K - 07/30/08
	//reviver thread call_overloaded_func( "maps\_arcademode", "arcademode_player_revive" );
					
	//CODER_MOD: Jay (6/17/2008): callback to revive challenge
	if( isdefined( level.missionCallbacks ) )
	{
		// removing coop challenges for now MGORDON
		//maps\_challenges_coop::doMissionCallback( "playerRevived", reviver ); 
	}	
	
//	util::setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self clientfield::set_to_player( "sndHealth", 0 );
	
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self cleanup_suicide_hud();

	self laststand_enable_player_weapons();
	self lui::screen_close_menu();
	
	self.ignoreme = false;
	self DisableInvulnerability();
}

function revive_force_revive( reviver )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( self player_is_in_laststand() );

	self thread revive_success( reviver );
}

function revive_hud_think()
{
	level endon("game_ended");
	
	while ( 1 )
	{
		wait( 0.1 );

		if ( !player_any_player_in_laststand() )
		{
			continue;
		}
		
		revived = false;
		
		foreach( team in level.teams )
		{
			playerToRevive = undefined;
		
			foreach( player in level.alivePlayers[team] )
			{	
				if( !IsDefined( player.revivetrigger ) || !isDefined( player.revivetrigger.createtime ) )
				{
					continue;
				}
				
				if( !isDefined(playerToRevive) || playerToRevive.revivetrigger.createtime > player.revivetrigger.createtime )
				{
					playerToRevive = player;
				}
			}
			
			if( isDefined( playerToRevive ) )
			{
				foreach( player in level.alivePlayers[team] )
				{	
					if( player player_is_in_laststand() )
					{
						continue;
					}
			
					player thread fadeReviveMessageOver( playerToRevive, 3.0 );
				}
				
				playerToRevive.revivetrigger.createtime = undefined;
				revived = true;
			}		
		}

		if ( revived )		
			wait( 3.5 );	
	}
}

//CODER_MOD: TOMMYK 07/13/2008
function fadeReviveMessageOver( playerToRevive, time )
{
	revive_hud_show();
	self.revive_hud setText( &"COOP_PLAYER_NEEDS_TO_BE_REVIVED", playerToRevive );
	self.revive_hud fadeOverTime( time );
	self.revive_hud.alpha = 0;
}

function laststand_getup()
{
	self endon ("player_revived");
	self endon ("disconnect");

/#	println( "ZM >> laststand_getup called" );	#/
	self update_lives_remaining(false);

//	util::setClientSysState("lsm", "1", self);
	self clientfield::set_to_player( "sndHealth", 2 );
	
	self.laststand_info.getup_bar_value = 0.5;

	self thread laststand_getup_hud();
	self thread laststand_getup_damage_watcher();

	while ( self.laststand_info.getup_bar_value < 1 )
	{
		self.laststand_info.getup_bar_value += 0.0025;
		{wait(.05);};
	}

	self auto_revive( self );
	bb::logplayermapnotification("last_stand_getup", self);
//	util::setClientSysState("lsm", "0", self);	// Notify client last stand ended.
	self clientfield::set_to_player( "sndHealth", 0 );
}

// a sacrifice is when a player sucessfully revives another player, but dies afterwards
function check_for_sacrifice()
{
	self util::delay_notify("sacrifice_denied",1); //dying within 1 second of reviving another player is considered to be a 'sacrifice' 
	self endon("sacrifice_denied");
	
	self waittill("player_downed");
	
	//stat tracking
	//iprintlnbold("sacrifice made");
}

//when a player is downed, any player that starts/stops reviving him will fail the revive if the player bleeds out
function check_for_failed_revive(playerBeingRevived) 
{	
	self endon("disconnect");

	playerBeingRevived endon("disconnect");	 //end if the player being revived disconnects
	playerBeingRevived endon("player_suicide");
	
	self notify("checking_for_failed_revive"); //to prevent stacking this thread if the same player starts/stops reviving several times while the player is downed
	self endon("checking_for_failed_revive");
	
	playerBeingRevived endon("player_revived"); //end if the player gets revived
		
	playerBeingRevived waittill("bled_out"); // the player being revived bled out 
	
	//stat tracking
	//iprintlnbold("failed the revive");
}


function add_weighted_down()
{
	weighted_down = 1000;
	if(level.round_number > 0) 
	{
		weighted_down =  Int( 1000.0 / ceil( level.round_number / 5.0 ) ); // multiply the value by 1000 to upload the unsigned integer data
	}
	self AddPlayerStat( "weighted_downs", weighted_down ); 
}

function update_regen_widget( duration, eventToEndOn )
{
	level endon( eventToEndOn );
	self healthoverlay::update_regen_delay_progress( duration );
}

//handling player lastand in raid mode
function wait_and_revive(emergency_reserve=false)
{
	self endon("disconnect");
	self endon("death");
	
	level flag::set( "wait_and_revive" );
	if ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive == true )
	{
		return;
	}

	self.waiting_to_revive = true;

	solo_revive_time = 10.0;
	
	bleedout_time = GetDvarfloat( "player_lastStandBleedoutTime" );
	if ( bleedout_time <= solo_revive_time )
	{
		solo_revive_time = bleedout_time * 0.5;
	}

	if(( isdefined( emergency_reserve ) && emergency_reserve ))
	{
		if(level.players.size == 1)
		{
			self.revive_hud setText( &"COOP_REVIVE_EMERGENCY_RESERVE_ONCE");
		}
		else
		{
			self.revive_hud setText( &"COOP_REVIVE_EMERGENCY_RESERVE");
		}
	}
	else
	{
		if( self.lives == 1 )
		{
			self.revive_hud setText( &"COOP_REVIVING_SOLO_LAST_LIFE", self );
		}
		else
		{
			self.revive_hud setText( &"COOP_REVIVING_SOLO", self, self.lives );
		}
	}

	self startRevive(self);
	
	self laststand::revive_hud_show_n_fade( solo_revive_time );

	self thread update_regen_widget( solo_revive_time, "instant_revive" );

	level flag::wait_till_timeout( solo_revive_time, "instant_revive" );

	self stopRevive(self);

	self.lastRegenDelayProgress = 1.0;
	self SetControllerUIModelValue( "hudItems.regenDelayProgress", 1.0 );

	if ( level flag::get( "instant_revive" ) )
	{
		self laststand::revive_hud_show_n_fade( 1.0 );
	}
	
	level flag::clear( "wait_and_revive" );

	self laststand::auto_revive( self );
	self.lives--;

/#
	if( ( isdefined( self.infinite_solo_revives ) && self.infinite_solo_revives ) )
	{
		self.lives = level.numLives; //always just make sure its set to default value
	}
#/

	self.waiting_to_revive = false;
}


function remote_revive_watch()
{
	self endon( "death" );
	self endon( "player_revived" );

	keep_checking = true;
	while( keep_checking )
	{
		self waittill( "remote_revive", reviver );
	
		//Check the remote reviver is on the same team
		if( reviver.team == self.team )
		{
			keep_checking = false;
		}
	}
	
	self laststand::remote_revive( reviver );
}


function player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	b_alt_visionset = false;
		
	self AllowJump(false);
	
	currWeapon = self GetCurrentWeapon();
	statWeapon = currWeapon;
	
	if ( isDefined(self.lives) && self.lives>0 )
	{
		self thread wait_and_revive(self HasCyberComRig("cybercom_emergencyreserve")!=0 );
	}

	self thread remote_revive_watch();

	// Turns out we need to do this after all, but we don't want to change _laststand.gsc postship, so I'm doing it here manually instead
	self DisableOffhandWeapons();

	//self thread last_stand_grenade_save_and_return();
}


