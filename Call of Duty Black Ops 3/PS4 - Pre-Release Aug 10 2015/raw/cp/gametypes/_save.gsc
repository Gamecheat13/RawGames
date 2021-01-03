
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

//#using scripts\shared\hud_shared;

#namespace savegame;

function autoexec __init__sytem__() {     system::register("save",&__init__,undefined,undefined);    }

function __init__()
{
	if(!isdefined(world.loadout))world.loadout=[];
	if(!isdefined(world.mapdata))world.mapdata=[];
	if(!isdefined(world.playerdata))world.playerdata=[];
	
	foreach ( trig in trigger::get_all() )
	{
		if ( ( isdefined( trig.script_checkpoint ) && trig.script_checkpoint ) )
		{
			trig thread checkpoint_trigger();
		}
	}

	level._extra_save_safe_checks = [];
}

//-----------------------------------------------------------------------------

function save()
{
	if(!isdefined(world.loadout))world.loadout=[];
}

function load()
{
}

//-----------------------------------------------------------------------------
// MISSION NAME:
//-----------------------------------------------------------------------------

function set_mission_name(name)
{
	if ( IsDefined(level.savename) && level.savename != name )
	{
		/#
			ErrorMsg("Error: Changing level save name from "+level.savename+" to "+name+" expect some data loss" );
		#/
	}
	level.savename = name;
}

function get_mission_name()
{
	if ( !IsDefined(level.savename) )
	{
		set_mission_name(level.script);
	}
	return level.savename;
}


//-----------------------------------------------------------------------------
// MISSION DATA:
// - Used to save persistent data on a "level" basis
//-----------------------------------------------------------------------------

function set_mission_data(name,value)
{
	id = get_mission_name();
	if(!isdefined(world.mapdata))world.mapdata=[];
	if(!isdefined(world.mapdata[id]))world.mapdata[id]=[];
	world.mapdata[id][name]=value;
}

function get_mission_data(name,defval)
{
	id = get_mission_name();
	if ( IsDefined(world.mapdata) && IsDefined(world.mapdata[id]) && IsDefined(world.mapdata[id][name]) )
		return world.mapdata[id][name];
	return defval;		
}

function clear_mission_data()
{
	id = get_mission_name();
	if ( IsDefined(world.mapdata) && IsDefined( world.mapdata[id]) )
		world.mapdata[id] = [];
}

//-----------------------------------------------------------------------------
// PLAYER DATA:
// - Used to save persistent data per player
//-----------------------------------------------------------------------------

function private get_player_unique_id()
{
	//guid = self GetGuid(); 
	//if ( isDefined(guid) )
	//	return guid;
	return self.playername;
}

function set_player_data(name,value)
{
	id = self get_player_unique_id();
	if(!isdefined(world.playerdata))world.playerdata=[];
	if(!isdefined(world.playerdata[id]))world.playerdata[id]=[];
	world.playerdata[id][name]=value;
}

function get_player_data(name,defval)
{
	id = self get_player_unique_id();
	if ( IsDefined(world.playerdata) && IsDefined(world.playerdata[id]) && IsDefined(world.playerdata[id][name]) )
		return world.playerdata[id][name];
	return defval;		
}

