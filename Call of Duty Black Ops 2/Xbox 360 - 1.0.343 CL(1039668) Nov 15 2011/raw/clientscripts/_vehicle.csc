#include clientscripts\_utility; 

init_vehicles()
{	
	level.vehicles_inited = true; 
}

vehicle_rumble( localClientNum )
{
	self endon( "entityshutdown" ); 
	level endon( "save_restore" ); 
			
	if( !isdefined( self.rumbletype ) || ( self.rumbleradius == 0 ) )
	{
		return; 
	}
	
	// Init undefined variables
	if( !isdefined( self.rumbleon ) )
	{
		self.rumbleon = true; 
	}		

// need to decide if these variables should readOnly or not...
//	if( !isdefined( self.rumblescale ) )
//	{
//		self.rumblescale = 0.15; 
//	}
//	if( !isdefined( self.rumbleduration ) )
//	{
//		self.rumbleduration = 4.5; 
//	}
//	if( !isdefined( self.rumbleradius ) )
//	{
//		self.rumbleradius = 600; 
//	}
//	if( !isdefined( self.rumblebasetime ) )
//	{
//		self.rumblebasetime = 1; 
//	}
//	if( !isdefined( self.rumbleadditionaltime ) )
//	{
//		self.rumbleadditionaltime = 1; 
//	}

	height = self.rumbleradius * 2; 
	zoffset = -1 * self.rumbleradius; 

	self.player_touching = 0; 

	// This is threaded on each vehicle, per local client - so we only need to be concerned with checking on
	// client that we've been threaded on.

	radius_squared = self.rumbleradius * self.rumbleradius; 
	
	wait 2;		// hack to let the getloaclplayers return a valid local player

	while( 1 )
	{
		if( ( distancesquared( self.origin, level.localPlayers[localClientNum].origin ) > radius_squared ) || self getspeed() == 0 )
		{
			wait( 0.2 ); 
			continue; 
		}

		if( isdefined( self.rumbleon ) && !self.rumbleon )
		{
			wait( 0.2 ); 
			continue; 			
		}

		self PlayRumbleLoopOnEntity( localClientNum, self.rumbletype ); 

		while( ( distancesquared( self.origin, level.localPlayers[localClientNum].origin ) < radius_squared ) &&( self getspeed() > 0 ) )
		{
			self earthquake( self.rumblescale, self.rumbleduration, self.origin, self.rumbleradius ); // scale duration source radius
			wait( self.rumblebasetime + randomfloat( self.rumbleadditionaltime ) ); 
		}

		self StopRumble( localClientNum, self.rumbletype ); 		
	}	
}

vehicle_treads( localClientNum )
{
	waittillframeend; //-- make sure that in the same snapshot the flag gets processed before the vehicle
	
	//PrintLn("****CLIENT:: Creating TreadFX: " + self GetEntityNumber());
	if( !isdefined( level.vehicles_inited ) || !isdefined(self.treadfx) )
	{
		return; 
	}
	
	if( IsDefined(self.csf_no_tread) && self.csf_no_tread ) //-- set by clientside flag
	{
		return;
	}
	
	if( self is_plane() )
	{
		return; 
	}

	if( self.vehicleclass == "boat" && self.vehicletype != "inc_base_jump_spotlight")
	{
		self thread wake( localClientNum, "tag_wake" ); 	
		self thread splash( localClientNum );
		self thread splash_small();
	}
	else if ( self.vehicleclass == "motorcycle" )
	{
		self thread tread( localClientNum, "tag_wheel_back", "back_left" ); 
	}
	else
	{
		self thread tread( localClientNum, "tag_wheel_back_left", "back_left" ); 
		self thread tread( localClientNum, "tag_wheel_back_right", "back_right" ); 
	}
}

vehicle_kill_treads_forever()
{
	//PrintLn("****CLIENT:: killing the tread_fx");
	self notify( "kill_treads_forever" ); 
}

get_throttle_effect( throttle )
{
	if( IsDefined(self.throttlefx) )
	{
		if( throttle < 0.3 )
		{
			return self.throttlefx[0];
		}
		else if( throttle < 0.7 )
		{
			return self.throttlefx[1];
		}
		else
		{
			return self.throttlefx[2];
		}
	}
	return undefined;
}

