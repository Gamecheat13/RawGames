#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
                                             
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#namespace oob;

 //Change the value in the _oob.csc file to match this one



 //Change the value in the _oob.csc file to match this one


	
	




function autoexec __init__sytem__() {     system::register("out_of_bounds",&__init__,undefined,undefined);    }		

function __init__()
{
	level.oob_triggers = [];
	
	if(SessionModeIsMultiplayerGame())
	{
		level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 3000 );
		level.oob_damage_interval_ms = GetDvarInt( "oob_damage_interval_ms", 3000 );
		level.oob_damage_per_interval = GetDvarInt( "oob_damage_per_interval", 999 );
	}
	else
	{
		level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 6000 );
		level.oob_damage_interval_ms = GetDvarInt( "oob_damage_interval_ms", 1000 );
		level.oob_damage_per_interval = GetDvarInt( "oob_damage_per_interval", 5 );
	}
	
	level.oob_damage_interval_sec = level.oob_damage_interval_ms / 1000;
	
	hurt_triggers = GetEntArray( "trigger_out_of_bounds","classname" );
	
	foreach( trigger in hurt_triggers )
	{
		trigger.oob_players = [];
		if ( !isdefined( level.oob_triggers ) ) level.oob_triggers = []; else if ( !IsArray( level.oob_triggers ) ) level.oob_triggers = array( level.oob_triggers ); level.oob_triggers[level.oob_triggers.size]=trigger;;
		trigger thread waitForPlayerTouch();
		trigger thread waitForCloneTouch();
	}
	
	clientfield::register( "toplayer", "out_of_bounds", 1, 5, "int" );
}

function IsOutOfBounds()
{
	if( !IsDefined( self.oob_start_time ) )
	{
		return false;
	}
	
	return self.oob_start_time != -1;
}

function IsTouchingAnyOOBTrigger()
{
	triggers_to_remove = [];
	result = false;
	
	foreach( trigger in level.oob_triggers )
	{
		if( !isdefined( trigger ) )
		{
			if ( !isdefined( triggers_to_remove ) ) triggers_to_remove = []; else if ( !IsArray( triggers_to_remove ) ) triggers_to_remove = array( triggers_to_remove ); triggers_to_remove[triggers_to_remove.size]=trigger;;
			continue;
		}
		
		if( !trigger IsTriggerEnabled() )
		{
			continue;
		}
		
		if( self IsTouching( trigger ) )
		{
			result = true;
			break;
		}
	}
	
	foreach( trigger in triggers_to_remove )
	{
		ArrayRemoveValue( level.oob_triggers, trigger );
	}
	
	triggers_to_remove = [];
	triggers_to_remove = undefined;
	
	return result;
}

function ResetOOBTimer()
{
	self.oob_lastValidPlayerLoc = undefined;
	self.oob_LastValidPlayerDir = undefined;
	self clientfield::set_to_player( "out_of_bounds", 0 );
	self setClientUIVisibilityFlag( "hud_visible", 1 );
	self.oob_start_time = -1;
	self notify( "oob_exit" );
}

function waitForCloneTouch()
{
	while( true )
	{
		self waittill( "trigger", clone );
	
		if( IsActor( clone ) && IsDefined( clone.isAiClone ) && clone.isAiClone && (!clone IsPlayingAnimScripted()) )
		{
			clone notify( "clone_shutdown" );
		}
	}
}

function GetAdjusedPlayer( Player )
{
	if( isdefined(player.hijacked_vehicle_entity) && IsAlive(player.hijacked_vehicle_entity) )
	{
		return player.hijacked_vehicle_entity;
	}
	
	return Player;
}

