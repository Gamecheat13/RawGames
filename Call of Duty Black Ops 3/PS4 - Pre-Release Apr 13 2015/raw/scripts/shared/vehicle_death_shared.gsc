#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\vehicleriders_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace vehicle;

function autoexec __init__sytem__() {     system::register("vehicle_shared",&__init__,undefined,undefined);    }

function __init__()
{
	level._customVehicleCBFunc = &spawned_callback;
		
	clientfield::register( "vehicle", "toggle_lockon",						1, 1, "int", &field_toggle_lockon_handler, 			!true, !true );
	clientfield::register( "vehicle", "toggle_sounds", 						1, 1, "int", &field_toggle_sounds, 					!true, !true );
	clientfield::register( "vehicle", "use_engine_damage_sounds", 			1, 2, "int", &field_use_engine_damage_sounds, 		!true, !true );
	clientfield::register( "vehicle", "toggle_treadfx", 					1, 1, "int", &field_toggle_treadfx, 					!true, !true );
	clientfield::register( "vehicle", "toggle_exhaustfx", 					1, 1, "int", &field_toggle_exhaustfx_handler,		!true, !true );
	clientfield::register( "vehicle", "toggle_lights", 						1, 2, "int", &field_toggle_lights_handler, 			!true, !true );
	clientfield::register( "vehicle", "toggle_lights_group1", 				1, 1, "int", &field_toggle_lights_group_handler1, 	!true, !true );
	clientfield::register( "vehicle", "toggle_lights_group2", 				1, 1, "int", &field_toggle_lights_group_handler2, 	!true, !true );
	clientfield::register( "vehicle", "toggle_lights_group3", 				1, 1, "int", &field_toggle_lights_group_handler3, 	!true, !true );
	clientfield::register( "vehicle", "toggle_ambient_anim_group1",			1, 1, "int", &field_toggle_ambient_anim_handler1, 	!true, !true );
	clientfield::register( "vehicle", "toggle_ambient_anim_group2",			1, 1, "int", &field_toggle_ambient_anim_handler2, 	!true, !true );
	clientfield::register( "vehicle", "toggle_ambient_anim_group3",			1, 1, "int", &field_toggle_ambient_anim_handler3, 	!true, !true );
	clientfield::register( "vehicle", "deathfx", 							1, 1, "int", &field_do_deathfx, 						!true, !true );
	clientfield::register( "vehicle", "alert_level", 						1, 2, "int", &field_update_alert_level, 				!true, !true );
	clientfield::register( "vehicle", "set_lighting_ent", 					1, 1, "int", &util::field_set_lighting_ent, 			!true, !true );
	clientfield::register( "vehicle", "use_lighting_ent", 					1, 1, "int", &util::field_use_lighting_ent, 			!true, !true );
	clientfield::register( "vehicle", "damage_level",						1, 3, "int", &field_update_damage_state,				!true, !true );
	
	clientfield::register( "helicopter", "toggle_lockon",						1, 1, "int", &field_toggle_lockon_handler, 			!true, !true );
	clientfield::register( "helicopter", "toggle_sounds", 					1, 1, "int", &vehicle::field_toggle_sounds, 			!true, !true );
	clientfield::register( "helicopter", "use_engine_damage_sounds", 			1, 2, "int", &field_use_engine_damage_sounds, 		!true, !true );
	clientfield::register( "helicopter", "toggle_treadfx", 					1, 1, "int", &field_toggle_treadfx, 					!true, !true );
	clientfield::register( "helicopter", "toggle_exhaustfx", 				1, 1, "int", &field_toggle_exhaustfx_handler,		!true, !true );
	clientfield::register( "helicopter", "toggle_lights", 					1, 2, "int", &field_toggle_lights_handler, 			!true, !true );
	clientfield::register( "helicopter", "toggle_lights_group1", 			1, 1, "int", &field_toggle_lights_group_handler1, 	!true, !true );
	clientfield::register( "helicopter", "toggle_lights_group2", 			1, 1, "int", &field_toggle_lights_group_handler2, 	!true, !true );
	clientfield::register( "helicopter", "toggle_lights_group3", 			1, 1, "int", &field_toggle_lights_group_handler3, 	!true, !true );
	clientfield::register( "helicopter", "toggle_ambient_anim_group1",		1, 1, "int", &field_toggle_ambient_anim_handler1, 	!true, !true );
	clientfield::register( "helicopter", "toggle_ambient_anim_group2",		1, 1, "int", &field_toggle_ambient_anim_handler2, 	!true, !true );
	clientfield::register( "helicopter", "toggle_ambient_anim_group3",		1, 1, "int", &field_toggle_ambient_anim_handler3, 	!true, !true );
	clientfield::register( "helicopter", "deathfx", 						1, 1, "int", &field_do_deathfx, 						!true, !true );
	clientfield::register( "helicopter", "alert_level", 					1, 2, "int", &field_update_alert_level, 				!true, !true );
	clientfield::register( "helicopter", "set_lighting_ent", 				1, 1, "int", &util::field_set_lighting_ent, 			!true, !true );
	clientfield::register( "helicopter", "use_lighting_ent", 				1, 1, "int", &util::field_use_lighting_ent, 			!true, !true );
	clientfield::register( "helicopter", "damage_level",					1, 3, "int", &field_update_damage_state,				!true, !true );
		
	clientfield::register( "plane", "toggle_treadfx", 						1, 1, "int", &field_toggle_treadfx, 					!true, !true );
	
	clientfield::register( "toplayer", "toggle_dnidamagefx", 				1, 1, "int", &field_toggle_dnidamagefx, 				!true, !true );
}