wake_mon(localClientNum)
{
	self waittill("kill_treads_forever");
	level endon( "save_restore" ); 
	self endon( "entityshutdown" ); 
			
	if(IsDefined(self.wake_fxHandle))
	{
			deletefx( localClientNum, self.wake_fxHandle, 0 );
			self.wake_fxHandle = undefined;		
	}
}

wake( localClientNum, tagname )
{
	self endon( "entityshutdown" ); 
	self endon( "kill_treads_forever" ); 
	level endon( "kill_treads_forever" ); 
	level endon( "save_restore" ); 
	
	treadfx = treadget( self, "back_left" ); 
	if( treadfx == -1 )
	{
		return; 
	}
	
	self thread wake_mon(localClientNum);
	
	self.wake_fxHandle = undefined;
	wakeState = -1; 	// 0 - reverse, 1 - idle, 2,3,4 are speeds going forward
	for( ;; )
	{
		
		// handle the wake effect
		speed = self getspeed();
		if( !isdefined(self.wakefx) )	// use the vehicle GDT
		{
			if( speed < 50 )
			{
				if( IsDefined(self.wake_fxHandle) )
				{
					deletefx( localClientNum, self.wake_fxHandle, 0 );
					self.wake_fxHandle = undefined;
				}
			}
			else if( !IsDefined(self.wake_fxHandle) )
			{
				self.wake_fxHandle = PlayFXOnTag( localClientNum, treadfx, self, tagname );
			}
		}
		else		// use the custom fx setup
		{
			newState = 0;
			if( speed > 150 && self getthrottle() < 0 )
			{
				newState = 0;
			}
			else if( speed < 70 )
			{
				newState = 1;
			}
			else if( speed < 300 )
			{
				newState = 2;
			}
			else if( speed < 600 )
			{
				newState = 3;
			}
			else
			{
				newState = 4;
			}
				
			if( wakeState != newState )
			{
				if( IsDefined(self.wake_fxHandle) )
				{
					deletefx( localClientNum, self.wake_fxHandle, 0 );
					self.wake_fxHandle = undefined;
				}

				wakeState = newState;
				fx = self.wakefx[wakeState];
				self.wake_fxHandle = PlayFXOnTag( localClientNum, fx, self, tagname );
				// iprintlnbold( "New state " + wakeState );
			}
		}
		
		// handle the throttle effect
		throttle = self getthrottle();
		if( throttle > 0.0 )
		{
			throttleEffect = self get_throttle_effect( throttle );
			if( IsDefined( throttleEffect ) )
			{
				effectOrigin = self getTagOrigin( tagname ); 
				fwd = self gettagforwardvector( tagname );
				playfx( localClientNum, throttleEffect, effectOrigin, fwd ); 
			}
		}
		
		wait 0.1;
	}
}

splash( localClientNum )
{
	self endon( "entityshutdown" ); 
	self endon( "kill_treads_forever" ); 
	level endon( "kill_treads_forever" ); 
	level endon( "save_restore" ); 
	
	if( !IsDefined( self.splashfx ) )
	{
		return;
	}
	
	wasinwater = true;
	offset = (0,0,-10);
	last_water_check_pos = self.origin + anglestoforward( self.angles ) * 100 + offset;
	
	for( ;; )
	{
		wait(0.5);
		
		// check for the splash effect
		water_check_pos = self.origin + anglestoforward( self.angles ) * 100 + offset;
		water_height = getwaterheight( water_check_pos );
		isinwater = water_check_pos[2] < water_height;
		vertical_speed = water_check_pos[2] - last_water_check_pos[2];		
		//iprintlnbold ("vertical_speed is " + vertical_speed);
		
		if( !wasinwater && isinwater )
		{
			vertical_speed = water_check_pos[2] - last_water_check_pos[2];
			if( self getspeed() > 300 && vertical_speed < -2 )
			{
				splashOrigin = self getTagOrigin( "snd_bow_center");
				effectOrigin = self getTagOrigin( "tag_wake" ); 
				fwd = self gettagforwardvector( "tag_wake" );
				playfx( localClientNum, self.splashfx, effectOrigin, fwd );
				
				id = playsound( 0, "veh_boat_splash", splashOrigin);
			}
	
		}

		wasinwater = isinwater;
		last_water_check_pos = water_check_pos;
	}
}

