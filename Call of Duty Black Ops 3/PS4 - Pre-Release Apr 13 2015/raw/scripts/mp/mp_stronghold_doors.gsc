#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\ctf;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_supplydrop;















// THESE ARE NOT LOCALIZED,  once a set of words has been chosen make sure they are localized




	
#namespace mp_stronghold_doors;
	
function init()
{
	
	doors = GetEntArray( "mp_stronghold_security_door_lower", "targetname" );
	if ( !isdefined( doors ) || doors.size == 0 )
	{
		return;
	}

	uppers = GetEntArray( "mp_stronghold_security_door_upper", "targetname" );
	killtriggers = GetEntArray( "mp_stronghold_killbrush", "targetname" );
	
	assert( uppers.size == doors.size );
	assert( killtriggers.size == killtriggers.size );
	
	
	foreach( door in doors )
	{
		upper = get_closest( door.origin, uppers );
		killtrigger = get_closest( door.origin, killtriggers );
		level thread setup_doors( door, upper, killtrigger );
	}
	
	level thread door_use_trigger();
}

function setup_doors( door, upper, trigger )
{
	door.upper = upper;
	door.kill_trigger = trigger;
	assert( isdefined( door.kill_trigger ) );
	door.kill_trigger EnableLinkTo();
	door.kill_trigger linkto( door );
	
	door.opened = true;
	door.origin_opened = door.origin;
	door.force_open_time = 0;
	
	door.origin_closed_half = ( door.origin[0], door.origin[1], door.origin[2] - ( 180 / 2 ));
	door.origin_closed = ( door.origin[0], door.origin[1], door.origin[2] - 180 );
	
	door thread door_think();
}

function door_use_trigger()
{
	use_triggers = GetEntArray( "mp_stronghold_usetrigger", "targetname" );
	
	foreach( use_trigger in use_triggers )
	{
		use_trigger thread watchTriggerUsage();
		use_trigger thread watchTriggerEnableDisable();
	}
}

function watchTriggerUsage()
{
	for(;;)
	{
		self waittill( "trigger", e_player );
		level notify( "mp_stronghold_trigger_use" );
	}
}

function watchTriggerEnableDisable()
{
	hintString = "";
	for(;;)
	{
		returnVar = level util::waittill_any_return( "mp_stronghold_trigger_enable", "mp_stronghold_trigger_disable", "mp_stronghold_trigger_cooldown" );
		
		switch(returnVar )
		{
			case "mp_stronghold_trigger_enable":
				hintString = "ENABLE";
				break;
			case "mp_stronghold_trigger_disable":
				hintString = "DISABLE";
				break;
			case "mp_stronghold_trigger_cooldown":
				hintString = "COOLDOWN";
				break;
		}

		self SetHintString( hintString );
	}
}

function door_think()
{
	//self door_close();

	for ( ;; )
	{
		exploder::exploder( "fx_switch_red" );
		exploder::kill_exploder( "fx_switch_green" );
		wait( 20 );
		exploder::exploder( "fx_switch_green" );
		exploder::kill_exploder( "fx_switch_red" );
		
		if ( self door_should_open() )
		{
			level notify( "mp_stronghold_trigger_disable" );
		}
		else
		{
			level notify( "mp_stronghold_trigger_enable" );
		}
		
		level waittill( "mp_stronghold_trigger_use" );
		
		level notify( "mp_stronghold_trigger_cooldown" );
		
		if ( self door_should_open() )
		{
			self thread door_open();
			self security_door_drop_think( false );
		}
		else
		{
			self thread door_close();
			self security_door_drop_think( true );
		}
	}
}


function door_should_open()
{
	return ( !self.opened );
}

function door_open()
{
	if ( self.opened )
	{
		return;
	}

		
	dist = Distance( self.origin_closed, self.origin );
	frac = dist / 180;

	halfTime = 9 / 2;
	
	// SOUND DEPT HOOK
	//self playsound ( DOOR_OPEN_SOUND );
	
	self MoveTo( self.origin_closed_half, halfTime );
	self.upper MoveTo( self.origin_opened, halfTime );
	self waittill( "movedone" );
	self MoveTo( self.origin_opened, halfTime );
	
	self.opened = true;
}

function door_close()
{
	if ( !self.opened )
	{
		return;
	}

	dist = Distance( self.origin_closed, self.origin );
	frac = dist / 180;

	halfTime = 9 / 2;
	
	// SOUND DEPT HOOK
	//self playsound ( DOOR_CLOSE_SOUND );
	
	self MoveTo( self.origin_closed_half, halfTime );
	self waittill( "movedone" );
	self MoveTo( self.origin_closed, halfTime );
	self.upper MoveTo( self.origin_closed_half, halfTime );
	
	self.opened = false;
}