function waitForPlayerTouch()
{
	while( true )
	{
		self waittill( "trigger", entity );
	
		if( !IsPlayer(entity) && !(IsVehicle(entity) && ( isdefined( entity.hijacked ) && entity.hijacked ) && isdefined(entity.owner) && IsAlive(entity)) )
			continue;
		
		if(IsPlayer(entity))
		{
			player = entity;
		}
		else
		{
			vehicle = entity;
			player = vehicle.owner;
		}
		
		if( !(player IsOutOfBounds()) && !(player IsPlayingAnimScripted()) && !( isdefined( player.OOBDisabled ) && player.OOBDisabled ) )
		{
			player notify( "oob_enter" );
			
			player.oob_start_time = GetTime();
			
			player.oob_LastValidPlayerLoc = entity.origin;
			player.oob_LastValidPlayerDir = VectorNormalize( entity GetVelocity() ) ;
			
			player setClientUIVisibilityFlag( "hud_visible", 0 );
			player thread watchForLeave( self, entity );
			player thread watchForDeath( self, entity );
		}
	}
}

function GetDistanceFromLastValidPlayerLoc(trigger, entity)
{
	if(isdefined(self.oob_LastValidPlayerDir) && self.oob_LastValidPlayerDir != (0, 0, 0))
	{
		vecToPlayerLocFromOrigin = entity.origin - self.oob_lastValidPlayerLoc;
		distance = VectorDot(vecToPlayerLocFromOrigin, self.oob_LastValidPlayerDir);
	}
	else
	{
		distance = Distance(entity.origin, self.oob_lastValidPlayerLoc);
	}
	
	if(distance < 0)
		distance = 0;
	
	if(distance > 400)
		distance = 400;
	
	return distance / 400;
}

function UpdateVisualEffects( trigger, entity )
{
	timeRemaining = (level.oob_timelimit_ms - (GetTime() - self.oob_start_time));
			
	oob_effectValue = 0;
	
	if(timeRemaining <= 1000)
	{
		if(!isdefined(self.oob_lastEffectValue))
		{
			self.oob_lastEffectValue = GetDistanceFromLastValidPlayerLoc(trigger, entity);
		}
		
		time_val = 1 - (timeRemaining / 1000);
		
		if(time_val > 1)
			time_val = 1;
		
		oob_effectValue = self.oob_lastEffectValue + (1 - self.oob_lastEffectValue) * time_val;
	}
	else
	{
		oob_effectValue = GetDistanceFromLastValidPlayerLoc(trigger, entity);
		
		if(oob_effectValue > 0.9)
		{
			oob_effectValue = 0.9;
		}
		else if(oob_effectValue < 0.05)
		{
			oob_effectValue = 0.05;
		}
	}
	
	if(oob_effectValue > 1)
		oob_effectValue = 1;
	
	oob_effectValue = ceil(oob_effectValue * 31); //5 bits 2^5 = 32 (so 31 values)
	
	self clientfield::set_to_player( "out_of_bounds", int(oob_effectValue) );
}

function watchForLeave( trigger, entity )
{
	self endon( "oob_exit" );
	entity endon( "death" );
	
	while( true )
	{
		if( entity IsTouchingAnyOOBTrigger() )
		{
			UpdateVisualEffects( trigger, entity );
			
			if( ( self.oob_start_time + level.oob_timelimit_ms ) < GetTime() )
			{
				if( IsPlayer(entity) )
				{
					entity  DisableInvulnerability();
                    entity.ignoreme = false;
                    entity.laststand = undefined;
                    
                    if( isdefined( entity.revivetrigger ) )
                    {
                        entity.reviveTrigger delete();
                    } 
				}
				
				entity DoDamage( entity.health + 10000, entity.origin, undefined, undefined, "none", "MOD_TRIGGER_HURT" );
			}
		}
		else
		{
			self ResetOOBTimer();
		}
		
		wait( 0.1 );
	}
}

function watchForDeath( trigger, entity )
{
	self endon( "disconnect" );
	self endon( "oob_exit" );	
	
	util::waittill_any_ents_two( self, "death", entity, "death" ); 

	self ResetOOBTimer();
}

function disablePlayerOOB( disabled )
{
	if ( disabled )
	{
		self ResetOOBTimer();
		self.OOBDisabled = true;
	}
	else
	{
		self.OOBDisabled = false;
	}
}