splash_small()
{
	self endon( "entityshutdown" ); 
	self endon( "kill_treads_forever" ); 
	level endon( "kill_treads_forever" ); 
	level endon( "save_restore" ); 
	
	offset = (0,0,-10);
	
	// randomize the vehicle threads a bit, so they dont all kick in the same frame 
	wait( randomfloat( 0.5 ) ); 	
	
	for( ;; )
	{
		water_check_pos = self.origin + anglestoforward( self.angles ) * 100 + offset;
		wait( 0.5 );
		water_check_pos_2 = self.origin + anglestoforward( self.angles ) * 100 + offset;
		water_height = getwaterheight( water_check_pos );
		isinwater = water_check_pos[2] < water_height;
		vertical_speed = water_check_pos[2] - water_check_pos_2[2];		
		//iprintlnbold ("vertical_speed is " + vertical_speed);
		
		if (isinwater)
		{
			vertical_speed = water_check_pos_2[2] - water_check_pos[2];
			if( self getspeed() > 100 && vertical_speed < -0.6 )
			{
				splashOrigin = self getTagOrigin( "snd_bow_center");
				if( !isdefined(splashOrigin) )
				{
					splashOrigin = self getTagOrigin( "tag_origin" );
					//println( "***SOUND: Can't find snd_bow_center***" );
				}
				
				id = playsound( 0, "veh_boat_splash_small", splashOrigin );
				//iprintlnbold ("vertical_speed is " + vertical_speed);
				
				wait(1.6);
			}
		}	
	}
}

tread( localClientNum, tagname, side, relativeOffset )
{
	self endon( "entityshutdown" ); 
	self endon( "kill_treads_forever" ); 
	level endon( "kill_treads_forever" ); 
	level endon( "save_restore" ); 
	
	treadfx = treadget( self, side ); 
	
	if( treadfx == -1 )
	{
		return; 
	}
	
	// randomize the vehicle threads a bit, so they dont all kick in the same frame 
	wait( randomfloat( 0.5 ) ); 	
	
	for( ;; )
	{
		speed = self getspeed();
		//print3d(self.origin + (0,0,100),"Speed: " + speed,(1,1,1),1,1);
		if( speed == 0 || ( speed > -1 && speed < 1) )
		{
			wait 0.11; 
			continue; 
		}
		
		if( speed > 350 )
		{
			waitTime = 0.1; 
		}
		else if( speed < 166 )
		{
			waitTime = 0.3; 
		}
		else
		{
			waitTime = ( 35 / speed ); 
		}

		wait waitTime; 

		treadfx = treadget( self, side ); 
		
		if( treadfx != -1 )
		{
			forwardVec = self gettagforwardvector( tagname );
			effectOrigin = self getTagOrigin( tagname ); 
			forwardVec = VectorScale( forwardVec, waitTime ); 
			playfx( localClientNum, treadfx, effectOrigin, ( 0, 0, 0 ) - forwardVec ); 
		}
	}
}

treadget( vehicle, side )
{
	// MikeD( 4/3/2008 ): If self is a boat, then return the water treadfx
	if( vehicle.vehicleclass == "boat" )
	{
		if( !isdefined( vehicle.treadfx["water"] ) )
		{
			println( "clientside treadfx not setup for boat type( only needs water ): ", vehicle.vehicletype ); 
			wait 10; 
			return -1; 
		}
		return vehicle.treadfx["water"]; 
	}

	surface = self getwheelsurface( side ); 
	if( !isdefined( vehicle.vehicletype ) )
	{
		treadfx = -1; 
		return treadfx; 
	}

	if( !isdefined( vehicle.treadfx[surface] ) )
	{
		//println( "clientside treadfx not setup for vehicle type: ", vehicle.vehicletype + " (surface: " + surface + ")" ); 
		wait 10; 
		return -1; 
	}
	
	treadfx = vehicle.treadfx[surface]; 

	//if( surface == "ice" )
	//	self notify( "iminwater" ); 

	if( !isdefined( treadfx ) )
	{
		treadfx = -1; 
	}

	return treadfx; 
}