function security_door_drop_think( killPlayers )
{
	self endon( "movedone" );
	self.disableFinalKillcam = true;
	door = self;
	corpse_delay = 0;

	for ( ;; )
	{
		wait( 0.2 );

		entities = GetDamageableEntArray( self.origin, 200 );
		
		foreach( entity in entities )
		{
			if ( !entity IsTouching( self.kill_trigger ) )
			{
				continue;
			}
			
			if ( !IsAlive( entity ) )
			{
				continue;
			}
						
			if ( IsDefined( entity.targetname ) )
			{
				if ( entity.targetname == "talon" )
				{
					entity notify( "death" );
					continue;
				}
				else if ( entity.targetname == "riotshield_mp" )
				{
					entity DoDamage( 1, self.origin + ( 0, 0, 1 ), self, self, 0, "MOD_CRUSH" );
					continue;
				}
			}

			if ( IsDefined( entity.helitype ) && entity.helitype == "qrdrone" )
			{
				watcher = entity.owner weaponobjects::getWeaponObjectWatcher( "qrdrone" );
				watcher thread weaponobjects::waitAndDetonate( entity, 0.0, undefined );
				continue;
			}

			if ( entity.classname == "grenade" )
			{
				if( !IsDefined( entity.name ) )
				{
					continue;
				}

				if( !IsDefined( entity.owner ) )
				{
					continue;
				}

				if ( entity.name == "proximity_grenade_mp" )
				{
					watcher = entity.owner getWatcherForWeapon( entity.name );
					watcher thread weaponobjects::waitAndDetonate( entity, 0.0, undefined, "script_mover_mp" );
					continue;
				}

				if( !entity.isEquipment )
				{
					continue;
				}

				watcher = entity.owner getWatcherForWeapon( entity.name );

				if( !IsDefined( watcher ) )
				{
					continue;
				}

				watcher thread weaponobjects::waitAndDetonate( entity, 0.0, undefined, "script_mover_mp" );
				continue;
			}
						
			if ( entity.classname == "auto_turret" )
			{
				if ( !IsDefined( entity.damagedToDeath ) || !entity.damagedToDeath )
				{
					entity util::DoMaxDamage( self.origin + ( 0, 0, 1 ), self, self, 0, "MOD_CRUSH" );
				}
				continue;
			}
			
			if( killPlayers == false && IsPlayer( entity ) )
			{
				continue;
			}

			entity DoDamage( entity.health * 2, self.origin + ( 0, 0, 1 ), self, self, 0, "MOD_CRUSH" );

			if( IsPlayer( entity ) )
			{
				corpse_delay = GetTime() + 1000;
			}
		}

		self destroy_supply_crates();

		if ( GetTime() > corpse_delay )
		{
			self destroy_corpses();
		}

		if ( level.gameType == "ctf" )
		{
			foreach( flag in level.flags )
			{
				if ( flag.visuals[0] IsTouching( self.kill_trigger ) )
				{
					flag ctf::returnFlag();
				}
			}
		}
		else if ( level.gameType == "sd" && !level.multiBomb )
		{
			if ( level.sdBomb.visuals[0] IsTouching( self.kill_trigger ) )
			{
				level.sdBomb gameobjects::return_home();
			}
		}
	}
}


function getWatcherForWeapon( weapname )
{
	if ( !IsDefined( self ) )
	{
		return undefined;
	}

	if ( !IsPlayer( self ) )
	{
		return undefined;
	}

	for ( i = 0; i < self.weaponObjectWatcherArray.size; i++ )
	{
		if ( self.weaponObjectWatcherArray[i].weapon != weapname )
		{ 
			continue;
		}

		return ( self.weaponObjectWatcherArray[i] );
	}

	return undefined;
}


function destroy_supply_crates()
{
	crates = GetEntArray( "care_package", "script_noteworthy" );

	foreach( crate in crates )
	{
		if ( DistanceSquared( crate.origin, self.origin ) < 200 * 200 )
		{
			if( crate IsTouching( self ) ) 
			{
				PlayFX( level._supply_drop_explosion_fx, crate.origin );
				PlaySoundAtPosition( "wpn_grenade_explode", crate.origin );
				wait ( 0.1 );
				crate supplydrop::crateDelete();
			}
		}
	}
}

function destroy_corpses()
{
	corpses = GetCorpseArray();

	for ( i = 0; i < corpses.size; i++ )
	{
		if ( DistanceSquared( corpses[i].origin, self.origin ) < 200 * 200 )
		{
			corpses[i] delete();
		}
	}
}


function get_closest( org, array )
{
	dist = 9999999;

	distsq = dist*dist;
	if( array.size < 1 )
	{
		return;
	}
	index = undefined;
	for( i = 0;i < array.size;i++ )
	{
		newdistsq = distancesquared( array[ i ].origin, org );
		if( newdistsq >= distsq )
		{
			continue;
		}
		distsq = newdistsq;
		index = i;
	}
	return array[index];
}

