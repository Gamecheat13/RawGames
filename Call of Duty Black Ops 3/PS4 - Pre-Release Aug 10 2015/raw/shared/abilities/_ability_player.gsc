#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\weapons\replay_gun;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

#using scripts\shared\abilities\gadgets\_gadget_armor; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_speed_burst;   // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_camo;   // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_vision_pulse; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_hero_weapon; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_other; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_combat_efficiency; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_flashback; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_cleanse; // for loading purposes only - do not use from here

#using scripts\shared\abilities\gadgets\_gadget_system_overload; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_servo_shortout; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_exo_breakdown; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_surge; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_security_breach; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_iff_override; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_cacophany; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_es_strike; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_ravage_core; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_concussive_wave; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_overdrive; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_unstoppable_force; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_rapid_strike; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_sensory_overload; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_forced_malfunction; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_immolation; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_firefly_swarm; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_smokescreen; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_misdirection; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_mrpukey; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_active_camo; // for loading purposes only - do not use from here

#using scripts\shared\abilities\gadgets\_gadget_shock_field; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_resurrect; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_heat_wave; // for loading purposes only - do not use from here
#using scripts\shared\abilities\gadgets\_gadget_clone; // for loading purposes only - do not use from here

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#namespace ability_player;

function autoexec __init__sytem__() {     system::register("ability_player",&__init__,undefined,undefined);    }

//---------------------------------------------------------
// Init
function __init__()
{
	init_abilities();

	setup_clientfields();
	
	level thread gadgets_wait_for_game_end();

	callback::on_connect(&on_player_connect);
	callback::on_spawned( &on_player_spawned );
	callback::on_disconnect( &on_player_disconnect );
	
	/#
		level thread abilities_devgui_init();
	#/
}

function init_abilities()
{
}

function setup_clientfields()
{
}

function on_player_connect()
{
	if(!isdefined(self._gadgets_player))self._gadgets_player=[];	
	
	/#
		self thread abilities_devgui_player_connect();
	#/
}

function on_player_spawned()
{	
	self thread gadgets_wait_for_death();
	self.heroAbilityActivateTime = undefined;
	self.heroAbilityDectivateTime = undefined;
	self.heroAbilityActive = undefined;
}

function on_player_disconnect()
{
	/#
		self thread abilities_devgui_player_disconnect();
	#/
}

function is_using_any_gadget()
{
	if ( !isPlayer( self ) )
		return false;
	
	for ( i = 0; i < 3; i++ )
	{
		if ( self gadget_is_in_use( i ) )
		{
			return true;
		}
	}	
	
	return false;
}

function gadgets_save_power( game_ended )
{
	for ( slot = 0; slot < 3; slot++ )
	{			
		if ( !isdefined( self._gadgets_player[slot] ) )
		{
			continue;
		}			
			
		gadgetWeapon = self._gadgets_player[slot];
		
		powerLeft = self GadgetPowerChange( slot, 0.0 );
		
		if ( game_ended && gadget_is_in_use( slot ) )
		{
			self GadgetDeactivate( slot, gadgetweapon );
			
			if ( gadgetWeapon.gadget_power_round_end_active_penalty > 0 )
			{
				powerLeft = powerLeft - gadgetWeapon.gadget_power_round_end_active_penalty;
				powerLeft = max( 0.0, powerLeft );
			}			
		}
			
		self.pers["held_gadgets_power"][gadgetWeapon] = powerLeft;
	}
}

function gadgets_wait_for_death()
{
	self endon( "disconnect" );

	self.pers["held_gadgets_power"] = [];

	self waittill( "death" );

	if ( !isdefined( self._gadgets_player ) )
	{
		return;
	}	
		
	self gadgets_save_power( false );
}

function gadgets_wait_for_game_end()
{	
	level waittill( "game_ended" );	
	
	players = GetPlayers();
	
	foreach ( player in players )
	{
		if ( !IsAlive( player ) )
		{
			continue;
		}
		
		if ( !isdefined( player._gadgets_player ) )
		{
			continue;
		}
		
		player gadgets_save_power( true );
	}
}

// Call this to change player class from script	
function script_set_cclass( cclass, save = true )
{
}

//---------------------------------------------------------
// gadgets

function update_gadget( weapon )
{	
}

function register_gadget( type )
{
	if(!isdefined(level._gadgets_level))level._gadgets_level=[];

	if ( !IsDefined( level._gadgets_level[ type ] ) )
	{
		level._gadgets_level[ type ] = spawnstruct();
	}
}