playTankExhaust( localClientNum )
{
	//self endon( "entityshutdown" ); 
	//self endon( "stop_exhaust_fx" ); 
	//level endon( "stop_exhaust_fx" ); 
	//level endon( "save_restore" ); 
	
	if( IsDefined(self.csf_no_exhaust) && self.csf_no_exhaust )
	{
		return;
	}
	
	if( isdefined( self ) && ( self isalive() ) && isdefined( self.exhaust_fx ) )
	{
		PlayFXOnTag( localClientNum, self.exhaust_fx, self, "tag_engine_left" );		
		if( !self.oneexhaust )
			PlayFXOnTag( localClientNum, self.exhaust_fx, self, "tag_engine_right" );		
	}
	
/*	
	for( ;; )
	{
  		// TODO change to isalive( self ) after exes are updated
		if( !isdefined( self ) || !( self isalive() ) )
		{
			return; 
		}
		// self.model can change to the destroyed version if a vehicle is killed  
		else if( !isdefined( self.exhaust_fx ) )
		{
			println( "clientside exhaustfx not set up for vehicle model: " + self.model ); 
			return; 
		}		
		
		tag_left_orig = self gettagorigin( "tag_engine_left" ); 
		fwd_left = self gettagforwardvector( "tag_engine_left" );
		playfx( localClientNum, self.exhaust_fx, tag_left_orig, fwd_left ); 		

		// not all vehicles have two exhaust vents
		if( !self.oneexhaust )
		{
			tag_right_orig = self gettagorigin( "tag_engine_right" ); 
			fwd_right = self gettagforwardvector( "tag_engine_right" );
			playfx( localClientNum, self.exhaust_fx, tag_right_orig, fwd_right ); 
		}
	
		wait exhaustDelay; 
	}
	*/
}

play_exhaust( localClientNum )
{
	// TODO: if necessary, have this check the vehicle type and play the appropriate exhaust
	//self endon( "entityshutdown" ); 
	//self endon( "stop_exhaust_fx" ); 
	//level endon( "stop_exhaust_fx" ); 
	//level endon( "save_restore" ); 
	
	if( IsDefined(self.csf_no_exhaust) && self.csf_no_exhaust )
	{
		return;
	}
	
	if( isdefined( self ) && ( self isalive() ) && isdefined( self.exhaust_fx ) )
	{
		PlayFXOnTag( localClientNum, self.exhaust_fx, self, "tag_engine_left" );		
		if( !self.oneexhaust )
			PlayFXOnTag( localClientNum, self.exhaust_fx, self, "tag_engine_right" );		
	}	
	
/*
	exhaustDelay = 0.1; 
	while(true)
	{
		if( !isdefined( self ) || !( self isalive(self) ) )
		{
			println("play_exhaust: entity not alive or not defined");
			return; 
		}
		// self.model can change to the destroyed version if a vehicle is killed  
		else if( !isdefined( self.exhaust_fx ) )
		{
			println( "clientside exhaustfx not set up for vehicle model: " + self.model ); 
			return; 
		}		
		
		tag_left_orig = self gettagorigin( "tag_engine_left" ); 
		fwd_left = self gettagforwardvector( "tag_engine_left" );
		playfx( localClientNum, self.exhaust_fx, tag_left_orig, fwd_left ); 		

		// not all vehicles have two exhaust vents
		if( !self.oneexhaust )
		{
			tag_right_orig = self gettagorigin( "tag_engine_right" ); 
			fwd_right = self gettagforwardvector( "tag_engine_right" );
			playfx( localClientNum, self.exhaust_fx, tag_right_orig, fwd_right ); 
		}

		wait exhaustDelay; 
	}
*/
}

build_gear( vehicletype, model, tag )
{
	index = 0; 
	if( isdefined( level.vehicleGearModels ) )
	{
		if( isdefined( level.vehicleGearModels[vehicletype] ) )
		{
			index = level.vehicleGearModels[vehicletype].size; 
		}
	}
	level.vehicleGearModels[vehicletype][index] = model; 
	level.vehicleGearTags[vehicletype][index] = tag; 
}

