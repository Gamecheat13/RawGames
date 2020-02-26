
#include clientscripts\mp\_utility;

init_vehicles()
{
	// MikeD (06/14/07): Added aircraft
	init_aircraft_list();	

	// MikeD (4/3/2008): Added boats
	init_boat_list();
	
	level.vehicles_inited = true;
}

init_aircraft_list()
{
	level.aircraft_list = [];	
	level.aircraft_list[ "player_corsair" ] = true;
	level.aircraft_list[ "rufe" ] = true;
	level.aircraft_list[ "corsair" ] = true;
	
	//-- GavinL (11/12/2007): Added planes specific for use in PBY (aka The Flying Level)
	level.aircraft_list[ "zero" ] = true;                                                  
	level.aircraft_list[ "pby" ] = true;
	level.aircraft_list[ "pby_blackcat" ] = true;
		
	// MikeD (8/13/2007): Removed until we set it up better, currently this is intended only for the FLY level.

	//level.aircraft_list[ "stuka" ] = true;
	level.aircraft_list[ "jap_gunboat" ] = true;
	
	level.aircraft_list[ "il2" ] = true;
		
}

init_boat_list()
{
	level.boat_list = [];	
	level.boat_list[ "rubber_raft" ] = true;
	level.boat_list[ "jap_ptboat" ] = true;
	level.boat_list[ "jap_shinyo" ] = true;
	level.boat_list[ "jap_merchant_ship" ] = true;
}


is_aircraft()
{
	return isdefined( level.aircraft_list[self.vehicletype] );
}

is_boat()
{
	return IsDefined( level.boat_list[self.vehicletype] );
}

vehicle_rumble(localClientNum)
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
		if( (distancesquared(self.origin, getlocalplayers()[localClientNum].origin) > radius_squared) || self getspeed() < 35 )
		{
			wait(0.2); 
			continue; 
		}

		if(isdefined(self.rumbleon) && !self.rumbleon)
		{
			wait(0.2);
			continue;			
		}

		leftTreadHealth = self getlefttreadhealth();
		rightTreadHealth = self getrighttreadhealth();
		if ( ( leftTreadHealth < .7 ) || ( rightTreadHealth < .7 ) )
		{
			self PlayRumbleLoopOnEntity( localClientNum, "tank_damaged_rumble_mp" );
		}
		else
		{
			self PlayRumbleLoopOnEntity( localClientNum, level.vehicle_rumble[ type ].rumble );
		}

		while((distancesquared(self.origin, getlocalplayers()[localClientNum].origin) < radius_squared) && (self getspeed() > 5))
		{
			//self earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + randomfloat( self.rumble_randomaditionaltime ) );
		}


		self StopRumble( localClientNum, level.vehicle_rumble[ type ].rumble );
		
	}
	
}

vehicle_treads(localClientNum)
{
	if ( !isdefined( level._vehicle_effect ) )
	{	
		level._vehicle_effect = [];
	}

	if ( !isdefined( level.vehicles_inited ) || !isdefined( level.vehicle_treads ) )
	{
		return;
	}
	
	// dguzzo 6/2/08 some vehicles we don't want treadfx on
   	if( isdefined( level.vehicle_treads[ self.vehicletype ] ) && level.vehicle_treads[ self.vehicletype ] == false )
   	{
   		return; 
	}
	
   	if( self is_aircraft() )
   		return; 

	//if( isdefined( level.tread_override_thread ) )
	//{
	//	self thread [[ level.tread_override_thread ]]( 	"tag_origin", "back_left", ( 160, 0, 0 ) );
	//}
	// SCRIPTER_MOD: JesseS (10/2/2007): special cased buffalo since we're using wake FX
	//else 
	if (self.vehicletype == "buffalo" || self.vehicletype == "amtank" || self.vehicletype == "rubber_raft" || self.vehicletype == "jap_ptboat" || self.vehicletype == "jap_shinyo")
	{
		self thread tread( localClientNum, "tag_wake", "back_left" );	
	}
	else
	{
		self thread tread( localClientNum, "tag_wheel_back_left", "back_left" );
		self thread tread( localClientNum, "tag_wheel_back_right", "back_right" );
	}
}

vehicle_kill_treads_forever()
{
	self notify( "kill_treads_forever" );
}

tread( localClientNum, tagname, side, relativeOffset )
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
			forwardVec = vector_multiply( forwardVec, waitTime );
			playfx( localClientNum, treadfx, effectOrigin, ( 0, 0, 0 ) - forwardVec );
		}
	}
}

treadget( vehicle, side )
{
	// MikeD (4/3/2008): If self is a boat, then return the water treadfx
	if( vehicle is_boat() )
	{
		if( !isdefined( level._vehicle_effect[ vehicle.vehicletype ] ) )
		{
			println( "clientside treadfx not setup for boat type (only needs water): ", vehicle.vehicletype );
			wait 10; 
			return -1; 
		}
		return level._vehicle_effect[vehicle.vehicletype]["water"];
	}

	surface = self getwheelsurface( side );
	if( !isdefined( vehicle.vehicletype ) )
	{
		treadfx = -1; 
		return treadfx; 
	}

	if( !isdefined( level._vehicle_effect[ vehicle.vehicletype ] ) )
	{
		println( "clientside treadfx not setup for vehicle type: ", vehicle.vehicletype );
		wait 10; 
		return -1; 
	}
	
	treadfx = level._vehicle_effect[ vehicle.vehicletype ][ surface ]; 

	//if( surface == "ice" )
	//	self notify( "iminwater" );

	if( !isdefined( treadfx ) )
		treadfx = -1; 

	return treadfx; 
}