function register_gadget_possession_callbacks( type, on_give, on_take )
{
	register_gadget( type ); 

	if(!isdefined(level._gadgets_level[ type ].on_give))level._gadgets_level[ type ].on_give=[];
	if(!isdefined(level._gadgets_level[ type ].on_take))level._gadgets_level[ type ].on_take=[];
	if ( IsDefined(on_give) )
	{
		if ( !isdefined( level._gadgets_level[ type ].on_give ) ) level._gadgets_level[ type ].on_give = []; else if ( !IsArray( level._gadgets_level[ type ].on_give ) ) level._gadgets_level[ type ].on_give = array( level._gadgets_level[ type ].on_give ); level._gadgets_level[ type ].on_give[level._gadgets_level[ type ].on_give.size]=on_give;;
	}
	if ( IsDefined(on_take) )
	{
		if ( !isdefined( level._gadgets_level[ type ].on_take ) ) level._gadgets_level[ type ].on_take = []; else if ( !IsArray( level._gadgets_level[ type ].on_take ) ) level._gadgets_level[ type ].on_take = array( level._gadgets_level[ type ].on_take ); level._gadgets_level[ type ].on_take[level._gadgets_level[ type ].on_take.size]=on_take;;
	}
}

function register_gadget_activation_callbacks( type, turn_on, turn_off )
{
	register_gadget( type );

	if(!isdefined(level._gadgets_level[ type ].turn_on))level._gadgets_level[ type ].turn_on=[];
	if(!isdefined(level._gadgets_level[ type ].turn_off))level._gadgets_level[ type ].turn_off=[];
	if ( IsDefined(turn_on) )
	{
		if ( !isdefined( level._gadgets_level[ type ].turn_on ) ) level._gadgets_level[ type ].turn_on = []; else if ( !IsArray( level._gadgets_level[ type ].turn_on ) ) level._gadgets_level[ type ].turn_on = array( level._gadgets_level[ type ].turn_on ); level._gadgets_level[ type ].turn_on[level._gadgets_level[ type ].turn_on.size]=turn_on;;
	}
	if ( IsDefined(turn_off) )
	{
		if ( !isdefined( level._gadgets_level[ type ].turn_off ) ) level._gadgets_level[ type ].turn_off = []; else if ( !IsArray( level._gadgets_level[ type ].turn_off ) ) level._gadgets_level[ type ].turn_off = array( level._gadgets_level[ type ].turn_off ); level._gadgets_level[ type ].turn_off[level._gadgets_level[ type ].turn_off.size]=turn_off;;
	}
}

function register_gadget_flicker_callbacks( type, on_flicker )
{
	register_gadget( type );

	if(!isdefined(level._gadgets_level[ type ].on_flicker))level._gadgets_level[ type ].on_flicker=[];

	if ( IsDefined( on_flicker ) )
	{
		if ( !isdefined( level._gadgets_level[ type ].on_flicker ) ) level._gadgets_level[ type ].on_flicker = []; else if ( !IsArray( level._gadgets_level[ type ].on_flicker ) ) level._gadgets_level[ type ].on_flicker = array( level._gadgets_level[ type ].on_flicker ); level._gadgets_level[ type ].on_flicker[level._gadgets_level[ type ].on_flicker.size]=on_flicker;;
	}
}

function register_gadget_ready_callbacks( type, ready_func )
{
	register_gadget( type ); 

	if(!isdefined(level._gadgets_level[ type ].on_ready))level._gadgets_level[ type ].on_ready=[];

	if ( IsDefined( ready_func ) )
	{
		if ( !isdefined( level._gadgets_level[ type ].on_ready ) ) level._gadgets_level[ type ].on_ready = []; else if ( !IsArray( level._gadgets_level[ type ].on_ready ) ) level._gadgets_level[ type ].on_ready = array( level._gadgets_level[ type ].on_ready ); level._gadgets_level[ type ].on_ready[level._gadgets_level[ type ].on_ready.size]=ready_func;;
	}
}