vehicle_variants( localClientNum )
{
	if( isdefined( level.vehicleGearModels ) )
	{
		if( isdefined( level.vehicleGearModels[self.vehicletype] ) )
		{
			numGear = level.vehicleGearModels[self.vehicletype].size; 
			maxGear = 2; 
			if( numGear < maxGear )
			{
				maxGear = numGear; 
			}
			
			// want at least 2 pieces of gear currently
			// temp OFF
			//maxGear = randomInt( maxGear+1 ); 
			
			randomConstantNumber = self getentitynumber();
			for( i = 0 ; i < maxGear ; i++ )
			{
				alreadyChosen = true; 
				gearChoices[i] = -1; 
				while( alreadyChosen )
				{
					alreadyChosen = false; 
					gearChoices[i] = randomConstantNumber % numGear; //randomInt( numGear ); 
					for( j = 0 ; j < i ; j++ )
					{
						if( level.vehicleGearTags[self.vehicletype][gearChoices[j]] == level.vehicleGearTags[self.vehicletype][gearChoices[i]] )
						{
							alreadyChosen = true; 
							break; 
						}
					}
				}
				self attach( level.vehicleGearModels[self.vehicletype][gearChoices[i]], level.vehicleGearTags[self.vehicletype][gearChoices[i]] ); 
				randomConstantNumber++;
			}
		}
	}
}

aircraft_dustkick()
{
	waittillframeend;
	
	self endon( "kill_treads_forever" );
	self endon( "entityshutdown" ); 
	level endon( "save_restore" ); 
	
	if( IsDefined(self.csf_no_tread) && self.csf_no_tread ) //-- set by clientside flag
	{
		return;
	}
		
	const maxHeight = 1200; 
	const minHeight = 350; 

	const slowestRepeatWait = 0.2; 
	const fastestRepeatWait = 0.1; 
	
	if( self is_mig() ) //-- GLOCKE: added in just for jets for Flash Point
	{
		numFramesPerTrace = 1;
	}
	else
	{
		numFramesPerTrace = 3;
	}
	doTraceThisFrame = numFramesPerTrace; 

	const defaultRepeatRate = 1.0; 
	repeatRate = defaultRepeatRate; 

	trace = undefined; 
	d = undefined; 

	trace_ent = self; 
	
	while( isdefined( self ) )
	{
	
		if( repeatRate <= 0 )
		{
			repeatRate = defaultRepeatRate; 
		}

		if( self is_mig() ) //-- GLOCKE: added in just for jets for Flash Point
		{
			repeatRate = 0.02; 
		}
		
		waitrealtime( repeatRate ); 	
		
		if( !isdefined( self ) )
		{
			return;
		}
	
		doTraceThisFrame-- ; 

		if( doTraceThisFrame <= 0 )
		{
			doTraceThisFrame = numFramesPerTrace; 

			trace = tracepoint( trace_ent.origin, trace_ent.origin -( 0, 0, 100000 ) ); 
			 /* 
			trace["fraction"]
			trace["normal"]
			trace["position"]
			trace["surfacetype"]
			 */ 

			d = distance( trace_ent.origin, trace["position"] ); 

			if( d > minHeight )
			{
				repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait;
			}
			else
			{
				repeatRate = fastestRepeatWait;
			}				
		}

		if( isdefined( trace ) )
		{
			if( d > maxHeight )
			{
				repeatRate = defaultRepeatRate;
				continue; 
			}

			if( !isdefined( trace["surfacetype"] ) )
			{
				trace["surfacetype"] = "dirt"; 
			}

			if( IsDefined( self.treadfx[trace["surfacetype"]] ) )
			{
				playfx( 0, self.treadfx[trace["surfacetype"]], trace["position"] );
				//print3d( trace["position"], "+" + self.treadfx[trace["surfacetype"]], ( 0, 1, 0 ), 1, 3, 30 ); 
			}
			else
			{
				//-- Glocke (12/16/2008) converted to prints from asserts while I come up with a better solution with Laufer
				println("SCRIPT PRINT: Unknown surface type " + trace["surfacetype"] + " for vehicle type " + self.vehicletype);
				return;
			}
		}
		
		
	}
}