function add_vehicletype_callback( vehicletype, callback )
{
	if ( !isdefined( level.vehicleTypeCallbackArray ) )
	{
		level.vehicleTypeCallbackArray = [];
	}
	
	level.vehicleTypeCallbackArray[vehicletype] = callback;
}

function spawned_callback( localClientNum )
{
	if ( isdefined( self.vehicleridersbundle ) )
	{
		set_vehicleriders_bundle( self.vehicleridersbundle );
	}
	
	vehicletype = self.vehicletype;
	if( isdefined( level.vehicleTypeCallbackArray ) )
	{
		if ( isdefined( vehicletype ) && isdefined( level.vehicleTypeCallbackArray[vehicletype] ) )
		{
			self thread [[level.vehicleTypeCallbackArray[vehicletype]]]( localClientNum );
		}
		else if( isdefined( self.scriptvehicletype ) && isdefined( level.vehicleTypeCallbackArray[self.scriptvehicletype] ) )
		{
			self thread [[level.vehicleTypeCallbackArray[self.scriptvehicletype]]]( localClientNum );
		}
	}
}

function rumble( localClientNum )
{
	self endon( "entityshutdown" ); 
			
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

function kill_treads_forever()
{
	//PrintLn("****CLIENT:: killing the tread_fx");
	self notify( "kill_treads_forever" ); 
}

function play_exhaust( localClientNum )
{	
	if( isdefined(self.csf_no_exhaust) && self.csf_no_exhaust )
	{
		return;
	}
	
	if( !isdefined( self.exhaust_fx ) && isdefined( self.exhaustfxname ) )
	{
		if( !isdefined( level._effect ) )
		{
			level._effect = [];
		}
		
		if ( !isdefined( level._effect[self.exhaustfxname] ) )
		{
			level._effect[self.exhaustfxname] = self.exhaustfxname;
		}
		self.exhaust_fx = level._effect[self.exhaustfxname];
	}
	
	if( isdefined( self.exhaust_fx ) && isdefined( self.exhaustFxTag1 ) )
	{
		if( isalive(self) )
		{
			Assert( isdefined( self.exhaustFxTag1 ), self.vehicletype + " vehicle exhaust effect is set, but tag 1 is undefined. Please update the vehicle gdt entry" );
			self.exhaust_id_left = PlayFXOnTag( localClientNum, self.exhaust_fx, self, self.exhaustFxTag1 );
			
			if( !isdefined( self.exhaust_id_right ) && IsDefined( self.exhaustFxTag2 ) )
			{
				self.exhaust_id_right = PlayFXOnTag( localClientNum, self.exhaust_fx, self, self.exhaustFxTag2 );				
			}
				
			self thread kill_exhaust_watcher( localClientNum );				
		}	
	}
}

function kill_exhaust_watcher( localClientNum )
{
	self waittill( "stop_exhaust_fx" );

	if ( isdefined( self.exhaust_id_left ) )
	{
		StopFX( localClientNum, self.exhaust_id_left );
		self.exhaust_id_left = undefined;
	}
	
	if ( isdefined( self.exhaust_id_right ) )
	{
		StopFX( localClientNum, self.exhaust_id_right );
		self.exhaust_id_right = undefined;		
	}
}

function stop_exhaust( localClientNum )
{
	self notify( "stop_exhaust_fx" );
}

function aircraft_dustkick()
{
	waittillframeend;
	
	self endon( "kill_treads_forever" );
	self endon( "entityshutdown" ); 

	if(!IsDefined(self))
	{
		return;
	}
	
	if( isdefined(self.csf_no_tread) && self.csf_no_tread ) //-- set by clientside flag
	{
		return;
	}
		
	const maxHeight = 1200; 
	const minHeight = 350; 

	const slowestRepeatWait = 0.2; 
	const fastestRepeatWait = 0.1; 
	
	if( (self.vehicleclass == "plane_mig17" || self.vehicleclass == "plane_mig21") ) //-- GLOCKE: added in just for jets for Flash Point
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

		if( (self.vehicleclass == "plane_mig17" || self.vehicleclass == "plane_mig21") ) //-- GLOCKE: added in just for jets for Flash Point
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

/*
			if( isdefined( self.treadfx[trace["surfacetype"]] ) )
			{
				playfx( 0, self.treadfx[trace["surfacetype"]], trace["position"] );
				//print3d( trace["position"], "+" + self.treadfx[trace["surfacetype"]], ( 0, 1, 0 ), 1, 3, 30 ); 
			}
			else
			{
				//-- Glocke (12/16/2008) converted to prints from asserts while I come up with a better solution with Laufer
				/#println("SCRIPT PRINT: Unknown surface type " + trace["surfacetype"] + " for vehicle type " + self.vehicletype);#/
				return;
			}
 */
		}
		
		
	}
}

