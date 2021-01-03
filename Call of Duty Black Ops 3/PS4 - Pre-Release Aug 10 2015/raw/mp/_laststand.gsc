// tagTMR<NOTE>: this is a stripped down last stand implementation for the purposes of hooking into
// the resurrect gadget.  Removed suicide and revive triggers, all hud elements, anything cp/zm specific

#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

#using scripts\shared\abilities\gadgets\_gadget_resurrect;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                     	   	                                                                      	  	  	

#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_killcam;

#namespace laststand;

function autoexec __init__sytem__() {     system::register("laststand",&__init__,undefined,undefined);    }

function __init__()
{
	if (level.script=="frontend")
	{
		return ;
	}
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
			attacker AddWeaponStat(dmgweapon, "kills", 1, attacker.class_num, dmgweapon.isPickedUp);
		}
	}
	
	self.downs++;
}

function PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride )
{
	if( self player_is_in_laststand() )
	{
		return;
	}
	
	if ( isdefined( self.resurrect_not_allowed_by ) )
	{
		return;
	}

	self notify("entering_last_stand");

	// check to see if we are in a game module that wants to do something with PvP damage
	if( isDefined( level._game_module_player_laststand_callback ) )
	{
		self [[ level._game_module_player_laststand_callback ]]( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	}
	
	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = weapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();	
	self.lastStandParams.killcam_entity_info_cached = killcam::get_killcam_entity_info( attacker, eInflictor, weapon );
	
	self thread player_last_stand_stats( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, delayOverride );
	
	self.health = 1;
	self.laststand = true;
	self.ignoreme = true;
	self EnableInvulnerability();
	self.meleeAttackers = undefined;
	self.no_revive_trigger = true;
	
	callback::callback( #"on_player_laststand" );

	assert( IsDefined( self.resurrect_weapon ) ); // defined in gadget_resurrect.gsc
	assert( self.resurrect_weapon != level.weaponNone );

	slot = self ability_util::gadget_slot_for_type( 40 );
	self GadgetStateChange( slot, self.resurrect_weapon, 2 );
	self SwitchToWeapon( self.resurrect_weapon );

	self thread resurrect::enter_rejack_standby(); // UI and input watchers
	self thread watch_player_input();
	
	if ( isdefined( attacker ) && isPlayer( attacker ) && isdefined( self ) && attacker != self )
	{
		scoreevents::processScoreEvent( "downed_player", attacker, self, weapon );
		deathAnimDuration = 0;
		self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);
	}

	demo::bookmark( "player_downed", gettime(), self );
}

// self = a player
function laststand_disable_player_weapons()
{
	weaponInventory = self GetWeaponsList( true );
	self.lastActiveWeapon = self GetCurrentWeapon();
	if ( self IsThrowingGrenade() )
	{
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self.lastActiveWeapon = primaryWeapons[0];
			self SwitchToWeaponImmediate( self.lastActiveWeapon );
		}
	}
}

function laststand_enable_player_weapons( b_allow_grenades = true ) // self == player
{
	self EnableWeaponCycling();
	
	if ( b_allow_grenades )
	{
		self EnableOffhandWeapons();
	}

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

function bleed_out()
{
	demo::bookmark( "player_bledout", gettime(), self, undefined, 1 );

	level notify("bleed_out", self.characterindex);
	
	self UndoLastStand();
	self.ignoreme = false;
	self.laststand = undefined;

	self.useLastStandParams = true;
	
	// attacker may have become undefined if the player that killed me has disconnected
	if ( !isDefined( self.lastStandParams.attacker ) )
	{
		self.lastStandParams.attacker = self;
	}

	self suicide();
}

function watch_player_input() // self == player
{
	self thread watch_player_input_revive();
	self thread watch_player_input_suicide();
}

function watch_player_input_revive() // self == player
{
	level endon("game_ended");

	self endon( "player_input_bleed_out" );
	self endon( "disconnect" );
	self endon( "death" );

	self waittill("player_input_revive");

	demo::bookmark( "player_revived", gettime(), self, self );

	self Rejack(); // TODO: split this out into gadget-specific territory and keep this file last stand only

	self laststand_enable_player_weapons(); 

	self.ignoreme = false;
	self DisableInvulnerability();
	self.laststand = undefined;
}

function watch_player_input_suicide() // self == player
{
	level endon("game_ended");

	self endon( "player_input_revive" );
	self endon( "disconnect" );
	self endon( "death" );

	self waittill("player_input_suicide");

	self bleed_out();
}