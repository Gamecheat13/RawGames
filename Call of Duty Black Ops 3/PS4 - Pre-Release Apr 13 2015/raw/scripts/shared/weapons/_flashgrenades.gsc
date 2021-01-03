#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace flashgrenades;

function init_shared()
{
	level.sound_flash_start = "";
	level.sound_flash_loop = "";
	level.sound_flash_stop = "";
	
	callback::on_connect( &monitorFlash );
}

function flashRumbleLoop( duration )
{
	self endon("stop_monitoring_flash");
	
	self endon("flash_rumble_loop");
	self notify("flash_rumble_loop");
	
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		{wait(.05);};
	}
}


function monitorFlash_Internal(amount_distance, amount_angle, attacker, direct_on_player)
{
	hurtattacker = false;
	hurtvictim = true;
	
	/*
	if ( amount_angle < 0.5 )
	{
		amount_angle = 0.5;
	}
	else if ( amount_angle > 0.8 )
	{
		amount_angle = 1;
	}
	*/
	
		//duration = amount_distance * amount_angle * 6; // TFLAME - 2/7/15 - The angle input is making it unreadable and inconsistent how enemies are being affected based on hitmarker. Removing for now.
	
	duration = amount_distance * 3.25;
	

	min_duration = 2.5; // TFLAME - 2/10/15 - The old calculation here is hard to read and very inconsistent. Lets have a min/max and be done with it.
	max_self_duration = 2.5;

	if ( duration < min_duration )
	{ 
		duration = min_duration;
	}

	if ( isdefined( attacker ) && (attacker == self) ) // TFLAME - 8/1/12 - Don't want tacticals to be too frustrating to use, reducing amount they affect player using them
	{
		duration = duration/2;
	}
	
	if ( duration < 0.25 )
	{
		return;
	}
		
	rumbleduration = undefined;
	
	if ( duration > 2 )
	{
		rumbleduration = 0.75;
	}
	else
	{
		rumbleduration = 0.25;
	}
	
	assert(isdefined(self.team));
	
	if (level.teamBased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
	{
		if(level.friendlyfire == 0) // no FF
		{
			return;
		}
		else if(level.friendlyfire == 1) // FF
		{
		}
		else if(level.friendlyfire == 2) // reflect
		{
			duration = duration * .5;
			rumbleduration = rumbleduration * .5;
			hurtvictim = false;
			hurtattacker = true;
		}
		else if(level.friendlyfire == 3) // share
		{
			duration = duration * .5;
			rumbleduration = rumbleduration * .5;
			hurtattacker = true;
		}
	}
	
	if ( self hasPerk ("specialty_flashprotection") )
	{
		// do a little bit, not a complete negation
		duration *= 0.1;
		rumbleduration *= 0.1;
	}

	if (hurtvictim)
	{
		// No flashbang effect if in vehicle
		if ( self util::mayApplyScreenEffect() || (!direct_on_player && (self IsRemoteControlling()) ) )
		{
			if( isDefined(attacker) && self != attacker &&isPlayer(attacker) )
			{
				attacker AddWeaponStat( GetWeapon( "flash_grenade" ), "hits", 1 );
				attacker AddWeaponStat( GetWeapon( "flash_grenade" ), "used", 1 );
			}
			self thread applyFlash(duration, rumbleduration, attacker);
		}
	}
	
	if (hurtattacker)
	{
		// No flashbang effect if in vehicle
		if ( attacker util::mayApplyScreenEffect() )
			attacker thread applyFlash(duration, rumbleduration, attacker);
	}
}

function monitorFlash()
{
	self endon("disconnect");
	self endon ("killFlashMonitor");
	
	self.flashEndTime = 0;
	while(1)
	{
		self waittill( "flashbang", amount_distance, amount_angle, attacker );
		
		if ( !isalive( self ) )
		{
			continue;
		}
	
		self monitorFlash_Internal(amount_distance, amount_angle, attacker, true);
	}
}

function monitorRCBombFlash()
{
	self endon("death");
	self.flashEndTime = 0;
	while(1)
	{
		self waittill( "flashbang", amount_distance, amount_angle, attacker );
		
		driver = self getseatoccupant(0);
		
		if ( !isdefined(driver) || !isalive( driver ) )
		{
			continue;
		}

		driver monitorFlash_Internal(amount_distance, amount_angle, attacker, false);
	}
}

function applyFlash(duration, rumbleduration, attacker)
{
	// wait for the highest flash duration this frame,
	// and apply it in the following frame
	
	if (!isdefined(self.flashDuration) || duration > self.flashDuration)
	{
		self.flashDuration = duration;
	}
	
	if (!isdefined(self.flashRumbleDuration) || rumbleduration > self.flashRumbleDuration)
	{
		self.flashRumbleDuration = rumbleduration;
	}
	
	self thread playFlashSound( duration );
	
	wait .05;
	
	if (isdefined(self.flashDuration)) 
	{
		if ( self hasPerk ("specialty_flashprotection") == false )
		{
			self shellshock( "flashbang", self.flashDuration, false );
		}
		self.flashEndTime = getTime() + (self.flashDuration * 1000);
		self.lastFlashedBy = attacker;
	}
	
	if (isdefined(self.flashRumbleDuration)) {
		self thread flashRumbleLoop( self.flashRumbleDuration ); //TODO: Non-hacky rumble.
	}

	self.flashDuration = undefined;
	self.flashRumbleDuration = undefined;
}

function playFlashSound( duration )
{	
	self endon( "death" );
	self endon( "disconnect" );

	flashSound = spawn ("script_origin",(0,0,1));
	flashSound.origin = self.origin;
	flashSound linkTo( self );
	flashSound thread deleteEntOnOwnerDeath( self );
	
	flashSound playsound( level.sound_flash_start );
	flashSound playLoopSound ( level.sound_flash_loop );
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	flashSound playsound( level.sound_flash_start );
	flashSound StopLoopSound( .5);
    wait(0.5);

    flashSound notify ( "delete" );
	flashSound delete();
}

function deleteEntOnOwnerDeath( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}

/*util::isFlashbanged()
{
	return isdefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}
*/