vehicle_weapon_fired()
{
	self endon( "entityshutdown" ); 
	level endon( "save_restore" ); 

	const shock_distance = 400 * 400; 
	const rumble_distance = 500 * 500; 
	while( true )
	{
		self waittill( "weapon_fired" ); 
//println( "<<<<<< CSC VEHICLE_WEAPON_FIRED START" );

		players = level.localPlayers; 
		for( i = 0; i < players.size; i++ )
		{
			player_distance = DistanceSquared( self.origin, players[i].origin ); 
//println( "<<<<<< CSC VEHICLE_WEAPON_FIRED PLAYER DISTANCE = " + player_distance );

			// RUMBLE ------------
			if( player_distance < rumble_distance )
			{
				if( IsDefined(self.shootrumble) && self.shootrumble != "" )
				{
//println( "<<<<<< CSC VEHICLE_WEAPON_FIRED RUMBLE " + self.shootrumble );
					PlayRumbleOnPosition( i, self.shootrumble, self.origin + ( 0, 0, 32 ) ); 
				}
			}

			// SHOCK -------------
			if( player_distance < shock_distance )
			{
				fraction = player_distance / shock_distance; 
				time = 4 - ( 3 * fraction ); 
			
				if( IsDefined( players[i] ) )
				{
					if( IsDefined(self.shootshock) && self.shootshock != "" )
					{
//println( "<<<<<< CSC VEHICLE_WEAPON_FIRED SHELLSHOCK " + self.shootshock );
						players[i] ShellShock( i, self.shootshock, time ); 	
					}
				}
			}
		}
	}
}

vehicle_clientmain(localClientNum)
{
	switch( self.vehicletype )
	{
		// no main
		case "uaz":
		case "cobra":
		case "jeep":
		case "willys":
			break;
		
		// this may be overkill -AP
		default:
			//ASSERTMSG( "Vehicle type: " + self.vehicletype + " not handled in _vehicle.csc::vehicle_clientmain" );
			break;
	}
}

headlights_on(localClientNum)
{
	// TODO: this stuff really needs to not be hardcoded. We need GDT support.

	if (self.vehicletype == "police")
	{
		self.headlightFX = LoadFX("vehicle/light/fx_cuba_police_headlight");
		self.frontDLightFX = LoadFX("maps/cuba/fx_cuba_veh_front_end_lights");

		// one dlight shared between headlights
		if (!IsDefined(self.frontDLightFXHandle))
		{
			self.frontDLightFXHandle = PlayFXOnTag(localClientNum, self.frontDLightFX, self, "tag_origin_animate_jnt");
		}
	}
	else if (self.vehicletype == "cuba_player")
	{
		return;
	}
	else
	{
		self.headlightFX = LoadFX("light/fx_vlight_headlight_default");
	}

	if (!IsDefined(self.headlightLeftFXHandle))
	{
		self.headlightLeftFXHandle = PlayFXOnTag(localClientNum, self.headlightFX, self, "tag_headlight_left");
	}

	if (!IsDefined(self.headlightRightFXHandle))
	{
		self.headlightRightFXHandle = PlayFXOnTag(localClientNum, self.headlightFX, self, "tag_headlight_right");
	}
}

headlights_off(localClientNum)
{
	if (IsDefined(self.headlightLeftFXHandle))
	{
		DeleteFX(localClientNum, self.headlightLeftFXHandle);
		self.headlightLeftFXHandle = undefined;
	}

	if (IsDefined(self.headlightRightFXHandle))
	{
		DeleteFX(localClientNum, self.headlightRightFXHandle);
		self.headlightRightFXHandle = undefined;
	}

	if (IsDefined(self.frontDLightFXHandle))
	{
		// one dlight shared between headlights
		DeleteFX(localClientNum, self.frontDLightFXHandle);
		self.frontDLightFXHandle = undefined;
	}
}