function weapon_fired()
{
	self endon( "entityshutdown" ); 
	
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
				if( isdefined(self.shootrumble) && self.shootrumble != "" )
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
			
				if( isdefined( players[i] ) )
				{
					if( isdefined(self.shootshock) && self.shootshock != "" )
					{
//println( "<<<<<< CSC VEHICLE_WEAPON_FIRED SHELLSHOCK " + self.shootshock );
						players[i] ShellShock( i, self.shootshock, time ); 	
					}
				}
			}
		}
	}
}

function wait_for_DObj( localClientNum )
{
	count = 30;
	while( !self HasDObj( localClientNum ) )
	{
		if( count < 0 )
		{
			/#
				IPrintLnBold( "WARNING: Failing to turn on fx lights for vehicle because no DOBJ!" );
			#/
			return;
		}
		{wait(.016);};
		count -= 1;
	}
}

function lights_on( localClientNum, team )
{
	self endon( "entityshutdown" );
	
	lights_off( localClientNum );	// make sure we kill all of the old fx
	
	wait_for_DObj( localClientNum );
	
	if( isdefined( self.lightfxnamearray ) )
	{
		if( !isdefined( self.light_fx_handles ) )
		{
			self.light_fx_handles = [];
		}
		
		for( i = 0; i < self.lightfxnamearray.size; i++ )
		{
			self.light_fx_handles[ i ] = PlayFXOnTag( localClientNum, self.lightfxnamearray[i], self, self.lightfxtagarray[i] );
			if( IsDefined( team ) )
			{
				SetFXTeam( localClientNum, self.light_fx_handles[ i ], team );
			}
		}
	}
}

function addAnimToList( animItem, &listOn, &listOff, playWhenOff, id, maxID )
{
	if ( isdefined( animItem ) && id <= maxID )
	{
		if ( playWhenOff === true )
		{
			if ( !isdefined( listOff ) ) listOff = []; else if ( !IsArray( listOff ) ) listOff = array( listOff ); listOff[listOff.size]=animItem;;
		}
		else
		{
			if ( !isdefined( listOn ) ) listOn = []; else if ( !IsArray( listOn ) ) listOn = array( listOn ); listOn[listOn.size]=animItem;;
		}
	}
}

