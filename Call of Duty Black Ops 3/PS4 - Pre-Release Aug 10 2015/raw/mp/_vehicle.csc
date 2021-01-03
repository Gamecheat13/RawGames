#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

//Vehicle registration
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_rcbomb;

#namespace vehicle;

function autoexec __init__sytem__() {     system::register("vehicle",&__init__,undefined,undefined);    }

function __init__()
{
	if( !isdefined( level._effect ) )
	{
		level._effect = [];
	}
	level.vehicles_inited = true;
	
	clientfield::register( "vehicle", "timeout_beep", 1, 2, "int",&timeout_beep, !true, !true );
}

function vehicle_rumble(localClientNum)
{
	self endon( "entityshutdown" );
		
	if(!isdefined(level.vehicle_rumble))
		return;
		
	type = self.vehicletype;

	if( !isdefined( level.vehicle_rumble[ type ] ) )
		return; 
		
	rumblestruct = level.vehicle_rumble[ type ]; 
	height = rumblestruct.radius * 2; 
	zoffset = -1 * rumblestruct.radius; 
	
	if( !isdefined( self.rumbleon ) )
		self.rumbleon = true; 
		
	if( isdefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale; 
	else
		self.rumble_scale = 0.15; 

	if( isdefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration; 
	else
		self.rumble_duration = 4.5; 

	if( isdefined( rumblestruct.radius ) )
		self.rumble_radius = rumblestruct.radius; 
	else
		self.rumble_radius = 600; 
	if( isdefined( rumblestruct.basetime ) )
		self.rumble_basetime = rumblestruct.basetime; 
	else
		self.rumble_basetime = 1; 
	if( isdefined( rumblestruct.randomaditionaltime ) )
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime; 
	else
		self.rumble_randomaditionaltime = 1; 

	self.player_touching = 0;

	// This is threaded on each vehicle, per local client - so we only need to be concerned with checking on
	// client that we've been threaded on.

	radius_squared = rumblestruct.radius * rumblestruct.radius;

	while( 1 )
	{
		if( (distancesquared(self.origin, level.localPlayers[localClientNum].origin) > radius_squared) || self getspeed() < 35 )
		{
			wait(0.2); 
			continue; 
		}

		if(isdefined(self.rumbleon) && !self.rumbleon)
		{
			wait(0.2);
			continue;			
		}

		self PlayRumbleLoopOnEntity( localClientNum, level.vehicle_rumble[ type ].rumble );
		
		while((distancesquared(self.origin, level.localPlayers[localClientNum].origin) < radius_squared) && (self getspeed() > 5))
		{
			//self earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + randomfloat( self.rumble_randomaditionaltime ) );
		}

		self StopRumble( localClientNum, level.vehicle_rumble[ type ].rumble );
	}
	
}

function set_static_amount( staticAmount )
{
	driverLocalClient = self GetLocalClientDriver();
	if ( isdefined( driverLocalClient ) )
	{
		driver = GetLocalPlayer( driverLocalClient );
		if ( isdefined( driver ) )
		{
			setfilterpassconstant( driver.localClientNum, 4, 0, 1, staticAmount );
		}
	}
}

function vehicle_variants( localClientNum )
{
	// NOT YET SUPPORTED IN MP
	/*if(isdefined(level.vehicleGearModels))
	{
		if(isdefined(level.vehicleGearModels[self.vehicletype]))
		{
			numGear = level.vehicleGearModels[self.vehicletype].size;
			maxGear = 2;
			if(numGear<maxGear)
			{
				maxGear = numGear;
			}
			maxGear = randomInt(maxGear+1);
			for(i=0;i<maxGear;i++)
			{
				alreadyChosen = true;
				gearChoices[i] = -1;
				while(alreadyChosen)
				{
					alreadyChosen = false;
					gearChoices[i] = randomInt(numGear);
					for(j=0;j<i;j++)
					{
						if(gearChoices[j]==gearChoices[i])
						{
							alreadyChosen = true;
							break;
						}
					}
				}
				self attach(level.vehicleGearModels[self.vehicletype][gearChoices[i]],level.vehicleGearTags[self.vehicletype][gearChoices[i]]);
			}
		}
	}*/
}

function timeout_beep( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	self notify( "timeout_beep" );
	
	if ( !newVal )
	{
		return;
	}

	if ( isdefined( self.killstreakBundle ) )
	{
		beepAlias = self.killstreakBundle.ksTimeoutBeepAlias;
	}
	
	self endon( "entityshutdown" );
	self endon( "timeout_beep" );	
	
	interval = 1;

	if ( newVal == 2 )
	{
		interval = 0.133;
	}
	
	while(1)
	{	
		if ( isdefined( beepAlias ) )
		{
			self PlaySound( localClientNum, beepAlias );
		}
		
		if ( self.timeoutLightsOff === true )
		{
			self vehicle::lights_on( localClientNum );
			self.timeoutLightsOff = false;
		}
		else
		{
			self vehicle::lights_off( localClientNum );
			self.timeoutLightsOff = true;
		}
		
		util::server_wait( localClientNum, interval );
		interval = math::clamp( ( interval / 1.17 ), 0.1, 1 );
	}
}