function register_gadget_primed_callbacks( type, primed_func )
{
	register_gadget( type ); 

	if(!isdefined(level._gadgets_level[ type ].on_primed))level._gadgets_level[ type ].on_primed=[];

	if ( IsDefined( primed_func ) )
	{
		if ( !isdefined( level._gadgets_level[ type ].on_primed ) ) level._gadgets_level[ type ].on_primed = []; else if ( !IsArray( level._gadgets_level[ type ].on_primed ) ) level._gadgets_level[ type ].on_primed = array( level._gadgets_level[ type ].on_primed ); level._gadgets_level[ type ].on_primed[level._gadgets_level[ type ].on_primed.size]=primed_func;;
	}
}

function register_gadget_is_inuse_callbacks( type, inuse_func )
{
	register_gadget( type );
	
	if ( IsDefined( inuse_func ) )
	{
		level._gadgets_level[ type ].isInUse = inuse_func;
	}
}

function register_gadget_is_flickering_callbacks( type, flickering_func )
{
	register_gadget( type ); 

	if ( IsDefined( flickering_func ) )
	{
		level._gadgets_level[ type ].isFlickering = flickering_func;
	}
}

function register_gadget_failed_activate_callback( type, failed_activate )
{
	register_gadget( type );

	if(!isdefined(level._gadgets_level[ type ].failed_activate))level._gadgets_level[ type ].failed_activate=[];

	if ( IsDefined( failed_activate ) )
	{
		if ( !isdefined( level._gadgets_level[ type ].failed_activate ) ) level._gadgets_level[ type ].failed_activate = []; else if ( !IsArray( level._gadgets_level[ type ].failed_activate ) ) level._gadgets_level[ type ].failed_activate = array( level._gadgets_level[ type ].failed_activate ); level._gadgets_level[ type ].failed_activate[level._gadgets_level[ type ].failed_activate.size]=failed_activate;;
	}
}

function gadget_is_in_use( slot )
{
	if ( IsDefined( self._gadgets_player[slot] ) )
	{
		if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
		{
			if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].isInUse ) )
			{
				return self [[level._gadgets_level[ self._gadgets_player[slot].gadget_type ].isInUse]]( slot );
			}
		}
	}
	
	return self GadgetIsActive( slot );
}

function gadget_is_flickering( slot )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return false;
	}

	if ( !IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].isFlickering ) )
	{
		return false;
	}

	return self [[level._gadgets_level[ self._gadgets_player[slot].gadget_type ].isFlickering]]( slot );
}

function give_gadget( slot, weapon )
{
	if ( IsDefined( self._gadgets_player[slot] ) )
	{
		self take_gadget( slot, self._gadgets_player[slot] );
	}
	
	for ( eSlot = 0; eSlot < 3; eSlot++ )
	{
		existingGadget	= self._gadgets_player[eSlot];
		
		if ( IsDefined( existingGadget ) && existingGadget == weapon )
		{
			self take_gadget( eSlot, existingGadget );
		}
	}

	self._gadgets_player[slot] = weapon;
	
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}

	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_give ) )
		{
			foreach( on_give in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_give )
				self [[on_give]]( slot, weapon );
		}	
	}	
}

function take_gadget( slot, weapon )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}	
	
	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_take ) )
		{
			foreach( on_take in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_take )
				self [[on_take]]( slot, weapon );
		}
	}	
	
	self._gadgets_player[slot] = undefined;

}

function turn_gadget_on( slot, weapon )
{	    
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}
	
	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].turn_on ) )
		{
			foreach( turn_on in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].turn_on )
			{
				self [[turn_on]]( slot, weapon );

				self trackHeroPowerActivated( game["timepassed"] );			
			}
		}
	}
	
	if( IsDefined( level.cybercom ) && IsDefined( level.cybercom._ability_turn_on ) )
	{
		self [[level.cybercom._ability_turn_on]]( slot, weapon );
	}
	
	// Make this persistant so we don't re-notify when a new round begins
	self.pers["heroGadgetNotified"] = false;
	
	xuid = self GetXUID();
	bbPrint( "mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid( self ), getTime(), self._gadgets_player[slot].name, "activated", self.name, xuid );

	if ( weapon.gadget_type == 14 )
	{
		if ( isdefined( level.playHeroweaponActivate ) )
		{
			[[level.playHeroweaponActivate]]();
		}
	}
	else
	{
		if ( isdefined( level.playHeroabilityActivate ) )
		{
			[[level.playHeroabilityActivate]]();
		}
		self.heroAbilityActivateTime = getTime();
		self.heroAbilityActive = true;
		self.heroAbility = weapon;
	} 
	
	self thread ability_power::power_consume_timer_think( slot, weapon );
}