function ambient_anim_toggle( localClientNum, groupID, isOn )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	
	if ( !isdefined( settings ) )
	{
		return;
	}

	wait_for_DObj( localClientNum );

	listOn = [];
	listOff = [];

	switch ( groupID )
	{
	case 1:
		addAnimToList( settings.ambient_group1_anim1, listOn, listOff, settings.ambient_group1_off1, 1, settings.ambient_group1_numslots );
		addAnimToList( settings.ambient_group1_anim2, listOn, listOff, settings.ambient_group1_off2, 2, settings.ambient_group1_numslots );
		addAnimToList( settings.ambient_group1_anim3, listOn, listOff, settings.ambient_group1_off3, 3, settings.ambient_group1_numslots );
		addAnimToList( settings.ambient_group1_anim4, listOn, listOff, settings.ambient_group1_off4, 4, settings.ambient_group1_numslots );
		break;
	case 2:
		addAnimToList( settings.ambient_group2_anim1, listOn, listOff, settings.ambient_group2_off1, 1, settings.ambient_group2_numslots );
		addAnimToList( settings.ambient_group2_anim2, listOn, listOff, settings.ambient_group2_off2, 2, settings.ambient_group2_numslots );
		addAnimToList( settings.ambient_group2_anim3, listOn, listOff, settings.ambient_group2_off3, 3, settings.ambient_group2_numslots );
		addAnimToList( settings.ambient_group2_anim4, listOn, listOff, settings.ambient_group2_off4, 4, settings.ambient_group2_numslots );
		break;
	case 3:
		addAnimToList( settings.ambient_group3_anim1, listOn, listOff, settings.ambient_group3_off1, 1, settings.ambient_group3_numslots );
		addAnimToList( settings.ambient_group3_anim2, listOn, listOff, settings.ambient_group3_off2, 2, settings.ambient_group3_numslots );
		addAnimToList( settings.ambient_group3_anim3, listOn, listOff, settings.ambient_group3_off3, 3, settings.ambient_group3_numslots );
		addAnimToList( settings.ambient_group3_anim4, listOn, listOff, settings.ambient_group3_off4, 4, settings.ambient_group3_numslots );
		break;
	case 4:
		addAnimToList( settings.ambient_group4_anim1, listOn, listOff, settings.ambient_group4_off1, 1, settings.ambient_group4_numslots );
		addAnimToList( settings.ambient_group4_anim2, listOn, listOff, settings.ambient_group4_off2, 2, settings.ambient_group4_numslots );
		addAnimToList( settings.ambient_group4_anim3, listOn, listOff, settings.ambient_group4_off3, 3, settings.ambient_group4_numslots );
		addAnimToList( settings.ambient_group4_anim4, listOn, listOff, settings.ambient_group4_off4, 4, settings.ambient_group4_numslots );
		break;
	}

	if ( isOn )
	{
		weightOn = 1.0;
		weightOff = 0.0;
	}
	else
	{
		weightOn = 0.0;
		weightOff = 1.0;
	}

	for ( i = 0; i < listOn.size; i++ )
	{
		self SetAnim( listOn[i], weightOn, 0.2, 1.0 );
	}

	for ( i = 0; i < listOff.size; i++ )
	{
		self SetAnim( listOff[i], weightOff, 0.2, 1.0 );
	}
}

function field_toggle_ambient_anim_handler1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self ambient_anim_toggle( localClientNum, 1, newVal );
}

function field_toggle_ambient_anim_handler2( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self ambient_anim_toggle( localClientNum, 2, newVal );
}

function field_toggle_ambient_anim_handler3( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self ambient_anim_toggle( localClientNum, 3, newVal );
}

function field_toggle_ambient_anim_handler4( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self ambient_anim_toggle( localClientNum, 4, newVal );
}

function lights_group_toggle( localClientNum, id, isOn )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	if ( !isdefined( settings ) || !isdefined( settings.lightgroups_numGroups ) )
	{
		return;
	}

	wait_for_DObj( localClientNum );

	groupID = id - 1;

	// remove old fx
	if ( isdefined( self.lightfxgroups ) && groupID < self.lightfxgroups.size )
	{
		foreach( fx_handle in self.lightfxgroups[ groupID ] )
		{
			DeleteFX( localClientNum, fx_handle );
		}
	}

	if ( !isOn )
	{
		return;
	}

	// initialize
	if ( !isdefined( self.lightfxgroups ) )
	{
		self.lightfxgroups = [];
		for ( i = 0; i < settings.lightgroups_numGroups; i++ )
		{
			newfxhandlearray = [];
			if ( !isdefined( self.lightfxgroups ) ) self.lightfxgroups = []; else if ( !IsArray( self.lightfxgroups ) ) self.lightfxgroups = array( self.lightfxgroups ); self.lightfxgroups[self.lightfxgroups.size]=newfxhandlearray;;
		}
	}

	self.lightfxgroups[groupID] = [];

	fxList = [];
	tagList = [];

	switch ( groupID )
	{
	case 0:
		addFxAndTagToLists( settings.lightgroups_1_fx1, settings.lightgroups_1_tag1, fxList, tagList, 1, settings.lightgroups_1_numslots );
		addFxAndTagToLists( settings.lightgroups_1_fx2, settings.lightgroups_1_tag2, fxList, tagList, 2, settings.lightgroups_1_numslots );
		addFxAndTagToLists( settings.lightgroups_1_fx3, settings.lightgroups_1_tag3, fxList, tagList, 3, settings.lightgroups_1_numslots );
		addFxAndTagToLists( settings.lightgroups_1_fx4, settings.lightgroups_1_tag4, fxList, tagList, 4, settings.lightgroups_1_numslots );
		break;
	case 1:
		addFxAndTagToLists( settings.lightgroups_2_fx1, settings.lightgroups_2_tag1, fxList, tagList, 1, settings.lightgroups_2_numslots );
		addFxAndTagToLists( settings.lightgroups_2_fx2, settings.lightgroups_2_tag2, fxList, tagList, 2, settings.lightgroups_2_numslots );
		addFxAndTagToLists( settings.lightgroups_2_fx3, settings.lightgroups_2_tag3, fxList, tagList, 3, settings.lightgroups_2_numslots );
		addFxAndTagToLists( settings.lightgroups_2_fx4, settings.lightgroups_2_tag4, fxList, tagList, 4, settings.lightgroups_2_numslots );
		break;
	case 2:
		addFxAndTagToLists( settings.lightgroups_3_fx1, settings.lightgroups_3_tag1, fxList, tagList, 1, settings.lightgroups_3_numslots );
		addFxAndTagToLists( settings.lightgroups_3_fx2, settings.lightgroups_3_tag2, fxList, tagList, 2, settings.lightgroups_3_numslots );
		addFxAndTagToLists( settings.lightgroups_3_fx3, settings.lightgroups_3_tag3, fxList, tagList, 3, settings.lightgroups_3_numslots );
		addFxAndTagToLists( settings.lightgroups_3_fx4, settings.lightgroups_3_tag4, fxList, tagList, 4, settings.lightgroups_3_numslots );
		break;
	case 3:
		addFxAndTagToLists( settings.lightgroups_4_fx1, settings.lightgroups_4_tag1, fxList, tagList, 1, settings.lightgroups_4_numslots );
		addFxAndTagToLists( settings.lightgroups_4_fx2, settings.lightgroups_4_tag2, fxList, tagList, 2, settings.lightgroups_4_numslots );
		addFxAndTagToLists( settings.lightgroups_4_fx3, settings.lightgroups_4_tag3, fxList, tagList, 3, settings.lightgroups_4_numslots );
		addFxAndTagToLists( settings.lightgroups_4_fx4, settings.lightgroups_4_tag4, fxList, tagList, 4, settings.lightgroups_4_numslots );
		break;
	}

	for ( i = 0; i < fxList.size; i++ )
	{
		fx_handle = PlayFXOnTag( localClientNum, fxList[i], self, tagList[i] );
		if ( !isdefined( self.lightfxgroups[groupID] ) ) self.lightfxgroups[groupID] = []; else if ( !IsArray( self.lightfxgroups[groupID] ) ) self.lightfxgroups[groupID] = array( self.lightfxgroups[groupID] ); self.lightfxgroups[groupID][self.lightfxgroups[groupID].size]=fx_handle;;
	}
}

