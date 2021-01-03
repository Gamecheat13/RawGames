#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
                                            
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace oob;








function autoexec __init__sytem__() {     system::register("out_of_bounds",&__init__,undefined,undefined);    }		

function __init__()
{
	level.oob_triggers = [];
	
	level.oob_timelimit_ms = GetDvarInt( "oob_timelimit_ms", 5000 );
	level.oob_damage_interval_ms = GetDvarInt( "oob_damage_interval_ms", 1000 );
	level.oob_damage_interval_sec = level.oob_damage_interval_ms / 1000;
	level.oob_damage_per_interval = GetDvarInt( "oob_damage_per_interval", 10 );
	
	hurt_triggers = GetEntArray( "trigger_out_of_bounds","classname" );
	
	foreach( trigger in hurt_triggers )
	{
		trigger.oob_players = [];
		if ( !isdefined( level.oob_triggers ) ) level.oob_triggers = []; else if ( !IsArray( level.oob_triggers ) ) level.oob_triggers = array( level.oob_triggers ); level.oob_triggers[level.oob_triggers.size]=trigger;;
		trigger thread waitForPlayerTouch();
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
	
	self clientfield::set_to_player( "out_of_bounds", 0 );
	self setClientUIVisibilityFlag( "hud_visible", 1 );
	self.oob_start_time = -1;
	self notify( "oob_exit" );
}

function waitForPlayerTouch()
{
	while( true )
	{
		self waittill( "trigger", player );
	
		if( IsPlayer( player ) && !player IsOutOfBounds() )
		{
			player.oob_start_time = GetTime();
			
			player.oob_LastValidPlayerLoc = player.origin;
			player.oob_LastValidPlayerDir = VectorNormalize(player GetVelocity());
			
			player setClientUIVisibilityFlag( "hud_visible", 0 );
			player thread watchForLeave( self );
			player thread watchForDeath( self );
			player thread watchOOBDamage( self );
		}
	}
}

function GetDistanceFromLastValidPlayerLoc(trigger)
{
	if(isdefined(self.oob_LastValidPlayerDir) && self.oob_LastValidPlayerDir != (0, 0, 0))
	{
		vecToPlayerLocFromOrigin = self.origin - self.oob_lastValidPlayerLoc;
		distance = VectorDot(vecToPlayerLocFromOrigin, self.oob_LastValidPlayerDir);
	}
	else
	{
		distance = Distance(self.origin, self.oob_lastValidPlayerLoc);
	}
	
	if(distance < 0)
		distance = 0;
	
	if(distance > 400)
		distance = 400;
	
	return distance / 400;
}

function UpdateVisualEffects(trigger)
{
	timeRemaining = (level.oob_timelimit_ms - (GetTime() - self.oob_start_time));
			
	oob_effectValue = 0;
	
	if(timeRemaining <= 1000)
	{
		if(!isdefined(self.oob_lastEffectValue))
		{
			self.oob_lastEffectValue = GetDistanceFromLastValidPlayerLoc(trigger);
		}
		
		time_val = 1 - (timeRemaining / 1000);
		
		if(time_val > 1)
			time_val = 1;
		
		oob_effectValue = self.oob_lastEffectValue + (1 - self.oob_lastEffectValue) * time_val;
	}
	else
	{
		oob_effectValue = GetDistanceFromLastValidPlayerLoc(trigger);
		
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

function watchForLeave( trigger )
{
	self endon( "oob_exit" );
	self endon( "death" );
	
	while( true )
	{
		if( self IsTouchingAnyOOBTrigger() )
		{
			UpdateVisualEffects(trigger);
			
			if( ( self.oob_start_time + level.oob_timelimit_ms ) < GetTime() )
			{
				self DoDamage( 999, self.origin, self, self, "none", "MOD_TRIGGER_HURT" );
			}
		}
		else
		{
			self ResetOOBTimer();
		}
		
		wait( 0.1 );
	}
}

function watchForDeath( trigger )
{
	self endon( "disconnect" );	
	self endon( "oob_exit" );
	
	self waittill( "death" );

	self ResetOOBTimer();
}

function watchOOBDamage( trigger )
{
	self endon( "oob_exit" );
	self endon( "death" );
	
	if( level.oob_damage_interval_sec < 1 )
	{
		return;
	}
	
	while( true )
	{
		wait( level.oob_damage_interval_sec );
		self DoDamage( level.oob_damage_per_interval, self.origin, self, self, "none", "MOD_TRIGGER_HURT" );
	}
}