function clear_player_data()
{
	id = self get_player_unique_id();
	if ( IsDefined(world.playerdata) && IsDefined( world.playerdata[id]) )
		world.playerdata[id] = [];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CHECKPOINTS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// CHECKPOINT_SAVE()

function checkpoint_save()
{
	if(( isdefined( level.no_checkpoint_save ) && level.no_checkpoint_save ))
		return;
	
	level thread _checkpoint_save();
}

function private _checkpoint_save()
{
	level notify( "checkpoint_save" );
	level endon( "checkpoint_save" );
	
	wait 0.25;	// don't save on the same frame as lots of other stuff happening
	
	CheckpointCreate();
	
	// Don't commit this checkpoint if save is restored
	level endon( "save_restore" );
	
	wait 7;
	
	CheckpointCommit();
}

// CHECKPOINT_SAVE_ASAP()

function checkpoint_save_asap()
{
	if(( isdefined( level.no_checkpoint_save ) && level.no_checkpoint_save ))
		return;
	
	level thread _checkpoint_save_asap();
}

function private _checkpoint_save_asap()
{
	level notify( "checkpoint_save" );
	level endon( "checkpoint_save" );
	level endon( "save_restore" );

	CheckpointCreate();
	
	{wait(.05);};
	
	{wait(.05);};
	
	CheckpointCommit();
}

function checkpoint_trigger()
{
	self endon( "death" );
	self waittill( "trigger" );
	checkpoint_save();
}

// TODO: PROTOTYPE - used in vengeance only currently

// CHECKPOINT_SAVE_SAFE() - 

function checkpoint_save_safe()
{
	level thread _checkpoint_save_safe();
}

function private _checkpoint_save_safe()
{
    level notify( "_checkpoint_save_safe" );
    level endon( "_checkpoint_save_safe" );
	level endon( "save_restore" );
    level endon( "kill_save" );

	level thread util::delayed_notify( "kill_save", 10.0 );

	while ( 1 )
	{		
		if ( save_safe_check() )
		{
			CheckpointCreate();
			
			{wait(.05);};
			
			{wait(.05);};
			
			if ( save_safe_check() )
			{
				CheckpointCommit();
				return;
			}
		}
		
		wait 0.5;
	}
}

function save_safe_check()
{
	if(( isdefined( level.no_checkpoint_save ) && level.no_checkpoint_save ))
		return false;
	
	if ( ( isdefined( level.missionfailed ) && level.missionfailed ) )
		return false;
	
	if ( level clientfield::get( "cybercom_disabled" ) == 1 )
	{
		// FAIL: cybercom menu disabled
		return false;
	}	

	// player checks
	foreach ( player in level.players )
	{
		if ( !( player _save_safe_check_player() ) )
			return false;
	}

	// ai checks
	foreach ( ai in GetAITeamArray( "axis" ) )
	{
		if ( !( ai _save_safe_check_ai() ) )
			return false;
	}

	// level specific checks	
	foreach ( func in level._extra_save_safe_checks )
	{
		if ( !level [[ func ]]() )
			return false;
	}

	return true;
}

function private _save_safe_check_player() // self = player
{
	healthFraction = 1.0;
	if ( isDefined( self.health ) && isDefined( self.maxhealth ) && self.maxhealth > 0 )
		healthFraction = self.health / self.maxhealth;
	if ( healthFraction < 0.5 )
	{
		// FAIL: too low on health
		return false;
	}
	
	if ( self clientfield::get_to_player( "cybercom_disabled" ) == 1 )
	{
		// FAIL: cybercom menu disabled
		return false;
	}
	
	if ( self IsMeleeing() )
	{
		// FAIL: in the middle of melee
		return false;
	}

	if ( self IsThrowingGrenade() )
	{
		// FAIL: throwing a grenade
		return false;
	}

	if ( self IsFiring() )
	{
		// FAIL: firing gun
		return false;
	}
		
	if ( self util::isFlashed() )
	{
		// FAIL: flashbanged and cannot see
		return false;
	}
	
	if ( self laststand::player_is_in_laststand() )
	{
		// FAIL: player_is_in_laststand
		return false;
	}

	grenadeProximity = self _save_safe_grenade_proximity();
	if ( grenadeProximity >= 0 && grenadeProximity < 360 )
	{
		// FAIL: standing next to live grenade
		return false;
	}

	// make sure at least one weapon has > 10% ammo
	foreach ( weapon in self GetWeaponsList() )
    {
	    fraction = self GetFractionMaxAmmo( weapon );
	    if ( fraction > 0.1 )
		    return( true );
    }

	// FAIL
	return false;
}

function private _save_safe_check_ai() // self = axis actor or vehicle
{
	if ( !isDefined( self.enemy ) )
	{
		// SUCCESS: not targeting anything
		return true;
	}

	if ( !isPlayer( self.enemy ) )
	{
		// SUCCESS: not targeting a player
		return true;
	}

	if ( IsDefined( self.melee ) && IsDefined( self.melee.target ) && IsPlayer( self.melee.target ) )
	{
		// FAIL: meleeing a player
		return false;
	}

	playerProximity = self _save_safe_player_proximity();
	if ( playerProximity < 500 )
	{
		// FAIL: dangerously close
		return false;
	}
	else if ( playerProximity > 1000 || playerProximity < 0 )
	{
		// SUCCESS: too far to be a kill threat
		return true;
	}
	else if ( IsActor( self ) && self CanSee( self.enemy ) && self CanShootEnemy() )
	{
		// FAIL: nearby and can shoot player in sight
		return false;
	}

	// SUCCESS
	return true;
}

function private _save_safe_player_proximity() // self = entity
{
	minDist = -1;
	
	foreach ( player in level.activeplayers )
	{
		dist = Distance( player.origin, self.origin );
		if ( dist < minDist || minDist < 0 )
			minDist = dist;
	}
	
	return minDist;
}

function private _save_safe_grenade_proximity() // self = entity
{
	minDist = -1;
	
	foreach ( grenade in GetEntArray() )
	{
		if ( isAI( grenade ) || isPlayer( grenade ) || isVehicle( grenade ) )
			continue;
		
		if ( !isDefined( grenade.weapon ) )
			continue;
		
		if ( !( isdefined( grenade.weapon.isgrenadeweapon ) && grenade.weapon.isgrenadeweapon ) )
			continue;

		dist = Distance( grenade.origin, self.origin );
		
		if ( dist < minDist || minDist < 0 )
			minDist = dist;
	}
	
	return minDist;
}