function field_toggle_lights_group_handler1( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lights_group_toggle( localClientNum, 1, newVal );
}
function field_toggle_lights_group_handler2( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lights_group_toggle( localClientNum, 2, newVal );
}
function field_toggle_lights_group_handler3( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lights_group_toggle( localClientNum, 3, newVal );
}
function field_toggle_lights_group_handler4( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self lights_group_toggle( localClientNum, 4, newVal );
}

function delete_alert_lights( localClientNum )
{
	if( isdefined( self.alert_light_fx_handles ) )
	{
		for( i = 0; i < self.alert_light_fx_handles.size; i++ )
		{
			DeleteFX( localClientNum, self.alert_light_fx_handles[ i ] );
		}
	}
	
	self.alert_light_fx_handles = undefined;
}

function lights_off( localClientNum )
{
	if( isdefined( self.light_fx_handles ) )
	{
		for( i = 0; i < self.light_fx_handles.size; i++ )
		{
			DeleteFX( localClientNum, self.light_fx_handles[ i ] );
		}
	}
	
	self.light_fx_handles = undefined;
	
	delete_alert_lights( localClientNum );
}

function field_toggle_sounds( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )	
	{
		if(newVal)
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

	if(newVal)
	{
		self disablevehiclesounds();
	}
	else
	{
		self enablevehiclesounds();
	}
}

function field_toggle_dnidamagefx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{			
	if( newVal )
	{
		self thread postfx::PlayPostfxBundle( "pstfx_dni_vehicle_dmg" );
	}
}

function field_toggle_treadfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	
	if( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) )  || ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) )
	{
		/#PrintLn("****CLIENT:: Vehicle Flag Plane");#/
		
		if(newVal)
		{
			if(isdefined(bNewEnt) && bNewEnt)
			{ 
			  self.csf_no_tread = true;
			}
			else
			{
				self kill_treads_forever();
			}			
		}
		else		// Flag being cleared.
		{
			if(isdefined(self.csf_no_tread))
			{
				self.csf_no_tread = false;
			}
			self kill_treads_forever();
			self thread aircraft_dustkick();
		}
	}
	else	// Non-helicopter version...
	{
		if(newVal)
		{
			/#PrintLn("****CLIENT:: Vehicle Flag Tread FX Set");#/
			if(isdefined(bNewEnt) && bNewEnt)
			{ 
				/#PrintLn("****CLIENT:: TreadFX NewEnt: " + self GetEntityNumber());#/
			  self.csf_no_tread = true;
			}
			else
			{
				/#PrintLn("****CLIENT:: TreadFX OldEnt"  + self GetEntityNumber());#/
				self kill_treads_forever();
			}
		}
		else	// Flag being cleared.
		{
			/#PrintLn("****CLIENT:: Vehicle Flag Tread FX Clear");#/
			if(isdefined(self.csf_no_tread))
			{
				self.csf_no_tread = false;
			}
			self kill_treads_forever();		
		}
	}
}