vehicle_watch_damage(localClientNum)
{
	self endon( "entityshutdown" );

	if ( !isdefined( level.tread_damage_fx ) || !isdefined( level.tread_damage_fx[ self.vehicletype ] ) 
		|| !isdefined( level.tread_grind_fx ) || !isdefined( level.tread_grind_fx[ self.vehicletype ] ) )
	{
		return;
	}

	keepWatchingLeftTread = true;
	keepWatchingRightTread = true;

	lastLeftTreadHealth = 0;
	lastRightTreadHealth = 0;

	minSparkSpeed = 25;

	while( self GetVehicleHealth() > 0 )
	{
		vehiclespeed = self getspeed();
		leftTreadHealth = self getlefttreadhealth();
		rightTreadHealth = self getrighttreadhealth();

		if( ( leftTreadHealth != lastLeftTreadHealth || rightTreadHealth != lastRightTreadHealth ) && self GetInKillcam( localClientNum ) )
		{
			leftTreadHealth = lastLeftTreadHealth;
			rightTreadHealth = lastRightTreadHealth;
		}
		else
		{
			lastLeftTreadHealth = leftTreadHealth;
			lastRightTreadHealth = rightTreadHealth;
		}

		
		tag = "tag_treads_left";
		if ( leftTreadHealth <= 0.4 )
		{
			if ( isdefined( level.tread_damage_fx[ self.vehicletype ][0] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][0][1] ) )
			{
				playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][0][1], self, tag ); 
			}
			if ( keepWatchingLeftTread && leftTreadHealth <= 0 )
			{
				keepWatchingLeftTread = false;
				if ( isdefined( level.tread_damage_fx[ self.vehicletype ][0] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][0][2] ) )
				{
					playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][0][2], self, tag );
				}
			}
		}
		else if ( leftTreadHealth < 0.7 )
		{
			if ( isdefined( level.tread_damage_fx[ self.vehicletype ][0] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][0][0] ) )
			{
				playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][0][0], self, tag ); 
			}
			if ( isdefined( level.tread_grind_fx[ self.vehicletype ][0] ) && vehiclespeed > minSparkSpeed )
			{
				playfxontag( localClientNum, level.tread_grind_fx[ self.vehicletype ][0], self, tag );
			}
		}
		tag = "tag_treads_right";
		if ( rightTreadHealth <= 0.4 )
		{
			if ( isdefined( level.tread_damage_fx[ self.vehicletype ][1] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][1][1] ) )
			{
				playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][1][1], self, tag ); 
			}
			if ( keepWatchingRightTread && leftTreadHealth <= 0 )
			{
				keepWatchingRightTread = false;
				if ( isdefined( level.tread_damage_fx[ self.vehicletype ][1] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][1][2] ) )
				{
					playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][1][2], self, tag );
				}
			}
		}
		else if ( rightTreadHealth < 0.7 )
		{
			if ( isdefined( level.tread_damage_fx[ self.vehicletype ][1] ) && isdefined( level.tread_damage_fx[ self.vehicletype ][1][0] ) )
			{
				playfxontag( localClientNum, level.tread_damage_fx[ self.vehicletype ][1][0], self, tag ); 
			}
			if ( isdefined( level.tread_grind_fx[ self.vehicletype ][1] ) && vehiclespeed > minSparkSpeed )
			{
				playfxontag( localClientNum, level.tread_grind_fx[ self.vehicletype ][1], self, tag );
			}
		}
		wait( 0.1 );
	}
}

playTankExhaust(localClientNum)
{
	
	self endon( "entityshutdown" );
	self endon( "stop_exhaust_fx" );
	level endon( "stop_exhaust_fx" );
	
	exhaustDelay = 0.1; 
	for( ;; )
	{
  
  		// TODO change to isalive(self) after exes are updated
		if( !isdefined( self ) || !( self isalive() ) )
		{
			return; 
		}
		// self.model can change to the destroyed version if a vehicle is killed  
		else if( !isdefined( level.vehicle_exhaust ) || !isdefined( level.vehicle_exhaust[ self.model ] ) )
		{
			println( "clientside exhaustfx not set up for vehicle model: " + self.model );
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


build_treadfx( type )
{

	// Guzzo
	// level.vttype is set up in build_template, which at this point we won't be bringing over to clientside
	//	if( ! isdefined( type ) )
	//		type = level.vttype; 
	
	clientscripts\mp\_treadfx::main( type );
}


build_exhaust( model, effect, one_exhaust )
{
	println( "building exhaust for " + model );
	if ( !isdefined( level.vehicle_exhaust ) )
	{
		level.vehicle_exhaust = [];
	}
	
	level.vehicle_exhaust[model] = spawnstruct();
	level.vehicle_exhaust[model].exhaust_fx = loadfx( effect );
	
	if( isdefined( one_exhaust ) && one_exhaust )
	{
		level.vehicle_exhaust[ model ].one_exhaust = true;	
	}
	else
	{
		level.vehicle_exhaust[ model ].one_exhaust = false;		
	}
}

build_gear( vehicletype, model, tag )
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

build_quake( scale, duration, radius, basetime, randomaditionaltime )
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

build_rumble( type, rumble, scale, duration, radius, basetime, randomaditionaltime )
{
	println("*** Client : Building rumble for " + type);
	if( !isdefined( level.vehicle_rumble ) )
		level.vehicle_rumble = []; 
	struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
	assert( isdefined( rumble ) );
	struct.rumble = precacherumble( rumble );
//	struct.rumble = rumble; 
	level.vehicle_rumble[ type ] = struct; 
}


vehicle_variants( localClientNum )
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