taillights_on(localClientNum)
{
	if (self.vehicletype == "police")
	{
		self.taillightLeftFX = LoadFX("vehicle/light/fx_cuba_police_taillight_left");
		self.taillightRightFX = LoadFX("vehicle/light/fx_cuba_police_taillight_right");

		self.taillightLeftTag = "tag_brakelight_left";
		self.taillightRightTag = "tag_brakelight_right";
	}
	else if (self.vehicletype == "cuba_player")
	{
		self.taillightLeftFX = LoadFX("vehicle/light/fx_cuba_car_brakelight");
		self.taillightLeftTag = "body_animate_jnt";
	}
	else
	{
		self.taillightLeftFX = LoadFX("light/fx_vlight_brakelight_default");
		self.taillightRightFX = LoadFX("light/fx_vlight_brakelight_default");

		self.taillightLeftTag = "tag_tail_light_left";
		self.taillightRightTag = "tag_tail_light_right";
	}

	if (!IsDefined(self.taillightLeftFXHandle))
	{
		self.taillightLeftFXHandle = PlayFXOnTag(localClientNum, self.taillightLeftFX, self, self.taillightLeftTag);
	}

	if (!IsDefined(self.taillightRightFXHandle) && IsDefined(self.taillightRightFX))
	{
		self.taillightRightFXHandle = PlayFXOnTag(localClientNum, self.taillightRightFX, self, self.taillightRightTag);
	}
}

taillights_off(localClientNum)
{
	if (IsDefined(self.taillightLeftFXHandle))
	{
		DeleteFX(localClientNum, self.taillightLeftFXHandle);
		self.taillightLeftFXHandle = undefined;
	}

	if (IsDefined(self.taillightRightFXHandle))
	{
		DeleteFX(localClientNum, self.taillightRightFXHandle);
		self.taillightRightFXHandle = undefined;
	}
}

interior_lights_on(localClientNum)
{
	if (self.vehicletype == "police")
	{
		self.interiorLightFX = LoadFX("maps/cuba/fx_cuba_veh_interior_lights");
		self.interiorLightTag = "tag_origin_animate_jnt";
		
		if (!IsDefined(self.interiorLightFXHandle))
		{
			self.interiorLightFXHandle = PlayFXOnTag(localClientNum, self.interiorLightFX, self, self.interiorLightTag);
		}
	}
}

interior_lights_off(localClientNum)
{
	if (IsDefined(self.interiorLightFXHandle))
	{
		DeleteFX(localClientNum, self.interiorLightFXHandle);
		self.interiorLightFXHandle = undefined;
	}
}

sirenlights_on(localClientNum)
{
	if (!IsDefined(self.sirenlightFXHandle))
	{
		self.sirenlightFX = LoadFX( "maps/cuba/fx_cuba_siren_light" );
		self.sirenlightFXHandle = PlayFXOnTag(localClientNum, self.sirenlightFX, self, "tag_origin_animate_jnt");
	}
}

sirenlights_off(localClientNum)
{
	if (IsDefined(self.sirenlightFXHandle))
	{
		DeleteFX(localClientNum, self.sirenlightFXHandle);
		self.sirenlightFXHandle = undefined;
	}
}

vehicle_flag_toggle_sounds(localClientNum, set, newEnt)
{
	if(self is_helicopter())	
	{
		if(set)
		{
			self notify( "stop_heli_sounds" );
			self.should_not_play_sounds = true;			
		}
		else
		{
			self notify( "play_heli_sounds" );
			self.should_not_play_sounds = false;
		}
	}
	else	// Non-helicoper version...
	{
		// Nothing - both set and clear cases are handled in code.
	}
}

vehicle_flag_turn_off_treadfx(localClientNum, set, newEnt)
{
	
	if(self is_helicopter() || self is_plane())
	{
		PrintLn("****CLIENT:: Vehicle Flag Plane");
		
		if(set)
		{
			if(IsDefined(newEnt) && newEnt)
			{ 
			  self.csf_no_tread = true;
			}
			else
			{
				self vehicle_kill_treads_forever();
			}			
		}
		else		// Flag being cleared.
		{
			if(IsDefined(self.csf_no_tread))
			{
				self.csf_no_tread = false;
			}
			self vehicle_kill_treads_forever();
			self thread aircraft_dustkick();
		}
	}
	else	// Non-helicopter version...
	{
		if(set)
		{
			PrintLn("****CLIENT:: Vehicle Flag Tread FX Set");
			if(IsDefined(newEnt) && newEnt)
			{ 
				PrintLn("****CLIENT:: TreadFX NewEnt: " + self GetEntityNumber());
			  self.csf_no_tread = true;
			}
			else
			{
				PrintLn("****CLIENT:: TreadFX OldEnt"  + self GetEntityNumber());
				self vehicle_kill_treads_forever();
			}
		}
		else	// Flag being cleared.
		{
			PrintLn("****CLIENT:: Vehicle Flag Tread FX Clear");
			if(IsDefined(self.csf_no_tread))
			{
				self.csf_no_tread = false;
			}
			self vehicle_kill_treads_forever();
			self thread vehicle_treads( localClientNum );				
		}
	}
}