function field_use_engine_damage_sounds( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
	{
		switch ( newVal )
		{
			case 0:
				{
					self.engine_damage_low = false;
					self.engine_damage_high = false;
				} break;
			case 1: // Low
				{
					self.engine_damage_low = true;
					self.engine_damage_high = false;
				} break;
			case 1: // High
				{
					self.engine_damage_low = false;
					self.engine_damage_high = true;
				} break;
		}
		//TODO T7 - bring this over from SP if we need it
		//self helicopter_sounds::update_helicopter_sounds();
	}
}

function field_do_deathfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal && !bInitialSnap )
	{
		if( isdefined( self.deathfxname ) )
		{
			if ( isdefined( self.deathfxtag ) && self.deathfxtag != "" )
			{
				PlayFXOnTag( localClientNum, self.deathfxname, self, self.deathfxtag );
			}
			else
			{
				PlayFX( localClientNum, self.deathfxname, self.origin );
			}
		}
		
		self PlaySound( localClientNum, self.deathfxsound );
		
		if ( isdefined( self.deathquakescale ) && self.deathquakescale > 0 )
		{
			self Earthquake( self.deathquakescale, self.deathquakeduration, self.origin, self.deathquakeradius );
		}
	}
}

function field_update_alert_level( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	vehicle::delete_alert_lights( localClientNum );
	
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}
	
	if( !isdefined( self.alert_light_fx_handles ) )
	{
		self.alert_light_fx_handles = [];
	}
	
	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	
	switch( newVal )
	{
		case 0: 
			break;
		case 1:
			if( isdefined( settings.unawarelightfx1 ) )
			{
				self.alert_light_fx_handles[ 0 ] = PlayFXOnTag( localClientNum, settings.unawarelightfx1, self, settings.lighttag1 );
			}
			break;
		case 2:
			if( isdefined( settings.alertlightfx1 ) )
			{
				self.alert_light_fx_handles[ 0 ] = PlayFXOnTag( localClientNum, settings.alertlightfx1, self, settings.lighttag1 );
			}
			break;
		case 3:
			if( isdefined( settings.combatlightfx1 ) )
			{
				self.alert_light_fx_handles[ 0 ] = PlayFXOnTag( localClientNum, settings.combatlightfx1, self, settings.lighttag1 );
			}
			break;
	}
	
}

function field_toggle_exhaustfx_handler( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		if(isdefined(bNewEnt) && bNewEnt)
		{ 
			self.csf_no_exhaust = true;
		}
		else
		{
			self stop_exhaust( localClientNum );
		}		
	}
	else
	{
		if(isdefined(self.csf_no_exhaust))
		{
			self.csf_no_exhaust = false;
		}
		self stop_exhaust( localClientNum );
		
		self play_exhaust( localClientNum );
	}
}

function control_lights_groups( localClientNum, on )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	if ( !isdefined( settings ) || !isdefined( settings.lightgroups_numGroups ) )
	{
		return;
	}

	if ( settings.lightgroups_numGroups >= 1 && settings.lightgroups_1_always_on !== true )
	{
		lights_group_toggle( localClientNum, 1, on );
	}
	if ( settings.lightgroups_numGroups >= 2 && settings.lightgroups_2_always_on !== true )
	{
		lights_group_toggle( localClientNum, 2, on );
	}
	if ( settings.lightgroups_numGroups >= 3 && settings.lightgroups_3_always_on !== true )
	{
		lights_group_toggle( localClientNum, 3, on );
	}
}

function field_toggle_lights_handler( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	//lights:
	//0 - turn on normal
	//1 - turn off
	//2 - override to allied color
	//3 - override to axis color
	
	if( newVal == 1 )
	{
		self lights_off( localClientNum );
	}
	else	// Flag being cleared.
	{
		if( newVal == 2 )
		{
			self lights_on( localClientNum, "allies" );
		}
		else if( newVal == 3 )
		{
			self lights_on( localClientNum, "axis" );
		}
		else
		{
			self lights_on( localClientNum );
		}
	}

	control_lights_groups( localClientNum, newVal != 1 );
}

function field_toggle_lockon_handler( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	//TODO T7 - work with code to get this back if needed
	/*if(newVal)
	{
		self SetVehicleLockedOn( true );
	}
	else
	{
		self SetVehicleLockedOn( false );		
	}*/
}