function turn_gadget_off( slot, weapon )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}
	
	if ( !IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		return;
	}

	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].turn_off ) )
	{
		foreach( turn_off in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].turn_off )
		{
			self [[turn_off]]( slot, weapon );

			// self.heroweaponShots and self.heroweaponHits may be undefined, and that's ok
			dead = self.health <= 0;
			self trackHeroPowerExpired( game["timepassed"], dead, self.heroweaponShots, self.heroweaponHits );

		}
	}	
	
	if( IsDefined( level.cybercom ) && IsDefined( level.cybercom._ability_turn_off ) )
	{
		self [[level.cybercom._ability_turn_off]]( slot, weapon );
	}
	
	if ( weapon.gadget_type != 14 )
	{
		self.heroAbilityDectivateTime = getTime();
		self.heroAbilityActive = undefined;
		self.heroAbility = weapon;
	}
		
	xuid = self GetXUID();
	bbPrint( "mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid( self ), getTime(), self._gadgets_player[slot].name, "expired", self.name, xuid );
}

function gadget_CheckHeroAbilityKill( attacker )
{
	heroAbilityStat = false;
	
	if ( isdefined( attacker.heroAbility ) )
	{
		switch( attacker.heroAbility.name )
		{
			case "gadget_armor":
			case "gadget_clone":
			case "gadget_speed_burst":
			{
				if ( isdefined( attacker.heroAbilityActive ) || ( isdefined( attacker.heroAbilityDectivateTime ) && attacker.heroAbilityDectivateTime > gettime() - 100 ) )
				{
					heroAbilityStat = true;
				}
				break;
			}
			case "gadget_camo":
			case "gadget_flashback":
			case "gadget_resurrect":
			{
				if ( isdefined( attacker.heroAbilityActive ) 
					    || ( isdefined( attacker.heroAbilityDectivateTime ) && attacker.heroAbilityDectivateTime > gettime() - 6000 ) )
				{
					heroAbilityStat = true;
				}
				break;
			}				
			case "gadget_vision_pulse":	     
			{
				if ( isdefined( attacker.visionPulseSpottedEnemyTime ) )
				{
					timeCutoff = getTime();
					if ( attacker.visionPulseSpottedEnemyTime + 10000 > timeCutoff )
					{
						for ( i = 0; i < attacker.visionPulseSpottedEnemy.size; i++ )
						{
							spottedEnemy = attacker.visionPulseSpottedEnemy[i];
							if ( spottedEnemy == self ) 
							{
								if (  self.lastSpawnTime < attacker.visionPulseSpottedEnemyTime )
								{
									heroAbilityStat = true;
									break;
								}
							}
						}
					}
				}
			}
		}
	}
	return heroAbilityStat;			
}


function gadget_flicker( slot, weapon )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}
	
	if ( !IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		return;
	}
	
	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_flicker ) )
	{
		foreach( on_flicker in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_flicker )
			self [[on_flicker]]( slot, weapon );
	}
}

function gadget_ready( slot, weapon )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}
	
	if ( !IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		return;
	}
	
	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_ready ) )
	{
		foreach( on_ready in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_ready )
			self [[on_ready]]( slot, weapon );
	}

	if ( IsDefined( level.statsTableID ) )
	{
		itemRow = tableLookupRowNum( level.statsTableID, 4, self._gadgets_player[slot].name );
		if ( itemRow > -1 )
		{
			index = int(tableLookupColumnForRow( level.statsTableID, itemRow, 0 ));
			if ( index != 0 )
			{
				self LUINotifyEvent( &"hero_weapon_received", 1, index );
				self LUINotifyEventToSpectators( &"hero_weapon_received", 1, index );
			}
		}
	}
	
	if ( !isdefined( level.gameEnded ) || !level.gameEnded )
	{
		if ( !isdefined( self.pers["heroGadgetNotified"] ) || !self.pers["heroGadgetNotified"] )
		{
			self.pers["heroGadgetNotified"] = true;
			
			if ( weapon.gadget_type == 14 )
			{
				if ( isdefined( level.playHeroweaponReady ) )
				{
					[[level.playHeroweaponReady]]();				
				}				
			}
			else if ( isdefined( level.playHeroabilityReady ) )
			{
				[[level.playHeroabilityReady]]();
			} 

			self trackHeroPowerAvailable( game["timepassed"] );
			
				

		}
	}
	
	xuid = self GetXUID();
	bbPrint( "mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid( self ), getTime(), self._gadgets_player[slot].name, "ready", self.name, xuid );
}