vehicle_flag_start_use_engine_damage_low_sounds(localClientNum, set, newEnt)
{
	if(set)
	{
		self.engine_damage_low = true;
		self clientscripts\_helicopter_sounds::update_helicopter_sounds();
	}
	else	// Flag being cleared.
	{
		self.engine_damage_low = false;
		self clientscripts\_helicopter_sounds::update_helicopter_sounds();
	}
}

vehicle_flag_3_handler(localClientNum, set, newEnt)
{
	if(self is_helicopter())
	{
		vehicle_flag_start_use_engine_damage_low_sounds(localClientNum, set, newEnt);
	}
	else
	{
		// No current use for flag 0 for non helicopter vehicles.
	}
}

vehicle_flag_start_use_engine_damage_high_sounds(localClientNum, set, newEnt)
{
	if(set)
	{
		self.engine_damage_high = true;
		self clientscripts\_helicopter_sounds::update_helicopter_sounds();
	}
	else	// Flag being cleared.
	{
		self.engine_damage_high = false;
		self clientscripts\_helicopter_sounds::update_helicopter_sounds();
	}	
}

vehicle_flag_4_handler(localClientNum, set, newEnt)
{
	if(self is_helicopter())
	{
		vehicle_flag_start_use_engine_damage_high_sounds(localClientNum, set, newEnt);
	}
	else
	{
		// No current use for flag 0 for non helicopter vehicles.
	}
}

vehicle_flag_change_treadfx_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		//-- change the treadfx on a vehicle
	}
	else	// Flag being cleared.
	{
		//-- change the treadfx on a vehicle back to the default
	}
}

vehicle_flag_toggle_exhaustfx_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		if(IsDefined(newEnt) && newEnt)
		{ 
		  self.csf_no_exhaust = true;
		}
		else
		{
			self notify( "stop_exhaust_fx" );
		}		
	}
	else
	{
		if(IsDefined(self.csf_no_exhaust))
		{
			self.csf_no_exhaust = false;
		}
		self notify("stop_exhaust_fx");
		if( !self is_plane() && !self is_helicopter() && level.usetreadfx == 1)
		{
			self thread playTankExhaust(localClientNum);
		}
		else if(!self is_plane())
		{	
			self thread play_exhaust( localClientNum );
		}
	}
}

vehicle_flag_change_exhaustfx_handler(localClientNum, set, newEnt)
{
	if(set)
	{
		//-- change the exhaustfx on a vehicle
	}
	else	// Flag being cleared.
	{
		//-- change the exhaustfx on a vehicle back to the default
	}
}

vehicle_flag_toggle_lights_handler(localClientNum, set, newent)
{
	if(set)
	{
		self headlights_on(localClientNum);
		self taillights_on(localClientNum);
	}
	else	// Flag being cleared.
	{
		self headlights_off(localClientNum);
		self taillights_off(localClientNum);
	}
}

vehicle_flag_toggle_siren_lights_handler(localClientNum, set, newent)
{
	if(set)
	{
		self sirenlights_on(localClientNum);
	}
	else	// Flag being cleared.
	{
		self sirenlights_off(localClientNum);
	}
}

vehicle_flag_toggle_interior_lights_handler(localClientNum, set, newent)
{
	if(set)
	{
		self interior_lights_on(localClientNum);
	}
	else	// Flag being cleared.
	{
		self interior_lights_off(localClientNum);
	}
}

vehicle_flag_toggle_lockon_handler( localClientNum, set, newent )
{
	if(set)
	{
		self SetVehicleLockedOn( true );
	}
	else
	{
		self SetVehicleLockedOn( false );		
	}
}
