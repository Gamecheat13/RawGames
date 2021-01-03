#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

//Vehicle registration
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_missile_swarm;
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

function vehicle_treads(localClientNum)
{
	if ( !isdefined( self.treadfx ) )
	{	
		self.treadfx = [];
	}

	if ( !isdefined( level.vehicles_inited ) )
	{
		return;
	}
	
	self thread tread( localClientNum, "tag_wheel_back_left", "back_left" );
	self thread tread( localClientNum, "tag_wheel_back_right", "back_right" );
}

function vehicle_kill_treads_forever()
{
	self notify( "kill_treads_forever" );
}

function tread( localClientNum, tagname, side, relativeOffset )
{
	self endon( "entityshutdown" );
	self endon( "kill_treads_forever" );
	level endon( "kill_treads_forever" );
	
	treadfx = treadget( self, side );
	
	if( treadfx == -1 )
	{
		return;
	}
	
	for( ;; )
	{
		speed = self getspeed();
		if( speed < 25 )
		{
			wait 0.1; 
			continue; 
		}
		waitTime = ( 1 / speed );
		waitTime = ( waitTime * 35 );
		if( waitTime < 0.1 )
			waitTime = 0.1; 
		else if( waitTime > 0.3 )
			waitTime = 0.3; 
		wait waitTime; 
		lastfx = treadfx; 
		treadfx = treadget( self, side );
		if( treadfx != -1 )
		{
			ang = self getTagAngles( tagname );
			forwardVec = anglestoforward( ang );
			effectOrigin = self getTagOrigin( tagname );
			forwardVec = VectorScale( forwardVec, waitTime );
			playfx( localClientNum, treadfx, effectOrigin, ( 0, 0, 0 ) - forwardVec );
		}
	}
}

function treadget( vehicle, side )
{

	surface = self getwheelsurface( side );

	if( !isdefined( vehicle.treadfx ) )
	{
	/#	println( "clientside treadfx not setup for vehicle type: ", vehicle.vehicletype );	#/
		wait 10; 
		return -1; 
	}
	
	treadfx = vehicle.treadfx[ surface ]; 

	//if( surface == "ice" )
	//	self notify( "iminwater" );

	if( !isdefined( treadfx ) )
		treadfx = -1; 

	return treadfx; 
}

function playTankExhaust(localClientNum)
{
	
	self endon( "entityshutdown" );
	self endon( "stop_exhaust_fx" );
	level endon( "stop_exhaust_fx" );
	
	exhaustDelay = 0.1; 
	for( ;; )
	{
  
		if( !isdefined( self ) || !( isalive(self) ) )
		{
			return; 
		}
		// self.model can change to the destroyed version if a vehicle is killed  
		else if( !isdefined( level.vehicle_exhaust ) || !isdefined( level.vehicle_exhaust[ self.model ] ) )
		{
		/#	println( "clientside exhaustfx not set up for vehicle model: " + self.model );	#/
			return; 
		}		
		
		tag_left_orig = self gettagorigin( "tag_engine_left" );
		tag_left_angles = self gettagangles( "tag_engine_left" );

		if ( self getspeed() > 0 )
		{

			playfx( localClientNum, level.vehicle_exhaust[ self.model ].exhaust_fx, tag_left_orig, anglestoforward( tag_left_angles ) ); 		
	
			// not all vehicles have two exhaust vents
			if( !level.vehicle_exhaust[ self.model ].one_exhaust )
			{
				tag_right_orig = self gettagorigin( "tag_engine_right" );
				tag_right_angles = self gettagangles( "tag_engine_right" );				
				
				playfx( localClientNum, level.vehicle_exhaust[ self.model ].exhaust_fx, tag_right_orig, anglestoforward( tag_right_angles ) ); 
			}
		}
	
		wait exhaustDelay; 
	}
}


function build_exhaust( model, effect, one_exhaust )
{
/#	println( "building exhaust for " + model );		#/
	if ( !isdefined( level.vehicle_exhaust ) )
	{
		level.vehicle_exhaust = [];
	}
	
	level.vehicle_exhaust[model] = spawnstruct();
	level.vehicle_exhaust[model].exhaust_fx = effect;
	
	if( isdefined( one_exhaust ) && one_exhaust )
	{
		level.vehicle_exhaust[ model ].one_exhaust = true;	
	}
	else
	{
		level.vehicle_exhaust[ model ].one_exhaust = false;		
	}
}

function build_gear( vehicletype, model, tag )
{
	index = 0;
	if(isdefined(level.vehicleGearModels))
	{
		if(isdefined(level.vehicleGearModels[vehicletype]))
		{
			index = level.vehicleGearModels[vehicletype].size;
		}
	}
	level.vehicleGearModels[vehicletype][index] = model;
	level.vehicleGearTags[vehicletype][index] = tag;
}

function build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
	struct = spawnstruct();
	struct.scale = scale; 
	struct.duration = duration; 
	struct.radius = radius; 
	if( isdefined( basetime ) )
		struct.basetime = basetime; 
	if( isdefined( randomaditionaltime ) )
		struct.randomaditionaltime = randomaditionaltime; 
	return struct; 
}

function build_rumble( type, rumble, scale, duration, radius, basetime, randomaditionaltime )
{
/#	println("*** Client : Building rumble for " + type);	#/
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	assert( isdefined( rumble ) );
	struct.rumble = rumble; 
	level.vehicle_rumble[ type ] = struct; 
}

function set_static_amount( staticAmount )
{
	driverLocalClient = self GetLocalClientDriver();
	if ( isdefined( driverLocalClient ) )
	{
		driver = GetLocalPlayer( driverLocalClient );
		if ( isdefined( driver ) )
		{
			driver Set_Filter_Pass_Constant( 4, 0, 1, staticAmount );
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