function gadget_primed( slot, weapon )
{
	if ( !IsDefined( self._gadgets_player[slot] ) )
	{
		return;
	}
	
	if ( !IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ] ) )
	{
		return;
	}
	
	if ( IsDefined( level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_primed ) )
	{
		foreach( on_primed in level._gadgets_level[ self._gadgets_player[slot].gadget_type ].on_primed )
			self [[on_primed]]( slot, weapon );
	}
}

/#

//---------------------------------------------------------
// debug output


function abilities_print( str )
{
	toprint = "GADGET ABILITIES: " + str;
	PrintLn( toprint );	
}

//---------------------------------------------------------
// DEVGUI
	



	
function abilities_devgui_init()
{
	SetDvar( "scr_abilities_devgui_cmd", "" );
	SetDvar( "scr_abilities_devgui_arg", "" );
	SetDvar( "scr_abilities_devgui_player", 0 );
	
	if( isDedicated() )
	{
		return;
	}
	
	level.abilities_devgui_base = "\"Player/Heroes/.";	
	
	level thread abilities_devgui_think();
}

function abilities_devgui_player_connect()
{
	if ( !isdefined( level.abilities_devgui_base ) )
		return;
	
	players = GetPlayers();
	
	for ( i=0; i<players.size; i++ )
	{
		if ( players[i] != self )
			continue;
		
		abilities_devgui_add_player_commands( level.abilities_devgui_base, players[i].playername, i+1 );
		return;
	}	
}

function abilities_devgui_add_player_commands( root, pname, index)
{
	add_cmd_with_root = "devgui_cmd " + root + pname + "/";
	
	pid = "" + index;
	
	menu_index = 1;
		
	menu_index = abilities_devgui_add_gadgets( add_cmd_with_root, pid, menu_index );
	
	menu_index = abilities_devgui_add_power( add_cmd_with_root, pid, menu_index );	
}

function abilities_devgui_add_player_command( root, pid, cmdname, menu_index, cmddvar, argdvar)
{
	if ( !isdefined( argdvar ) )
	{
		argdvar = "no_args";
	}
	
	AddDebugCommand( root + cmdname 
	                + "\" \"set " + "scr_abilities_devgui_player" + " " + pid
	                + ";set " + "scr_abilities_devgui_cmd" + " " + cmddvar
					+ ";set " + "scr_abilities_devgui_arg" + " " + argdvar + "\" \n");
}

function abilities_devgui_add_power( add_cmd_with_root, pid, menu_index )
{
	root = add_cmd_with_root + "Power:" + menu_index + "/";
	
	abilities_devgui_add_player_command( root, pid, "Power Fill", 1, "power_f", "" );
	abilities_devgui_add_player_command( root, pid, "Toggle Auto Fill", 2, "power_t_af", "" );	
	
	menu_index++;
	
	return menu_index;
}

function abilities_devgui_add_gadgets( add_cmd_with_root, pid, menu_index )
{
	a_weapons = EnumerateWeapons( "weapon" );
	
	a_hero = [];
	a_abilities = [];
	
	for ( i = 0; i < a_weapons.size; i++ )
	{
		if ( a_weapons[i].isGadget )
		{
			if ( a_weapons[i].inventoryType == "hero" )
			{
				ArrayInsert( a_hero, a_weapons[i], 0 );
			}
			else
			{
				ArrayInsert( a_abilities, a_weapons[i], 0 );
			}			
		}
	}

	abilities_devgui_add_player_weapons( add_cmd_with_root, pid, a_abilities, "Hero Abilities", menu_index );
	menu_index++;
	abilities_devgui_add_player_weapons( add_cmd_with_root, pid, a_hero, "Hero Weapons", menu_index );
	menu_index++;
	
	return menu_index;
}

function abilities_devgui_add_player_weapons( root, pid, a_weapons, weapon_type, menu_index )
{		
	if ( IsDefined( a_weapons ) )
	{
		player_devgui_root = root + weapon_type + "/";	
		
		for ( i = 0; i < a_weapons.size; i++ )
		{
			abilities_devgui_add_player_weap_command( player_devgui_root, pid, a_weapons[i].name, i + 1 );
		}
	}
}