function addFxAndTagToLists( fx, tag, &fxList, &tagList, id, maxID )
{
	if ( isdefined( fx ) && isdefined( tag ) && id <= maxID )
	{
		if ( !isdefined( fxList ) ) fxList = []; else if ( !IsArray( fxList ) ) fxList = array( fxList ); fxList[fxList.size]=fx;;
		if ( !isdefined( tagList ) ) tagList = []; else if ( !IsArray( tagList ) ) tagList = array( tagList ); tagList[tagList.size]=tag;;
	}
}

function field_update_damage_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !isdefined( self.scriptbundlesettings ) )
	{
		return;
	}

	settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	if ( isdefined( self.damage_state_fx_handles ) )
	{
		foreach( fx_handle in self.damage_state_fx_handles )
		{
			DeleteFX( localClientNum, fx_handle );
		}
	}

	self.damage_state_fx_handles = [];

	fxList = [];
	tagList = [];

	switch( newVal )
	{
		case 0: 
			break;
		case 1:
			addFxAndTagToLists( settings.damagestate_lv1_fx1, settings.damagestate_lv1_tag1, fxList, tagList, 1, settings.damagestate_lv1_numslots );
			addFxAndTagToLists( settings.damagestate_lv1_fx2, settings.damagestate_lv1_tag2, fxList, tagList, 2, settings.damagestate_lv1_numslots );
			addFxAndTagToLists( settings.damagestate_lv1_fx3, settings.damagestate_lv1_tag3, fxList, tagList, 3, settings.damagestate_lv1_numslots );
			addFxAndTagToLists( settings.damagestate_lv1_fx4, settings.damagestate_lv1_tag4, fxList, tagList, 4, settings.damagestate_lv1_numslots );
			break;
		case 2:
			addFxAndTagToLists( settings.damagestate_lv2_fx1, settings.damagestate_lv2_tag1, fxList, tagList, 1, settings.damagestate_lv2_numslots );
			addFxAndTagToLists( settings.damagestate_lv2_fx2, settings.damagestate_lv2_tag2, fxList, tagList, 2, settings.damagestate_lv2_numslots );
			addFxAndTagToLists( settings.damagestate_lv2_fx3, settings.damagestate_lv2_tag3, fxList, tagList, 3, settings.damagestate_lv2_numslots );
			addFxAndTagToLists( settings.damagestate_lv2_fx4, settings.damagestate_lv2_tag4, fxList, tagList, 4, settings.damagestate_lv2_numslots );
			break;
		case 3:
			addFxAndTagToLists( settings.damagestate_lv3_fx1, settings.damagestate_lv3_tag1, fxList, tagList, 1, settings.damagestate_lv3_numslots );
			addFxAndTagToLists( settings.damagestate_lv3_fx2, settings.damagestate_lv3_tag2, fxList, tagList, 2, settings.damagestate_lv3_numslots );
			addFxAndTagToLists( settings.damagestate_lv3_fx3, settings.damagestate_lv3_tag3, fxList, tagList, 3, settings.damagestate_lv3_numslots );
			addFxAndTagToLists( settings.damagestate_lv3_fx4, settings.damagestate_lv3_tag4, fxList, tagList, 4, settings.damagestate_lv3_numslots );
			break;
		case 4:
			addFxAndTagToLists( settings.damagestate_lv4_fx1, settings.damagestate_lv4_tag1, fxList, tagList, 1, settings.damagestate_lv4_numslots );
			addFxAndTagToLists( settings.damagestate_lv4_fx2, settings.damagestate_lv4_tag2, fxList, tagList, 2, settings.damagestate_lv4_numslots );
			addFxAndTagToLists( settings.damagestate_lv4_fx3, settings.damagestate_lv4_tag3, fxList, tagList, 3, settings.damagestate_lv4_numslots );
			addFxAndTagToLists( settings.damagestate_lv4_fx4, settings.damagestate_lv4_tag4, fxList, tagList, 4, settings.damagestate_lv4_numslots );
			break;
		case 5:
			addFxAndTagToLists( settings.damagestate_lv5_fx1, settings.damagestate_lv5_tag1, fxList, tagList, 1, settings.damagestate_lv5_numslots );
			addFxAndTagToLists( settings.damagestate_lv5_fx2, settings.damagestate_lv5_tag2, fxList, tagList, 2, settings.damagestate_lv5_numslots );
			addFxAndTagToLists( settings.damagestate_lv5_fx3, settings.damagestate_lv5_tag3, fxList, tagList, 3, settings.damagestate_lv5_numslots );
			addFxAndTagToLists( settings.damagestate_lv5_fx4, settings.damagestate_lv5_tag4, fxList, tagList, 4, settings.damagestate_lv5_numslots );
			break;
		case 6:
			addFxAndTagToLists( settings.damagestate_lv6_fx1, settings.damagestate_lv6_tag1, fxList, tagList, 1, settings.damagestate_lv6_numslots );
			addFxAndTagToLists( settings.damagestate_lv6_fx2, settings.damagestate_lv6_tag2, fxList, tagList, 2, settings.damagestate_lv6_numslots );
			addFxAndTagToLists( settings.damagestate_lv6_fx3, settings.damagestate_lv6_tag3, fxList, tagList, 3, settings.damagestate_lv6_numslots );
			addFxAndTagToLists( settings.damagestate_lv6_fx4, settings.damagestate_lv6_tag4, fxList, tagList, 4, settings.damagestate_lv6_numslots );
			break;
	}

	for( i = 0; i < fxList.size; i++ )
	{
		fx_handle = PlayFXOnTag( localClientNum, fxList[i], self, tagList[i] );
		if ( !isdefined( self.damage_state_fx_handles ) ) self.damage_state_fx_handles = []; else if ( !IsArray( self.damage_state_fx_handles ) ) self.damage_state_fx_handles = array( self.damage_state_fx_handles ); self.damage_state_fx_handles[self.damage_state_fx_handles.size]=fx_handle;;
	}
}