function abilities_devgui_add_player_weap_command( root, pid, weap_name, cmdindex )
{
	AddDebugCommand( root + weap_name + "\" \"set " + "scr_abilities_devgui_player" + " " + pid
	                + ";set " + "scr_abilities_devgui_cmd" + " " + "give_ability"
					+ ";set " + "scr_abilities_devgui_arg" + " " + weap_name + "\" \n");
}

function abilities_devgui_player_disconnect()
{
	if ( !isdefined( level.abilities_devgui_base ) )
		return;
	
	remove_cmd_with_root = "devgui_remove " + level.abilities_devgui_base + self.playername + "\" \n";
	
	util::add_queued_debug_command( remove_cmd_with_root );
}

function abilities_devgui_think()
{
	for ( ;; )
	{
		cmd = GetDvarString( "scr_abilities_devgui_cmd" );
		if (cmd=="")
		{
			{wait(.05);};
			continue;
		}

		arg = GetDvarString( "scr_abilities_devgui_arg" );
			
		switch ( cmd )
		{
		case "power_f":
			abilities_devgui_handle_player_command( cmd, &abilities_devgui_power_fill );
			break;
		case "power_t_af":
			abilities_devgui_handle_player_command( cmd, &abilities_devgui_power_toggle_auto_fill );
			break;
		case "give_ability":
			abilities_devgui_handle_player_command( cmd, &abilities_devgui_give, arg );
		case "":
			break;
		default:
			break;
		}
	
		SetDvar( "scr_abilities_devgui_cmd", "" );
		wait( 0.5 );
	}
}

function abilities_devgui_give( weapon_name )
{	
	for ( i = 0; i < 3; i++ )
	{
		if ( isdefined( self._gadgets_player[i] ) )
		{			
			self TakeWeapon( self._gadgets_player[i] );
		}
	}
	
	weapon = GetWeapon( weapon_name );
	self GiveWeapon( weapon );
	if ( self util::is_bot() )
	{
		slot = self GadgetGetSlot( weapon );
		self GadgetPowerSet( slot, 100.0 );
		
		if ( weapon.inventoryType == "hero" )
		{
			self SwitchToWeapon( weapon );
		}
		else
		{
			self BotPressButtonForGadget( weapon );
		}		
	}
}

function abilities_devgui_handle_player_command( cmd, playercallback, pcb_param )
{
	pid = GetDvarInt( "scr_abilities_devgui_player" );
	
	if (pid>0)
	{
		player = GetPlayers()[pid-1];
		if (IsDefined(player))
		{
			if (IsDefined( pcb_param ))
				player thread [[playercallback]]( pcb_param );
			else
				player thread [[playercallback]]();
		}
	}
	else
	{
		array::thread_all( GetPlayers(), playercallback, pcb_param );	
	}
	
	SetDvar( "scr_abilities_devgui_player", "-1" );
}

function abilities_devgui_power_fill()	
{
	if ( !isdefined( self ) || !isdefined( self._gadgets_player ) )
	{
		return;
	}
	
	for ( i = 0; i < 3; i++ )
	{
		if ( isdefined( self._gadgets_player[i] ) )
		{
			self GadgetPowerSet( i, self._gadgets_player[i].gadget_powerMax );
		}
	}
}

function abilities_devgui_power_toggle_auto_fill()
{
	if ( !isdefined( self ) || !isdefined( self._gadgets_player ) )
	{
		return;
	}
	
	self.abilities_devgui_power_toggle_auto_fill = !( isdefined( self.abilities_devgui_power_toggle_auto_fill ) && self.abilities_devgui_power_toggle_auto_fill );	
	
	self thread abilities_devgui_power_toggle_auto_fill_think();
}


function abilities_devgui_power_toggle_auto_fill_think()
{
	self endon( "disconnect" );
	
	self notify( "auto_fill_think" );
	self endon( "auto_fill_think" );
	
	for ( ;; )
	{			
		if ( !isdefined( self ) || !isdefined( self._gadgets_player ) )
		{
			return;
		}
		
		if (!( isdefined( self.abilities_devgui_power_toggle_auto_fill ) && self.abilities_devgui_power_toggle_auto_fill ))
		{
			return;;
		}

		for ( i = 0; i < 3; i++ )
		{			
			if ( isdefined( self._gadgets_player[i] ) )
			{
				if ( !self ability_player::gadget_is_in_use( i ) && self GadgetCharging( i ) )
				{
					self GadgetPowerSet( i, self._gadgets_player[i].gadget_powerMax );
				}
			}
		}
		
		wait( 1 );
	}
}

#/