//-----------------------------------------------------------------------------
//
// Generic Full-Screen Damage Filter System
//
//-----------------------------------------------------------------------------









// yuck
function autoexec build_damage_filter_list()
{
	if ( !isdefined( level.vehicle_damage_filters ) )
	{
		level.vehicle_damage_filters = [];
	}

	level.vehicle_damage_filters[ 0 ] = "generic_filter_vehicle_damage";
	level.vehicle_damage_filters[ 1 ] = "generic_filter_sam_damage";	
	level.vehicle_damage_filters[ 2 ] = "generic_filter_f35_damage";		
   	level.vehicle_damage_filters[ 3 ] = "generic_filter_vehicle_damage_sonar";
   	level.vehicle_damage_filters[ 4 ] = "generic_filter_rts_vehicle_damage";
}
	
function init_damage_filter( materialid )
{
	level.localPlayers[0].damage_filter_intensity = 0;
	
	materialname = level.vehicle_damage_filters[ materialid ];
	
	filter::init_filter_vehicle_damage( level.localPlayers[0], materialname );
	filter::enable_filter_vehicle_damage( level.localPlayers[0], 3, materialname );	
	filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3, 0 );
	filter::set_filter_vehicle_sun_position( level.localPlayers[0], 3, 0, 0 );
}

function damage_filter_enable( localClientNum, materialid )
{
	filter::enable_filter_vehicle_damage( level.localPlayers[0], 3, level.vehicle_damage_filters[ materialid ] );	
	
	level.localPlayers[0].damage_filter_intensity = 0;
	filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3,	level.localPlayers[0].damage_filter_intensity );	
}

function damage_filter_disable( localClientNum )
{
	level notify( "damage_filter_off" );
	
	level.localPlayers[0].damage_filter_intensity = 0;
	filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity );		
	
	filter::disable_filter_vehicle_damage( level.localPlayers[0], 3 );		

}

function damage_filter_off( localClientNum )
{
	level endon( "damage_filter" );
	level endon( "damage_filter_off" );	
	level endon( "damage_filter_heavy" );
	
	if(!isdefined(level.localPlayers[0].damage_filter_intensity ))
		return;
		
	while ( level.localPlayers[0].damage_filter_intensity > 0 )
	{
		level.localPlayers[0].damage_filter_intensity -= 1 / 0.33 * 0.016667;
		if ( level.localPlayers[0].damage_filter_intensity < 0 )
			level.localPlayers[0].damage_filter_intensity = 0;
			
		filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity );		
			
		wait( 0.016667 );
	}
}

function damage_filter_light( localClientNum )
{
	level endon( "damage_filter_off" );
	level endon( "damage_filter_heavy" );
	
	level notify( "damage_filter" );
	
	while ( level.localPlayers[0].damage_filter_intensity < 0.5 )
	{
		level.localPlayers[0].damage_filter_intensity += 0.5 / 0.1 * 0.016667;
		if ( level.localPlayers[0].damage_filter_intensity > 0.5 )
			level.localPlayers[0].damage_filter_intensity = 0.5;
		
		filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity );				
		
		wait( 0.016667 );
	}	
}

function damage_filter_heavy( localClientNum )
{
	level endon( "damage_filter_off" );	
	
	level notify( "damage_filter_heavy" );			
		
	while ( level.localPlayers[0].damage_filter_intensity < 1 )
	{
		level.localPlayers[0].damage_filter_intensity += 0.5 / 0.1 * 0.016667;
		if ( level.localPlayers[0].damage_filter_intensity > 1 )
			level.localPlayers[0].damage_filter_intensity = 1;
		
		filter::set_filter_vehicle_damage_amount( level.localPlayers[0], 3, level.localPlayers[0].damage_filter_intensity );				
		
		wait( 0.016667 );
	}		
}
